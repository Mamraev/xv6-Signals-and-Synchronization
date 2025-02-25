#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sigaction.h"

/*TODOS :
  check about backuping mask, what happend if we change it during user signal handler
  check when killing frozen & runnable proc

*/
struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);
int is_it_sigkill(struct proc *p, int signum);
int check_cont_sig(struct proc *p);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}




int 
allocpid(void) 
{
  pushcli();
  int pid;
  do{
    pid = nextpid;
  }while (!cas(&nextpid,pid,pid+1));
  popcli();
  return pid+1;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  pushcli();

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(cas(&(p->state),UNUSED,EMBRYO)){
        goto found;
      }
    }
    popcli();
    return 0;

found:
  popcli();

  p->pid = allocpid();

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  // Task 2.1.2 :     init signal handlers to SIG_DGL
  for(int i = 0 ; i < SIGNAL_HANDLERS_SIZE ; i++){
    p->signalHandler[i] =(void*)SIG_DFL;
    p->signalHandlerMasks[i] = 0;
  }
  p->pendingSignals = 0;
  p->signalMask = 0;
  return p;
}




//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  //acquire(&ptable.lock);
  pushcli();

  if(!cas(&p->state,EMBRYO,RUNNABLE)){
    panic("user init cas err");
  }

  popcli();
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Task 2.1.2 :     Copy signal mask and signal handlers to the child
  np->signalMask = curproc->signalMask;
  np->pendingSignals = 0;

  for(int i = 0 ; i < 32 ; i++){
    np->signalHandler[i] = curproc->signalHandler[i];
    np->signalHandlerMasks[i] = curproc->signalHandlerMasks[i];
  }

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  pushcli();

  if(!cas(&np->state,EMBRYO,RUNNABLE)){
    panic("fork cas error");
  }

  popcli();

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  pushcli();
  if(!cas(&curproc->state,RUNNING,-ZOMBIE)){
    cprintf("exit cas err %d\n",curproc->state);
  }

   wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      while(p->state == -ZOMBIE);
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;  
  struct proc *curproc = myproc();
  
  pushcli();

  for(;;){
    if(!cas(&curproc->state,RUNNING,-SLEEPING)){
      cprintf("wait cas err1\n");
    }
    curproc->chan = curproc;
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      while(p->state == -ZOMBIE);
      
      if(cas(&p->state ,ZOMBIE, PRE_UNUSED)){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        if(!cas(&curproc->state,-SLEEPING,RUNNING)){
          panic("wait cas\n");

        }
        if(!cas(&p->state,PRE_UNUSED,UNUSED)){
          panic("wait cas\n");
        }
        popcli();
        return pid;
      }
    }


    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      if(!cas(&curproc->state,-SLEEPING,RUNNING)){
        panic("wait cas err\n");
      }
      curproc->chan = 0;
      popcli();
      return -1;
    }


    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
      // Go to sleep.
      
    //curproc->chan = curproc;

    sched();


    //sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

      // Handles frozen proc
      if(p->frozen){
        if(check_cont_sig(p)){
          p->frozen = 0;
        }else{
          continue;
        }
      }

      if(!cas(&p->state, RUNNABLE, -RUNNING))
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);

      cas(&p->state, -RUNNING, RUNNING);

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;

      cas(&p->state,-RUNNABLE, RUNNABLE);
      cas(&p->state,-SLEEPING, SLEEPING);
      cas(&p->state,-ZOMBIE, ZOMBIE);
    }
    popcli();

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  /*if(!holding(&ptable.lock)&&p->state!=-RUNNABLE)
    panic("sched ptable.lock");*/
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  //acquire(&ptable.lock);  //DOC: yieldlock
  pushcli();
  if(!cas(&myproc()->state,RUNNING, -RUNNABLE)){
    panic("yeild cas");
  }

  sched();

  //myproc()->state = RUNNABLE;
  popcli();
  //release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  //release(&ptable.lock);
  popcli();

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(!cas(&p->state,RUNNING,-SLEEPING)){
    panic("sleep cas");
  }


  if(lk != &ptable.lock){  //DOC: sleeplock0
    //acquire(&ptable.lock);  //DOC: sleeplock1
    pushcli();
    release(lk);
  }

  // Go to sleep.
  p->chan = chan;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    //release(&ptable.lock);
    popcli();
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->chan == chan && (p->state == SLEEPING || p->state == -SLEEPING)){
      while(p->state == -SLEEPING);
      if(cas(&p->state,SLEEPING,-RUNNABLE)){
        p->chan = 0;
        if(!cas(&p->state,-RUNNABLE,RUNNABLE)){
          panic("wakeup cas");
        }
      }
    }
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  pushcli();
  wakeup1(chan);
  popcli();
}



// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
  struct proc *p;

  if(signum<0||signum>=32){
    return -1;
  }

  // updating proc for new signal
  //acquire(&ptable.lock);
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid && p->state !=UNUSED){
      if(p->signalHandler[signum]==(void*)SIG_IGN){
        popcli();
        return 0;
      }
      p->pendingSignals |= (1 << signum);

      if((p->state == SLEEPING) || (p->state == -SLEEPING)){
        if((signum == SIGKILL) ||
        (((p->signalMask & (1 << signum)) == 0) && (p->signalHandler[signum]== (void*)SIGKILL || p->signalHandler[signum]== (void*)SIG_DFL))){
          while(p->state == -SLEEPING);
          cas(&p->state, SLEEPING, RUNNABLE);
        }
         
      }

      
      popcli();
      return 0;
    }
  }
  popcli();
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    //while(p->state == -SLEEPING);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

uint 
sigprocmask(uint sigmask){
  uint oldMask = myproc()->signalMask;
  myproc()->signalMask = sigmask;
  return oldMask;
}

int
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
  struct proc *p;
  p=myproc();
  if(oldact!=null){ 
    oldact->sa_handler = p->signalHandler[signum];
    oldact->sigmask = p->signalHandlerMasks[signum];
  } 

  p->signalHandler[signum] = act->sa_handler;
  p->signalHandlerMasks[signum] = act->sigmask;

  return 0;
}

/************************* SIGNAL HANDLERS *************************/
int
is_it_sigkill(struct proc *p, int signum){
  if(signum == SIGKILL){
    return 1;
  }
  if((p->signalMask & (1 << signum)) == 0){
    if(p->signalHandler[signum]== (void*)SIGKILL || p->signalHandler[signum]== (void*)SIG_DFL){
      return 1;
    }
  }
  cprintf("no");
  return 0;
}
int
check_cont_sig(struct proc *p){
  int def ;
  for(int i = 0 ; i < 32; i++){
     def = ((i == SIGCONT) && (p->signalHandler[i] == (void*)SIG_DFL));
    if(((p->pendingSignals & (1 << i)) != 0) && ((p->signalMask & (1 << i)) == 0) && ((p->signalHandler[i] == (void*)SIGCONT) || def)){
      p->pendingSignals = p->pendingSignals ^ (1 << i);
      return 1;
    }
  }
  return 0;
}

void 
sh_sigkill(){
  myproc()->killed = 1;
}

void
sh_sigstop(){
  myproc()->frozen = 1;
  yield();
}

void
sh_sigcont(){
  myproc()->frozen = 0;
}

void 
sigret(){
  myproc()->signalMask=myproc()->signalMaskBU;
  //memmove(&myproc()->signalMask, &myproc()->signalMaskBU, 4);
  memmove(myproc()->tf, myproc()->uTrapFrameBU, sizeof(struct trapframe));
}

void
handle_signals(struct trapframe *tf){
    struct proc* p = myproc();
    
    if(p == 0 || p == null){
      return;
    }
    if((tf->cs &3) != DPL_USER)
      return;

    if(p->killed){
      return;
    }

    for(int i = 0 ; (p->pendingSignals != 0) && i < 32 ; i++){   

      uint espbu = p->tf->esp;

      int blockable = (i != SIGKILL) && (i != SIGSTOP);

      if((p->pendingSignals & (1 << i)) != 0){

        if(((p->signalMask & (1 << i)) != 0) && blockable){
          continue; // signal is blocked and blockable
        }
        if(p->signalHandler[i]==(void*)SIG_IGN && blockable){
          continue; // signal ignored and blockable
        }

        p->pendingSignals &= ~(1 << i);

        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
          sh_sigstop();

        }else if(p->signalHandler[i] == (void*)SIGCONT || (i == SIGCONT && p->signalHandler[i] == (void*)SIG_DFL)){
          sh_sigcont();

        }else if(p->signalHandler[i] == (void*)SIGKILL || p->signalHandler[i] == (void*)SIG_DFL){
          sh_sigkill();
        }else { 
          // user signal
          p->signalMaskBU=p->signalMask;
          //memmove(&p->signalMaskBU,&p->signalMask,4);
          p->signalMask = p->signalHandlerMasks[i];



          p->tf->esp -= sizeof (struct trapframe);
          p->uTrapFrameBU = (void*) (p->tf->esp);
          memmove(p->uTrapFrameBU, p->tf, sizeof(struct trapframe));
          p->uTrapFrameBU->esp=espbu;


          // inject sigret
          p->tf->esp -= (uint)&sigret_end - (uint)&sigret_start;
          memmove((void*)p->tf->esp,sigret_start, (uint)&sigret_end - (uint)&sigret_start);
          
          //modify stack
          
          *((int*)(p->tf->esp-4)) = i;
          *((int*)(p->tf->esp-8)) = p->tf->esp;
          p->tf->esp -= 8;

          p->tf->eip = (uint)p->signalHandler[i];
          return;

        }
      }
    }
}