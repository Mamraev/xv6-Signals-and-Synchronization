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
  printf(1, "signal called!!!\n");
  printf(1, "signal called!!!\n");
  printf(1, "signal called!!!\n");
}

int
main(int argc, char *argv[]){
    struct sigaction *act= malloc(sizeof(struct sigaction*));
    act->sa_handler=signalHandler;
    printf(1, "from user %d %d\n", act->sa_handler, signalHandler);

    act->sigmask=0;
    sigaction(1,act,null);

    int pid = fork();

    if(pid != 0){
        kill(pid,1);
    }else{
            sigaction(1,act,null);

        while (1)
        {
        printf(1, "child\n");

        }
        
    }
    wait();
    printf(1, "mytest ok\n");
    exit();
    return 0;
}