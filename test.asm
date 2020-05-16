
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        printf(1, " ] [finished]\n");
    }
}

int
main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  send_signal_test();
  11:	e8 7a 00 00 00       	call   90 <send_signal_test>
  sigret_test();
  16:	e8 55 01 00 00       	call   170 <sigret_test>
  stop_cont_test();
  1b:	e8 d0 01 00 00       	call   1f0 <stop_cont_test>
  exit();
  20:	e8 cd 04 00 00       	call   4f2 <exit>
  25:	66 90                	xchg   %ax,%ax
  27:	66 90                	xchg   %ax,%ax
  29:	66 90                	xchg   %ax,%ax
  2b:	66 90                	xchg   %ax,%ax
  2d:	66 90                	xchg   %ax,%ax
  2f:	90                   	nop

00000030 <signalHandlerNoExit>:
signalHandlerNoExit(int signum){ //added
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 ec 10             	sub    $0x10,%esp
  printf(1, " C");
  36:	68 a8 09 00 00       	push   $0x9a8
  3b:	6a 01                	push   $0x1
  3d:	e8 0e 06 00 00       	call   650 <printf>
  return;
  42:	83 c4 10             	add    $0x10,%esp
}
  45:	c9                   	leave  
  46:	c3                   	ret    
  47:	89 f6                	mov    %esi,%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000050 <signalHandler>:
signalHandler(int signum){ //added
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 10             	sub    $0x10,%esp
  printf(1, " A");
  56:	68 ab 09 00 00       	push   $0x9ab
  5b:	6a 01                	push   $0x1
  5d:	e8 ee 05 00 00       	call   650 <printf>
  exit();
  62:	e8 8b 04 00 00       	call   4f2 <exit>
  67:	89 f6                	mov    %esi,%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000070 <signalHandler2>:
signalHandler2(int signum){ //added
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 ec 10             	sub    $0x10,%esp
  printf(1, "B");
  76:	68 d1 09 00 00       	push   $0x9d1
  7b:	6a 01                	push   $0x1
  7d:	e8 ce 05 00 00       	call   650 <printf>
  exit();
  82:	e8 6b 04 00 00       	call   4f2 <exit>
  87:	89 f6                	mov    %esi,%esi
  89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000090 <send_signal_test>:
send_signal_test(){
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	56                   	push   %esi
  94:	53                   	push   %ebx
    printf(1, "\n\n[start] send signal & mask test | should print : A B\n\n[");
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 d4 09 00 00       	push   $0x9d4
  9d:	6a 01                	push   $0x1
  9f:	e8 ac 05 00 00       	call   650 <printf>
    struct sigaction *act= malloc(sizeof(struct sigaction*));
  a4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  ab:	e8 00 08 00 00       	call   8b0 <malloc>
    sigaction(1,act,null);
  b0:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=signalHandler;
  b3:	c7 00 50 00 00 00    	movl   $0x50,(%eax)
    act->sigmask=0;
  b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    sigaction(1,act,null);
  c0:	6a 00                	push   $0x0
  c2:	50                   	push   %eax
    struct sigaction *act= malloc(sizeof(struct sigaction*));
  c3:	89 c3                	mov    %eax,%ebx
    sigaction(1,act,null);
  c5:	6a 01                	push   $0x1
  c7:	e8 ce 04 00 00       	call   59a <sigaction>
    sigaction(2,act,null);
  cc:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler = signalHandler2;
  cf:	c7 03 70 00 00 00    	movl   $0x70,(%ebx)
    sigaction(2,act,null);
  d5:	6a 00                	push   $0x0
  d7:	53                   	push   %ebx
  d8:	6a 02                	push   $0x2
  da:	e8 bb 04 00 00       	call   59a <sigaction>
    int pid = fork();
  df:	e8 06 04 00 00       	call   4ea <fork>
    if(pid != 0){
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	75 35                	jne    120 <send_signal_test+0x90>
        sleep(20);
  eb:	83 ec 0c             	sub    $0xc,%esp
  ee:	6a 14                	push   $0x14
  f0:	e8 8d 04 00 00       	call   582 <sleep>
  f5:	83 c4 10             	add    $0x10,%esp
    wait();
  f8:	e8 fd 03 00 00       	call   4fa <wait>
    wait();
  fd:	e8 f8 03 00 00       	call   4fa <wait>
    printf(1, " ] [finished]\n\n");
 102:	83 ec 08             	sub    $0x8,%esp
 105:	68 ae 09 00 00       	push   $0x9ae
 10a:	6a 01                	push   $0x1
 10c:	e8 3f 05 00 00       	call   650 <printf>
}
 111:	83 c4 10             	add    $0x10,%esp
 114:	8d 65 f8             	lea    -0x8(%ebp),%esp
 117:	5b                   	pop    %ebx
 118:	5e                   	pop    %esi
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    
 11b:	90                   	nop
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sigprocmask(1);
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	89 c3                	mov    %eax,%ebx
 125:	6a 01                	push   $0x1
 127:	e8 66 04 00 00       	call   592 <sigprocmask>
        pid2 = fork();
 12c:	e8 b9 03 00 00       	call   4ea <fork>
    if(pid != 0 && pid2 != 0){
 131:	83 c4 10             	add    $0x10,%esp
 134:	85 c0                	test   %eax,%eax
        pid2 = fork();
 136:	89 c6                	mov    %eax,%esi
    if(pid != 0 && pid2 != 0){
 138:	74 b1                	je     eb <send_signal_test+0x5b>
        kill(pid,1);
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	6a 01                	push   $0x1
 13f:	53                   	push   %ebx
 140:	e8 dd 03 00 00       	call   522 <kill>
        sleep(10);
 145:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 14c:	e8 31 04 00 00       	call   582 <sleep>
        kill(pid2,1);
 151:	58                   	pop    %eax
 152:	5a                   	pop    %edx
 153:	6a 01                	push   $0x1
 155:	56                   	push   %esi
 156:	e8 c7 03 00 00       	call   522 <kill>
        kill(pid2,2);
 15b:	59                   	pop    %ecx
 15c:	5b                   	pop    %ebx
 15d:	6a 02                	push   $0x2
 15f:	56                   	push   %esi
 160:	e8 bd 03 00 00       	call   522 <kill>
 165:	83 c4 10             	add    $0x10,%esp
 168:	eb 8e                	jmp    f8 <send_signal_test+0x68>
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000170 <sigret_test>:
sigret_test(){    
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	83 ec 10             	sub    $0x10,%esp
  printf(1, "\n[start] sigret test | should print :  C  \n\n[");
 176:	68 10 0a 00 00       	push   $0xa10
 17b:	6a 01                	push   $0x1
 17d:	e8 ce 04 00 00       	call   650 <printf>
  struct sigaction *act= malloc(sizeof(struct sigaction*));
 182:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 189:	e8 22 07 00 00       	call   8b0 <malloc>
  sigaction(1,act,null);
 18e:	83 c4 0c             	add    $0xc,%esp
  act->sa_handler=signalHandlerNoExit;
 191:	c7 00 30 00 00 00    	movl   $0x30,(%eax)
  act->sigmask=0;
 197:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  sigaction(1,act,null);
 19e:	6a 00                	push   $0x0
 1a0:	50                   	push   %eax
 1a1:	6a 01                	push   $0x1
 1a3:	e8 f2 03 00 00       	call   59a <sigaction>
  int pid = fork();
 1a8:	e8 3d 03 00 00       	call   4ea <fork>
  if(pid != 0){
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	85 c0                	test   %eax,%eax
 1b2:	74 14                	je     1c8 <sigret_test+0x58>
    kill(pid,1);
 1b4:	83 ec 08             	sub    $0x8,%esp
 1b7:	6a 01                	push   $0x1
 1b9:	50                   	push   %eax
 1ba:	e8 63 03 00 00       	call   522 <kill>
  wait();
 1bf:	83 c4 10             	add    $0x10,%esp
}
 1c2:	c9                   	leave  
  wait();
 1c3:	e9 32 03 00 00       	jmp    4fa <wait>
      sleep(4);
 1c8:	83 ec 0c             	sub    $0xc,%esp
 1cb:	6a 04                	push   $0x4
 1cd:	e8 b0 03 00 00       	call   582 <sleep>
      printf(1, " ] [finished]\n");
 1d2:	58                   	pop    %eax
 1d3:	5a                   	pop    %edx
 1d4:	68 be 09 00 00       	push   $0x9be
 1d9:	6a 01                	push   $0x1
 1db:	e8 70 04 00 00       	call   650 <printf>
      exit();
 1e0:	e8 0d 03 00 00       	call   4f2 <exit>
 1e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001f0 <stop_cont_test>:
stop_cont_test(){
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "\n[start] stop cont test | should print :  A B C D \n\n[");
 1f7:	68 40 0a 00 00       	push   $0xa40
 1fc:	6a 01                	push   $0x1
 1fe:	e8 4d 04 00 00       	call   650 <printf>
    int fork_id = fork();
 203:	e8 e2 02 00 00       	call   4ea <fork>
    if (fork_id == 0){
 208:	83 c4 10             	add    $0x10,%esp
 20b:	85 c0                	test   %eax,%eax
 20d:	74 68                	je     277 <stop_cont_test+0x87>
        printf(1, " A");
 20f:	83 ec 08             	sub    $0x8,%esp
 212:	89 c3                	mov    %eax,%ebx
 214:	68 ab 09 00 00       	push   $0x9ab
 219:	6a 01                	push   $0x1
 21b:	e8 30 04 00 00       	call   650 <printf>
        kill(fork_id, SIGSTOP); 
 220:	58                   	pop    %eax
 221:	5a                   	pop    %edx
 222:	6a 11                	push   $0x11
 224:	53                   	push   %ebx
 225:	e8 f8 02 00 00       	call   522 <kill>
        printf(1, " B");
 22a:	59                   	pop    %ecx
 22b:	58                   	pop    %eax
 22c:	68 d0 09 00 00       	push   $0x9d0
 231:	6a 01                	push   $0x1
 233:	e8 18 04 00 00       	call   650 <printf>
        sleep(70);
 238:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
 23f:	e8 3e 03 00 00       	call   582 <sleep>
        printf(1, " C");
 244:	58                   	pop    %eax
 245:	5a                   	pop    %edx
 246:	68 a8 09 00 00       	push   $0x9a8
 24b:	6a 01                	push   $0x1
 24d:	e8 fe 03 00 00       	call   650 <printf>
        kill(fork_id, SIGCONT); 
 252:	59                   	pop    %ecx
 253:	58                   	pop    %eax
 254:	6a 13                	push   $0x13
 256:	53                   	push   %ebx
 257:	e8 c6 02 00 00       	call   522 <kill>
        wait();
 25c:	e8 99 02 00 00       	call   4fa <wait>
        printf(1, " ] [finished]\n");
 261:	58                   	pop    %eax
 262:	5a                   	pop    %edx
 263:	68 be 09 00 00       	push   $0x9be
 268:	6a 01                	push   $0x1
 26a:	e8 e1 03 00 00       	call   650 <printf>
}
 26f:	83 c4 10             	add    $0x10,%esp
 272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 275:	c9                   	leave  
 276:	c3                   	ret    
        sleep(20); //get stop signal
 277:	83 ec 0c             	sub    $0xc,%esp
 27a:	6a 14                	push   $0x14
 27c:	e8 01 03 00 00       	call   582 <sleep>
        printf(1, " D");
 281:	59                   	pop    %ecx
 282:	5b                   	pop    %ebx
 283:	68 cd 09 00 00       	push   $0x9cd
 288:	6a 01                	push   $0x1
 28a:	e8 c1 03 00 00       	call   650 <printf>
        exit();
 28f:	e8 5e 02 00 00       	call   4f2 <exit>
 294:	66 90                	xchg   %ax,%ax
 296:	66 90                	xchg   %ax,%ax
 298:	66 90                	xchg   %ax,%ax
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	53                   	push   %ebx
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	89 c2                	mov    %eax,%edx
 2ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b0:	83 c1 01             	add    $0x1,%ecx
 2b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2b7:	83 c2 01             	add    $0x1,%edx
 2ba:	84 db                	test   %bl,%bl
 2bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 2bf:	75 ef                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2c1:	5b                   	pop    %ebx
 2c2:	5d                   	pop    %ebp
 2c3:	c3                   	ret    
 2c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	53                   	push   %ebx
 2d4:	8b 55 08             	mov    0x8(%ebp),%edx
 2d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2da:	0f b6 02             	movzbl (%edx),%eax
 2dd:	0f b6 19             	movzbl (%ecx),%ebx
 2e0:	84 c0                	test   %al,%al
 2e2:	75 1c                	jne    300 <strcmp+0x30>
 2e4:	eb 2a                	jmp    310 <strcmp+0x40>
 2e6:	8d 76 00             	lea    0x0(%esi),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2f0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2f6:	83 c1 01             	add    $0x1,%ecx
 2f9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2fc:	84 c0                	test   %al,%al
 2fe:	74 10                	je     310 <strcmp+0x40>
 300:	38 d8                	cmp    %bl,%al
 302:	74 ec                	je     2f0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 304:	29 d8                	sub    %ebx,%eax
}
 306:	5b                   	pop    %ebx
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    
 309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 310:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 312:	29 d8                	sub    %ebx,%eax
}
 314:	5b                   	pop    %ebx
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	89 f6                	mov    %esi,%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <strlen>:

uint
strlen(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 326:	80 39 00             	cmpb   $0x0,(%ecx)
 329:	74 15                	je     340 <strlen+0x20>
 32b:	31 d2                	xor    %edx,%edx
 32d:	8d 76 00             	lea    0x0(%esi),%esi
 330:	83 c2 01             	add    $0x1,%edx
 333:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 337:	89 d0                	mov    %edx,%eax
 339:	75 f5                	jne    330 <strlen+0x10>
    ;
  return n;
}
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    
 33d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 340:	31 c0                	xor    %eax,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    
 344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 34a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000350 <memset>:

void*
memset(void *dst, int c, uint n)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 357:	8b 4d 10             	mov    0x10(%ebp),%ecx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	89 d7                	mov    %edx,%edi
 35f:	fc                   	cld    
 360:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 362:	89 d0                	mov    %edx,%eax
 364:	5f                   	pop    %edi
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	89 f6                	mov    %esi,%esi
 369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000370 <strchr>:

char*
strchr(const char *s, char c)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	53                   	push   %ebx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 37a:	0f b6 10             	movzbl (%eax),%edx
 37d:	84 d2                	test   %dl,%dl
 37f:	74 1d                	je     39e <strchr+0x2e>
    if(*s == c)
 381:	38 d3                	cmp    %dl,%bl
 383:	89 d9                	mov    %ebx,%ecx
 385:	75 0d                	jne    394 <strchr+0x24>
 387:	eb 17                	jmp    3a0 <strchr+0x30>
 389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 390:	38 ca                	cmp    %cl,%dl
 392:	74 0c                	je     3a0 <strchr+0x30>
  for(; *s; s++)
 394:	83 c0 01             	add    $0x1,%eax
 397:	0f b6 10             	movzbl (%eax),%edx
 39a:	84 d2                	test   %dl,%dl
 39c:	75 f2                	jne    390 <strchr+0x20>
      return (char*)s;
  return 0;
 39e:	31 c0                	xor    %eax,%eax
}
 3a0:	5b                   	pop    %ebx
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b6:	31 f6                	xor    %esi,%esi
 3b8:	89 f3                	mov    %esi,%ebx
{
 3ba:	83 ec 1c             	sub    $0x1c,%esp
 3bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c0:	eb 2f                	jmp    3f1 <gets+0x41>
 3c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3cb:	83 ec 04             	sub    $0x4,%esp
 3ce:	6a 01                	push   $0x1
 3d0:	50                   	push   %eax
 3d1:	6a 00                	push   $0x0
 3d3:	e8 32 01 00 00       	call   50a <read>
    if(cc < 1)
 3d8:	83 c4 10             	add    $0x10,%esp
 3db:	85 c0                	test   %eax,%eax
 3dd:	7e 1c                	jle    3fb <gets+0x4b>
      break;
    buf[i++] = c;
 3df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e3:	83 c7 01             	add    $0x1,%edi
 3e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3e9:	3c 0a                	cmp    $0xa,%al
 3eb:	74 23                	je     410 <gets+0x60>
 3ed:	3c 0d                	cmp    $0xd,%al
 3ef:	74 1f                	je     410 <gets+0x60>
  for(i=0; i+1 < max; ){
 3f1:	83 c3 01             	add    $0x1,%ebx
 3f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3f7:	89 fe                	mov    %edi,%esi
 3f9:	7c cd                	jl     3c8 <gets+0x18>
 3fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 400:	c6 03 00             	movb   $0x0,(%ebx)
}
 403:	8d 65 f4             	lea    -0xc(%ebp),%esp
 406:	5b                   	pop    %ebx
 407:	5e                   	pop    %esi
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    
 40b:	90                   	nop
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 410:	8b 75 08             	mov    0x8(%ebp),%esi
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	01 de                	add    %ebx,%esi
 418:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 41a:	c6 03 00             	movb   $0x0,(%ebx)
}
 41d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 420:	5b                   	pop    %ebx
 421:	5e                   	pop    %esi
 422:	5f                   	pop    %edi
 423:	5d                   	pop    %ebp
 424:	c3                   	ret    
 425:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000430 <stat>:

int
stat(const char *n, struct stat *st)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 435:	83 ec 08             	sub    $0x8,%esp
 438:	6a 00                	push   $0x0
 43a:	ff 75 08             	pushl  0x8(%ebp)
 43d:	e8 f0 00 00 00       	call   532 <open>
  if(fd < 0)
 442:	83 c4 10             	add    $0x10,%esp
 445:	85 c0                	test   %eax,%eax
 447:	78 27                	js     470 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	ff 75 0c             	pushl  0xc(%ebp)
 44f:	89 c3                	mov    %eax,%ebx
 451:	50                   	push   %eax
 452:	e8 f3 00 00 00       	call   54a <fstat>
  close(fd);
 457:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 45a:	89 c6                	mov    %eax,%esi
  close(fd);
 45c:	e8 b9 00 00 00       	call   51a <close>
  return r;
 461:	83 c4 10             	add    $0x10,%esp
}
 464:	8d 65 f8             	lea    -0x8(%ebp),%esp
 467:	89 f0                	mov    %esi,%eax
 469:	5b                   	pop    %ebx
 46a:	5e                   	pop    %esi
 46b:	5d                   	pop    %ebp
 46c:	c3                   	ret    
 46d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 470:	be ff ff ff ff       	mov    $0xffffffff,%esi
 475:	eb ed                	jmp    464 <stat+0x34>
 477:	89 f6                	mov    %esi,%esi
 479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <atoi>:

int
atoi(const char *s)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 487:	0f be 11             	movsbl (%ecx),%edx
 48a:	8d 42 d0             	lea    -0x30(%edx),%eax
 48d:	3c 09                	cmp    $0x9,%al
  n = 0;
 48f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 494:	77 1f                	ja     4b5 <atoi+0x35>
 496:	8d 76 00             	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 4a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4a3:	83 c1 01             	add    $0x1,%ecx
 4a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4aa:	0f be 11             	movsbl (%ecx),%edx
 4ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4b0:	80 fb 09             	cmp    $0x9,%bl
 4b3:	76 eb                	jbe    4a0 <atoi+0x20>
  return n;
}
 4b5:	5b                   	pop    %ebx
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    
 4b8:	90                   	nop
 4b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
 4c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	85 db                	test   %ebx,%ebx
 4d0:	7e 14                	jle    4e6 <memmove+0x26>
 4d2:	31 d2                	xor    %edx,%edx
 4d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4df:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4e2:	39 d3                	cmp    %edx,%ebx
 4e4:	75 f2                	jne    4d8 <memmove+0x18>
  return vdst;
}
 4e6:	5b                   	pop    %ebx
 4e7:	5e                   	pop    %esi
 4e8:	5d                   	pop    %ebp
 4e9:	c3                   	ret    

000004ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ea:	b8 01 00 00 00       	mov    $0x1,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <exit>:
SYSCALL(exit)
 4f2:	b8 02 00 00 00       	mov    $0x2,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <wait>:
SYSCALL(wait)
 4fa:	b8 03 00 00 00       	mov    $0x3,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <pipe>:
SYSCALL(pipe)
 502:	b8 04 00 00 00       	mov    $0x4,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <read>:
SYSCALL(read)
 50a:	b8 05 00 00 00       	mov    $0x5,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <write>:
SYSCALL(write)
 512:	b8 10 00 00 00       	mov    $0x10,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <close>:
SYSCALL(close)
 51a:	b8 15 00 00 00       	mov    $0x15,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <kill>:
SYSCALL(kill)
 522:	b8 06 00 00 00       	mov    $0x6,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <exec>:
SYSCALL(exec)
 52a:	b8 07 00 00 00       	mov    $0x7,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <open>:
SYSCALL(open)
 532:	b8 0f 00 00 00       	mov    $0xf,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mknod>:
SYSCALL(mknod)
 53a:	b8 11 00 00 00       	mov    $0x11,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <unlink>:
SYSCALL(unlink)
 542:	b8 12 00 00 00       	mov    $0x12,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <fstat>:
SYSCALL(fstat)
 54a:	b8 08 00 00 00       	mov    $0x8,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <link>:
SYSCALL(link)
 552:	b8 13 00 00 00       	mov    $0x13,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <mkdir>:
SYSCALL(mkdir)
 55a:	b8 14 00 00 00       	mov    $0x14,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <chdir>:
SYSCALL(chdir)
 562:	b8 09 00 00 00       	mov    $0x9,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <dup>:
SYSCALL(dup)
 56a:	b8 0a 00 00 00       	mov    $0xa,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <getpid>:
SYSCALL(getpid)
 572:	b8 0b 00 00 00       	mov    $0xb,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <sbrk>:
SYSCALL(sbrk)
 57a:	b8 0c 00 00 00       	mov    $0xc,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <sleep>:
SYSCALL(sleep)
 582:	b8 0d 00 00 00       	mov    $0xd,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <uptime>:
SYSCALL(uptime)
 58a:	b8 0e 00 00 00       	mov    $0xe,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <sigprocmask>:
SYSCALL(sigprocmask)
 592:	b8 16 00 00 00       	mov    $0x16,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <sigaction>:
SYSCALL(sigaction)
 59a:	b8 17 00 00 00       	mov    $0x17,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <sigret>:
SYSCALL(sigret)
 5a2:	b8 18 00 00 00       	mov    $0x18,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    
 5aa:	66 90                	xchg   %ax,%ax
 5ac:	66 90                	xchg   %ax,%ax
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	53                   	push   %ebx
 5b6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5b9:	85 d2                	test   %edx,%edx
{
 5bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 5be:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5c0:	79 76                	jns    638 <printint+0x88>
 5c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5c6:	74 70                	je     638 <printint+0x88>
    x = -xx;
 5c8:	f7 d8                	neg    %eax
    neg = 1;
 5ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5d1:	31 f6                	xor    %esi,%esi
 5d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5d6:	eb 0a                	jmp    5e2 <printint+0x32>
 5d8:	90                   	nop
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5e0:	89 fe                	mov    %edi,%esi
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	8d 7e 01             	lea    0x1(%esi),%edi
 5e7:	f7 f1                	div    %ecx
 5e9:	0f b6 92 80 0a 00 00 	movzbl 0xa80(%edx),%edx
  }while((x /= base) != 0);
 5f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 5f5:	75 e9                	jne    5e0 <printint+0x30>
  if(neg)
 5f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 5fa:	85 c0                	test   %eax,%eax
 5fc:	74 08                	je     606 <printint+0x56>
    buf[i++] = '-';
 5fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 603:	8d 7e 02             	lea    0x2(%esi),%edi
 606:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 60a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 60d:	8d 76 00             	lea    0x0(%esi),%esi
 610:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
 616:	83 ee 01             	sub    $0x1,%esi
 619:	6a 01                	push   $0x1
 61b:	53                   	push   %ebx
 61c:	57                   	push   %edi
 61d:	88 45 d7             	mov    %al,-0x29(%ebp)
 620:	e8 ed fe ff ff       	call   512 <write>

  while(--i >= 0)
 625:	83 c4 10             	add    $0x10,%esp
 628:	39 de                	cmp    %ebx,%esi
 62a:	75 e4                	jne    610 <printint+0x60>
    putc(fd, buf[i]);
}
 62c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62f:	5b                   	pop    %ebx
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret    
 634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 638:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 63f:	eb 90                	jmp    5d1 <printint+0x21>
 641:	eb 0d                	jmp    650 <printf>
 643:	90                   	nop
 644:	90                   	nop
 645:	90                   	nop
 646:	90                   	nop
 647:	90                   	nop
 648:	90                   	nop
 649:	90                   	nop
 64a:	90                   	nop
 64b:	90                   	nop
 64c:	90                   	nop
 64d:	90                   	nop
 64e:	90                   	nop
 64f:	90                   	nop

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
 654:	56                   	push   %esi
 655:	53                   	push   %ebx
 656:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 659:	8b 75 0c             	mov    0xc(%ebp),%esi
 65c:	0f b6 1e             	movzbl (%esi),%ebx
 65f:	84 db                	test   %bl,%bl
 661:	0f 84 b3 00 00 00    	je     71a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 667:	8d 45 10             	lea    0x10(%ebp),%eax
 66a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 66d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 66f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 672:	eb 2f                	jmp    6a3 <printf+0x53>
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 678:	83 f8 25             	cmp    $0x25,%eax
 67b:	0f 84 a7 00 00 00    	je     728 <printf+0xd8>
  write(fd, &c, 1);
 681:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 684:	83 ec 04             	sub    $0x4,%esp
 687:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 68a:	6a 01                	push   $0x1
 68c:	50                   	push   %eax
 68d:	ff 75 08             	pushl  0x8(%ebp)
 690:	e8 7d fe ff ff       	call   512 <write>
 695:	83 c4 10             	add    $0x10,%esp
 698:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 69b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 69f:	84 db                	test   %bl,%bl
 6a1:	74 77                	je     71a <printf+0xca>
    if(state == 0){
 6a3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 6a5:	0f be cb             	movsbl %bl,%ecx
 6a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6ab:	74 cb                	je     678 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ad:	83 ff 25             	cmp    $0x25,%edi
 6b0:	75 e6                	jne    698 <printf+0x48>
      if(c == 'd'){
 6b2:	83 f8 64             	cmp    $0x64,%eax
 6b5:	0f 84 05 01 00 00    	je     7c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6c1:	83 f9 70             	cmp    $0x70,%ecx
 6c4:	74 72                	je     738 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6c6:	83 f8 73             	cmp    $0x73,%eax
 6c9:	0f 84 99 00 00 00    	je     768 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cf:	83 f8 63             	cmp    $0x63,%eax
 6d2:	0f 84 08 01 00 00    	je     7e0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6d8:	83 f8 25             	cmp    $0x25,%eax
 6db:	0f 84 ef 00 00 00    	je     7d0 <printf+0x180>
  write(fd, &c, 1);
 6e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6e4:	83 ec 04             	sub    $0x4,%esp
 6e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6eb:	6a 01                	push   $0x1
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	pushl  0x8(%ebp)
 6f1:	e8 1c fe ff ff       	call   512 <write>
 6f6:	83 c4 0c             	add    $0xc,%esp
 6f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 6ff:	6a 01                	push   $0x1
 701:	50                   	push   %eax
 702:	ff 75 08             	pushl  0x8(%ebp)
 705:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 708:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 70a:	e8 03 fe ff ff       	call   512 <write>
  for(i = 0; fmt[i]; i++){
 70f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 713:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 716:	84 db                	test   %bl,%bl
 718:	75 89                	jne    6a3 <printf+0x53>
    }
  }
}
 71a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 71d:	5b                   	pop    %ebx
 71e:	5e                   	pop    %esi
 71f:	5f                   	pop    %edi
 720:	5d                   	pop    %ebp
 721:	c3                   	ret    
 722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 728:	bf 25 00 00 00       	mov    $0x25,%edi
 72d:	e9 66 ff ff ff       	jmp    698 <printf+0x48>
 732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 738:	83 ec 0c             	sub    $0xc,%esp
 73b:	b9 10 00 00 00       	mov    $0x10,%ecx
 740:	6a 00                	push   $0x0
 742:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	8b 17                	mov    (%edi),%edx
 74a:	e8 61 fe ff ff       	call   5b0 <printint>
        ap++;
 74f:	89 f8                	mov    %edi,%eax
 751:	83 c4 10             	add    $0x10,%esp
      state = 0;
 754:	31 ff                	xor    %edi,%edi
        ap++;
 756:	83 c0 04             	add    $0x4,%eax
 759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 75c:	e9 37 ff ff ff       	jmp    698 <printf+0x48>
 761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 76b:	8b 08                	mov    (%eax),%ecx
        ap++;
 76d:	83 c0 04             	add    $0x4,%eax
 770:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 773:	85 c9                	test   %ecx,%ecx
 775:	0f 84 8e 00 00 00    	je     809 <printf+0x1b9>
        while(*s != 0){
 77b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 77e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 780:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 782:	84 c0                	test   %al,%al
 784:	0f 84 0e ff ff ff    	je     698 <printf+0x48>
 78a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 78d:	89 de                	mov    %ebx,%esi
 78f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 792:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 795:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 798:	83 ec 04             	sub    $0x4,%esp
          s++;
 79b:	83 c6 01             	add    $0x1,%esi
 79e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 7a1:	6a 01                	push   $0x1
 7a3:	57                   	push   %edi
 7a4:	53                   	push   %ebx
 7a5:	e8 68 fd ff ff       	call   512 <write>
        while(*s != 0){
 7aa:	0f b6 06             	movzbl (%esi),%eax
 7ad:	83 c4 10             	add    $0x10,%esp
 7b0:	84 c0                	test   %al,%al
 7b2:	75 e4                	jne    798 <printf+0x148>
 7b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7b7:	31 ff                	xor    %edi,%edi
 7b9:	e9 da fe ff ff       	jmp    698 <printf+0x48>
 7be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7c0:	83 ec 0c             	sub    $0xc,%esp
 7c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7c8:	6a 01                	push   $0x1
 7ca:	e9 73 ff ff ff       	jmp    742 <printf+0xf2>
 7cf:	90                   	nop
  write(fd, &c, 1);
 7d0:	83 ec 04             	sub    $0x4,%esp
 7d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7d9:	6a 01                	push   $0x1
 7db:	e9 21 ff ff ff       	jmp    701 <printf+0xb1>
        putc(fd, *ap);
 7e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7e6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7e8:	6a 01                	push   $0x1
        ap++;
 7ea:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 7f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 7f3:	50                   	push   %eax
 7f4:	ff 75 08             	pushl  0x8(%ebp)
 7f7:	e8 16 fd ff ff       	call   512 <write>
        ap++;
 7fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 7ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 802:	31 ff                	xor    %edi,%edi
 804:	e9 8f fe ff ff       	jmp    698 <printf+0x48>
          s = "(null)";
 809:	bb 78 0a 00 00       	mov    $0xa78,%ebx
        while(*s != 0){
 80e:	b8 28 00 00 00       	mov    $0x28,%eax
 813:	e9 72 ff ff ff       	jmp    78a <printf+0x13a>
 818:	66 90                	xchg   %ax,%ax
 81a:	66 90                	xchg   %ax,%ax
 81c:	66 90                	xchg   %ax,%ax
 81e:	66 90                	xchg   %ax,%ax

00000820 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 820:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 821:	a1 f4 0d 00 00       	mov    0xdf4,%eax
{
 826:	89 e5                	mov    %esp,%ebp
 828:	57                   	push   %edi
 829:	56                   	push   %esi
 82a:	53                   	push   %ebx
 82b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 82e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	39 c8                	cmp    %ecx,%eax
 83a:	8b 10                	mov    (%eax),%edx
 83c:	73 32                	jae    870 <free+0x50>
 83e:	39 d1                	cmp    %edx,%ecx
 840:	72 04                	jb     846 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	39 d0                	cmp    %edx,%eax
 844:	72 32                	jb     878 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 846:	8b 73 fc             	mov    -0x4(%ebx),%esi
 849:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 84c:	39 fa                	cmp    %edi,%edx
 84e:	74 30                	je     880 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 850:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 853:	8b 50 04             	mov    0x4(%eax),%edx
 856:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 859:	39 f1                	cmp    %esi,%ecx
 85b:	74 3a                	je     897 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 85d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 85f:	a3 f4 0d 00 00       	mov    %eax,0xdf4
}
 864:	5b                   	pop    %ebx
 865:	5e                   	pop    %esi
 866:	5f                   	pop    %edi
 867:	5d                   	pop    %ebp
 868:	c3                   	ret    
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	39 d0                	cmp    %edx,%eax
 872:	72 04                	jb     878 <free+0x58>
 874:	39 d1                	cmp    %edx,%ecx
 876:	72 ce                	jb     846 <free+0x26>
{
 878:	89 d0                	mov    %edx,%eax
 87a:	eb bc                	jmp    838 <free+0x18>
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 880:	03 72 04             	add    0x4(%edx),%esi
 883:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 12                	mov    (%edx),%edx
 88a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 88d:	8b 50 04             	mov    0x4(%eax),%edx
 890:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 893:	39 f1                	cmp    %esi,%ecx
 895:	75 c6                	jne    85d <free+0x3d>
    p->s.size += bp->s.size;
 897:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 89a:	a3 f4 0d 00 00       	mov    %eax,0xdf4
    p->s.size += bp->s.size;
 89f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8a5:	89 10                	mov    %edx,(%eax)
}
 8a7:	5b                   	pop    %ebx
 8a8:	5e                   	pop    %esi
 8a9:	5f                   	pop    %edi
 8aa:	5d                   	pop    %ebp
 8ab:	c3                   	ret    
 8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	56                   	push   %esi
 8b5:	53                   	push   %ebx
 8b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8bc:	8b 15 f4 0d 00 00    	mov    0xdf4,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c2:	8d 78 07             	lea    0x7(%eax),%edi
 8c5:	c1 ef 03             	shr    $0x3,%edi
 8c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8cb:	85 d2                	test   %edx,%edx
 8cd:	0f 84 9d 00 00 00    	je     970 <malloc+0xc0>
 8d3:	8b 02                	mov    (%edx),%eax
 8d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8d8:	39 cf                	cmp    %ecx,%edi
 8da:	76 6c                	jbe    948 <malloc+0x98>
 8dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 8f1:	eb 0e                	jmp    901 <malloc+0x51>
 8f3:	90                   	nop
 8f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8fa:	8b 48 04             	mov    0x4(%eax),%ecx
 8fd:	39 f9                	cmp    %edi,%ecx
 8ff:	73 47                	jae    948 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 901:	39 05 f4 0d 00 00    	cmp    %eax,0xdf4
 907:	89 c2                	mov    %eax,%edx
 909:	75 ed                	jne    8f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 90b:	83 ec 0c             	sub    $0xc,%esp
 90e:	56                   	push   %esi
 90f:	e8 66 fc ff ff       	call   57a <sbrk>
  if(p == (char*)-1)
 914:	83 c4 10             	add    $0x10,%esp
 917:	83 f8 ff             	cmp    $0xffffffff,%eax
 91a:	74 1c                	je     938 <malloc+0x88>
  hp->s.size = nu;
 91c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 91f:	83 ec 0c             	sub    $0xc,%esp
 922:	83 c0 08             	add    $0x8,%eax
 925:	50                   	push   %eax
 926:	e8 f5 fe ff ff       	call   820 <free>
  return freep;
 92b:	8b 15 f4 0d 00 00    	mov    0xdf4,%edx
      if((p = morecore(nunits)) == 0)
 931:	83 c4 10             	add    $0x10,%esp
 934:	85 d2                	test   %edx,%edx
 936:	75 c0                	jne    8f8 <malloc+0x48>
        return 0;
  }
}
 938:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 93b:	31 c0                	xor    %eax,%eax
}
 93d:	5b                   	pop    %ebx
 93e:	5e                   	pop    %esi
 93f:	5f                   	pop    %edi
 940:	5d                   	pop    %ebp
 941:	c3                   	ret    
 942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 948:	39 cf                	cmp    %ecx,%edi
 94a:	74 54                	je     9a0 <malloc+0xf0>
        p->s.size -= nunits;
 94c:	29 f9                	sub    %edi,%ecx
 94e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 951:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 954:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 957:	89 15 f4 0d 00 00    	mov    %edx,0xdf4
}
 95d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 960:	83 c0 08             	add    $0x8,%eax
}
 963:	5b                   	pop    %ebx
 964:	5e                   	pop    %esi
 965:	5f                   	pop    %edi
 966:	5d                   	pop    %ebp
 967:	c3                   	ret    
 968:	90                   	nop
 969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 970:	c7 05 f4 0d 00 00 f8 	movl   $0xdf8,0xdf4
 977:	0d 00 00 
 97a:	c7 05 f8 0d 00 00 f8 	movl   $0xdf8,0xdf8
 981:	0d 00 00 
    base.s.size = 0;
 984:	b8 f8 0d 00 00       	mov    $0xdf8,%eax
 989:	c7 05 fc 0d 00 00 00 	movl   $0x0,0xdfc
 990:	00 00 00 
 993:	e9 44 ff ff ff       	jmp    8dc <malloc+0x2c>
 998:	90                   	nop
 999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 9a0:	8b 08                	mov    (%eax),%ecx
 9a2:	89 0a                	mov    %ecx,(%edx)
 9a4:	eb b1                	jmp    957 <malloc+0xa7>
