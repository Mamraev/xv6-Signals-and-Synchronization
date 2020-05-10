#include "syscall.h"
#include "traps.h"

.globl sigret_start
.globl sigret_end

sigret_start: 
  movl $SYS_sigret, %eax; 
  int $T_SYSCALL; 
sigret_end:
