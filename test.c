#include "param.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"
#include "syscall.h"
#include "traps.h"
#include "memlayout.h"
#include "sigaction.h" // added

void 
signalHandler(int signum){ //added
  printf(1, " A");
  exit();
}

void 
signalHandler2(int signum){ //added
  printf(1, "B");
  exit();
}

void 
signalHandlerNoExit(int signum){ //added
  printf(1, " C");
  return;
}
void
send_signal_test(){
    printf(1, "\n\n[start] send signal & mask test | should print : A B\n\n[");

    struct sigaction *act= malloc(sizeof(struct sigaction*));
    act->sa_handler=signalHandler;

    act->sigmask=0;
    sigaction(1,act,null);
    act->sa_handler = signalHandler2;
    sigaction(2,act,null);

    int pid = fork();
    int pid2 = 0;
    if(pid != 0){
        sigprocmask(1);
        pid2 = fork();
    }

    if(pid != 0 && pid2 != 0){
        kill(pid,1);
        sleep(10);
        kill(pid2,1);
        kill(pid2,2);

    }else{
        sleep(20);
    }
    wait();
    wait();
    printf(1, " ] [finished]\n\n");
}

void
sigret_test(){    
  printf(1, "\n[start] sigret test | should print :  C  \n\n[");

  struct sigaction *act= malloc(sizeof(struct sigaction*));
  act->sa_handler=signalHandlerNoExit;

  act->sigmask=0;
  sigaction(1,act,null);
  int pid = fork();

  if(pid != 0){
    kill(pid,1);
  }else{
      sleep(4);
      printf(1, " ] [finished]\n");
      exit();

  }
  wait();

}

void
stop_cont_test(){
    printf(1, "\n[start] stop cont test | should print :  A B C D \n\n[");

    int fork_id = fork();
    if (fork_id == 0){
        sleep(20); //get stop signal
        printf(1, " D");
        exit();
    }
    else{
        printf(1, " A");
        kill(fork_id, SIGSTOP); 
        printf(1, " B");
        sleep(70);
        printf(1, " C");
        kill(fork_id, SIGCONT); 
        wait();
        printf(1, " ] [finished]\n");
    }
}

int
main(int argc, char *argv[]){
  send_signal_test();
  sigret_test();
  stop_cont_test();
  exit();
}