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
  printf(1, "\n---- user signal works");

  exit();
}

void 
signalHandler2(int signum){ //added
  printf(1, "\n---- block mask works");

  exit();
}

void 
signalHandlerNoExit(int signum){ //added
  printf(1, "\n---- user signal works NO EXIT");
  return;
}
void
send_signal_test(){
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
        kill(pid2,1);
        kill(pid2,2);

    }else{
        while (1)
        {
        printf(1, " ");

        }
        
    }
    wait();
    wait();
    printf(1, "\n[finished] send signal test\n");
    exit();
}

void
sigret_test(){    
  struct sigaction *act= malloc(sizeof(struct sigaction*));
  act->sa_handler=signalHandlerNoExit;

  act->sigmask=0;
  sigaction(1,act,null);
  int pid = fork();

  if(pid != 0){
    kill(pid,1);
  }else{
      sleep(4);
      printf(1, "\n[finished] sigret_test test (should see this after user signal)\n");
      exit();

  }
  wait();
  exit();

}

int
main(int argc, char *argv[]){
  //send_signal_test();
  sigret_test();
  exit();
}