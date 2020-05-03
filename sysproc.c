#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &signum) < 0)
    return -1;
  return kill(pid,SIGKILL);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_sigprocmask(void){
  int sigmask;
  if(argint(0, &sigmask) < 0)
    return -1;
  return sigprocmask((uint)sigmask);
}

int
sys_sigaction(void){
  int signum;
  struct sigaction* act;
  struct sigaction* oldact;

  if(argint(0, &signum) < 0)
    return -1;
    
  if(signum==SIGKILL||signum==SIGSTOP||signum<0||signum>=SIGNAL_HANDLERS_SIZE)
    return -1;

  if(argptr(1 , (void*)&act ,sizeof(*sigaction)) < 0){
    return -1;
  }
  if(argptr(2 , (void*)&oldact ,sizeof(*sigaction)) < 0){
    return -1;
  }

  if(oldact!=NULL){
    oldact = myproc()->signalHandler[signum];
  }
  return sigaction(signum, act, oldact);
}