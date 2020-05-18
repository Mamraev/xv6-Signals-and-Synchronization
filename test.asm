
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
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
  11:	e8 7a 01 00 00       	call   190 <send_signal_test>
  sigret_test();
  16:	e8 55 02 00 00       	call   270 <sigret_test>
  stop_cont_test();
  1b:	e8 d0 02 00 00       	call   2f0 <stop_cont_test>
  inner_mask_test();
  20:	e8 9b 00 00 00       	call   c0 <inner_mask_test>

  old_act_test();
  25:	e8 76 03 00 00       	call   3a0 <old_act_test>
  modify_test();
  2a:	e8 41 04 00 00       	call   470 <modify_test>

  exit();
  2f:	e8 4e 07 00 00       	call   782 <exit>
  34:	66 90                	xchg   %ax,%ax
  36:	66 90                	xchg   %ax,%ax
  38:	66 90                	xchg   %ax,%ax
  3a:	66 90                	xchg   %ax,%ax
  3c:	66 90                	xchg   %ax,%ax
  3e:	66 90                	xchg   %ax,%ax

00000040 <signalHandlerNoExit>:
signalHandlerNoExit(int signum){ //added
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	83 ec 10             	sub    $0x10,%esp
  printf(1, " C");
  46:	68 38 0c 00 00       	push   $0xc38
  4b:	6a 01                	push   $0x1
  4d:	e8 8e 08 00 00       	call   8e0 <printf>
  return;
  52:	83 c4 10             	add    $0x10,%esp
}
  55:	c9                   	leave  
  56:	c3                   	ret    
  57:	89 f6                	mov    %esi,%esi
  59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <signalHandler>:
signalHandler(int signum){ //added
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	83 ec 10             	sub    $0x10,%esp
  printf(1, " A");
  66:	68 3b 0c 00 00       	push   $0xc3b
  6b:	6a 01                	push   $0x1
  6d:	e8 6e 08 00 00       	call   8e0 <printf>
  exit();
  72:	e8 0b 07 00 00       	call   782 <exit>
  77:	89 f6                	mov    %esi,%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000080 <signalHandler2>:
signalHandler2(int signum){ //added
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	83 ec 10             	sub    $0x10,%esp
  printf(1, "B");
  86:	68 3f 0c 00 00       	push   $0xc3f
  8b:	6a 01                	push   $0x1
  8d:	e8 4e 08 00 00       	call   8e0 <printf>
  exit();
  92:	e8 eb 06 00 00       	call   782 <exit>
  97:	89 f6                	mov    %esi,%esi
  99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000a0 <signalHandlerWait>:
signalHandlerWait(int signum){ //added
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	83 ec 14             	sub    $0x14,%esp
  sleep(50);
  a6:	6a 32                	push   $0x32
  a8:	e8 65 07 00 00       	call   812 <sleep>
  printf(1, " A");
  ad:	58                   	pop    %eax
  ae:	5a                   	pop    %edx
  af:	68 3b 0c 00 00       	push   $0xc3b
  b4:	6a 01                	push   $0x1
  b6:	e8 25 08 00 00       	call   8e0 <printf>
  return;
  bb:	83 c4 10             	add    $0x10,%esp
}
  be:	c9                   	leave  
  bf:	c3                   	ret    

000000c0 <inner_mask_test>:
inner_mask_test(){
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	53                   	push   %ebx
  c4:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "\n\n[start] inner mask test | should print : A B\n\n[");
  c7:	68 78 0c 00 00       	push   $0xc78
  cc:	6a 01                	push   $0x1
  ce:	e8 0d 08 00 00       	call   8e0 <printf>
    struct sigaction *act= malloc(sizeof(struct sigaction*));
  d3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  da:	e8 61 0a 00 00       	call   b40 <malloc>
    sigaction(2,act,null);
  df:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=signalHandlerWait;
  e2:	c7 00 a0 00 00 00    	movl   $0xa0,(%eax)
    act->sigmask=1 << 1;
  e8:	c7 40 04 02 00 00 00 	movl   $0x2,0x4(%eax)
    sigaction(2,act,null);
  ef:	6a 00                	push   $0x0
  f1:	50                   	push   %eax
    struct sigaction *act= malloc(sizeof(struct sigaction*));
  f2:	89 c3                	mov    %eax,%ebx
    sigaction(2,act,null);
  f4:	6a 02                	push   $0x2
  f6:	e8 2f 07 00 00       	call   82a <sigaction>
    sigaction(1,act,null);
  fb:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=(void*)SIGSTOP;
  fe:	c7 03 11 00 00 00    	movl   $0x11,(%ebx)
    act->sigmask=0;
 104:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
    sigaction(1,act,null);
 10b:	6a 00                	push   $0x0
 10d:	53                   	push   %ebx
 10e:	6a 01                	push   $0x1
 110:	e8 15 07 00 00       	call   82a <sigaction>
    int pid = fork();
 115:	e8 60 06 00 00       	call   77a <fork>
    if(pid == 0){
 11a:	83 c4 10             	add    $0x10,%esp
 11d:	85 c0                	test   %eax,%eax
 11f:	74 48                	je     169 <inner_mask_test+0xa9>
    kill(pid,2);
 121:	83 ec 08             	sub    $0x8,%esp
 124:	89 c3                	mov    %eax,%ebx
 126:	6a 02                	push   $0x2
 128:	50                   	push   %eax
 129:	e8 84 06 00 00       	call   7b2 <kill>
    kill(pid,1);
 12e:	58                   	pop    %eax
 12f:	5a                   	pop    %edx
 130:	6a 01                	push   $0x1
 132:	53                   	push   %ebx
 133:	e8 7a 06 00 00       	call   7b2 <kill>
    sleep(100);
 138:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 13f:	e8 ce 06 00 00       	call   812 <sleep>
    kill(pid,SIGCONT);
 144:	59                   	pop    %ecx
 145:	58                   	pop    %eax
 146:	6a 13                	push   $0x13
 148:	53                   	push   %ebx
 149:	e8 64 06 00 00       	call   7b2 <kill>
    wait();
 14e:	e8 37 06 00 00       	call   78a <wait>
    printf(1, " ] [finished]\n\n");
 153:	58                   	pop    %eax
 154:	5a                   	pop    %edx
 155:	68 41 0c 00 00       	push   $0xc41
 15a:	6a 01                	push   $0x1
 15c:	e8 7f 07 00 00       	call   8e0 <printf>
}
 161:	83 c4 10             	add    $0x10,%esp
 164:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 167:	c9                   	leave  
 168:	c3                   	ret    
      sleep(10);
 169:	83 ec 0c             	sub    $0xc,%esp
 16c:	6a 0a                	push   $0xa
 16e:	e8 9f 06 00 00       	call   812 <sleep>
      printf(1," B");
 173:	59                   	pop    %ecx
 174:	5b                   	pop    %ebx
 175:	68 3e 0c 00 00       	push   $0xc3e
 17a:	6a 01                	push   $0x1
 17c:	e8 5f 07 00 00       	call   8e0 <printf>
      exit();
 181:	e8 fc 05 00 00       	call   782 <exit>
 186:	8d 76 00             	lea    0x0(%esi),%esi
 189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000190 <send_signal_test>:
send_signal_test(){
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
    printf(1, "\n\n[start] send signal & mask test | should print : A B\n\n[");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 ac 0c 00 00       	push   $0xcac
 19d:	6a 01                	push   $0x1
 19f:	e8 3c 07 00 00       	call   8e0 <printf>
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 1a4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 1ab:	e8 90 09 00 00       	call   b40 <malloc>
    sigaction(1,act,null);
 1b0:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=signalHandler;
 1b3:	c7 00 60 00 00 00    	movl   $0x60,(%eax)
    act->sigmask=0;
 1b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    sigaction(1,act,null);
 1c0:	6a 00                	push   $0x0
 1c2:	50                   	push   %eax
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 1c3:	89 c3                	mov    %eax,%ebx
    sigaction(1,act,null);
 1c5:	6a 01                	push   $0x1
 1c7:	e8 5e 06 00 00       	call   82a <sigaction>
    sigaction(2,act,null);
 1cc:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler = signalHandler2;
 1cf:	c7 03 80 00 00 00    	movl   $0x80,(%ebx)
    sigaction(2,act,null);
 1d5:	6a 00                	push   $0x0
 1d7:	53                   	push   %ebx
 1d8:	6a 02                	push   $0x2
 1da:	e8 4b 06 00 00       	call   82a <sigaction>
    int pid = fork();
 1df:	e8 96 05 00 00       	call   77a <fork>
    if(pid != 0){
 1e4:	83 c4 10             	add    $0x10,%esp
 1e7:	85 c0                	test   %eax,%eax
 1e9:	75 35                	jne    220 <send_signal_test+0x90>
        sleep(20);
 1eb:	83 ec 0c             	sub    $0xc,%esp
 1ee:	6a 14                	push   $0x14
 1f0:	e8 1d 06 00 00       	call   812 <sleep>
 1f5:	83 c4 10             	add    $0x10,%esp
    wait();
 1f8:	e8 8d 05 00 00       	call   78a <wait>
    wait();
 1fd:	e8 88 05 00 00       	call   78a <wait>
    printf(1, " ] [finished]\n\n");
 202:	83 ec 08             	sub    $0x8,%esp
 205:	68 41 0c 00 00       	push   $0xc41
 20a:	6a 01                	push   $0x1
 20c:	e8 cf 06 00 00       	call   8e0 <printf>
}
 211:	83 c4 10             	add    $0x10,%esp
 214:	8d 65 f8             	lea    -0x8(%ebp),%esp
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    
 21b:	90                   	nop
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        sigprocmask(1);
 220:	83 ec 0c             	sub    $0xc,%esp
 223:	89 c3                	mov    %eax,%ebx
 225:	6a 01                	push   $0x1
 227:	e8 f6 05 00 00       	call   822 <sigprocmask>
        pid2 = fork();
 22c:	e8 49 05 00 00       	call   77a <fork>
    if(pid != 0 && pid2 != 0){
 231:	83 c4 10             	add    $0x10,%esp
 234:	85 c0                	test   %eax,%eax
        pid2 = fork();
 236:	89 c6                	mov    %eax,%esi
    if(pid != 0 && pid2 != 0){
 238:	74 b1                	je     1eb <send_signal_test+0x5b>
        kill(pid,1);
 23a:	83 ec 08             	sub    $0x8,%esp
 23d:	6a 01                	push   $0x1
 23f:	53                   	push   %ebx
 240:	e8 6d 05 00 00       	call   7b2 <kill>
        sleep(10);
 245:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 24c:	e8 c1 05 00 00       	call   812 <sleep>
        kill(pid2,1);
 251:	58                   	pop    %eax
 252:	5a                   	pop    %edx
 253:	6a 01                	push   $0x1
 255:	56                   	push   %esi
 256:	e8 57 05 00 00       	call   7b2 <kill>
        kill(pid2,2);
 25b:	59                   	pop    %ecx
 25c:	5b                   	pop    %ebx
 25d:	6a 02                	push   $0x2
 25f:	56                   	push   %esi
 260:	e8 4d 05 00 00       	call   7b2 <kill>
 265:	83 c4 10             	add    $0x10,%esp
 268:	eb 8e                	jmp    1f8 <send_signal_test+0x68>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000270 <sigret_test>:
sigret_test(){    
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 10             	sub    $0x10,%esp
  printf(1, "\n[start] sigret test | should print :  C  \n\n[");
 276:	68 e8 0c 00 00       	push   $0xce8
 27b:	6a 01                	push   $0x1
 27d:	e8 5e 06 00 00       	call   8e0 <printf>
  struct sigaction *act= malloc(sizeof(struct sigaction*));
 282:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 289:	e8 b2 08 00 00       	call   b40 <malloc>
  sigaction(1,act,null);
 28e:	83 c4 0c             	add    $0xc,%esp
  act->sa_handler=signalHandlerNoExit;
 291:	c7 00 40 00 00 00    	movl   $0x40,(%eax)
  act->sigmask=0;
 297:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  sigaction(1,act,null);
 29e:	6a 00                	push   $0x0
 2a0:	50                   	push   %eax
 2a1:	6a 01                	push   $0x1
 2a3:	e8 82 05 00 00       	call   82a <sigaction>
  int pid = fork();
 2a8:	e8 cd 04 00 00       	call   77a <fork>
  if(pid != 0){
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	85 c0                	test   %eax,%eax
 2b2:	74 14                	je     2c8 <sigret_test+0x58>
    kill(pid,1);
 2b4:	83 ec 08             	sub    $0x8,%esp
 2b7:	6a 01                	push   $0x1
 2b9:	50                   	push   %eax
 2ba:	e8 f3 04 00 00       	call   7b2 <kill>
  wait();
 2bf:	83 c4 10             	add    $0x10,%esp
}
 2c2:	c9                   	leave  
  wait();
 2c3:	e9 c2 04 00 00       	jmp    78a <wait>
      sleep(4);
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	6a 04                	push   $0x4
 2cd:	e8 40 05 00 00       	call   812 <sleep>
      printf(1, " ] [finished]\n");
 2d2:	58                   	pop    %eax
 2d3:	5a                   	pop    %edx
 2d4:	68 51 0c 00 00       	push   $0xc51
 2d9:	6a 01                	push   $0x1
 2db:	e8 00 06 00 00       	call   8e0 <printf>
      exit();
 2e0:	e8 9d 04 00 00       	call   782 <exit>
 2e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002f0 <stop_cont_test>:
stop_cont_test(){
 2f0:	55                   	push   %ebp
 2f1:	89 e5                	mov    %esp,%ebp
 2f3:	53                   	push   %ebx
 2f4:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "\n[start] stop cont test | should print :  A B C D \n\n[");
 2f7:	68 18 0d 00 00       	push   $0xd18
 2fc:	6a 01                	push   $0x1
 2fe:	e8 dd 05 00 00       	call   8e0 <printf>
    int fork_id = fork();
 303:	e8 72 04 00 00       	call   77a <fork>
    if (fork_id == 0){
 308:	83 c4 10             	add    $0x10,%esp
 30b:	85 c0                	test   %eax,%eax
 30d:	74 68                	je     377 <stop_cont_test+0x87>
        printf(1, " A");
 30f:	83 ec 08             	sub    $0x8,%esp
 312:	89 c3                	mov    %eax,%ebx
 314:	68 3b 0c 00 00       	push   $0xc3b
 319:	6a 01                	push   $0x1
 31b:	e8 c0 05 00 00       	call   8e0 <printf>
        kill(fork_id, SIGSTOP); 
 320:	58                   	pop    %eax
 321:	5a                   	pop    %edx
 322:	6a 11                	push   $0x11
 324:	53                   	push   %ebx
 325:	e8 88 04 00 00       	call   7b2 <kill>
        printf(1, " B");
 32a:	59                   	pop    %ecx
 32b:	58                   	pop    %eax
 32c:	68 3e 0c 00 00       	push   $0xc3e
 331:	6a 01                	push   $0x1
 333:	e8 a8 05 00 00       	call   8e0 <printf>
        sleep(70);
 338:	c7 04 24 46 00 00 00 	movl   $0x46,(%esp)
 33f:	e8 ce 04 00 00       	call   812 <sleep>
        printf(1, " C");
 344:	58                   	pop    %eax
 345:	5a                   	pop    %edx
 346:	68 38 0c 00 00       	push   $0xc38
 34b:	6a 01                	push   $0x1
 34d:	e8 8e 05 00 00       	call   8e0 <printf>
        kill(fork_id, SIGCONT); 
 352:	59                   	pop    %ecx
 353:	58                   	pop    %eax
 354:	6a 13                	push   $0x13
 356:	53                   	push   %ebx
 357:	e8 56 04 00 00       	call   7b2 <kill>
        wait();
 35c:	e8 29 04 00 00       	call   78a <wait>
        printf(1, " ] [finished]\n");
 361:	58                   	pop    %eax
 362:	5a                   	pop    %edx
 363:	68 51 0c 00 00       	push   $0xc51
 368:	6a 01                	push   $0x1
 36a:	e8 71 05 00 00       	call   8e0 <printf>
}
 36f:	83 c4 10             	add    $0x10,%esp
 372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 375:	c9                   	leave  
 376:	c3                   	ret    
        sleep(20); //get stop signal
 377:	83 ec 0c             	sub    $0xc,%esp
 37a:	6a 14                	push   $0x14
 37c:	e8 91 04 00 00       	call   812 <sleep>
        printf(1, " D");
 381:	59                   	pop    %ecx
 382:	5b                   	pop    %ebx
 383:	68 60 0c 00 00       	push   $0xc60
 388:	6a 01                	push   $0x1
 38a:	e8 51 05 00 00       	call   8e0 <printf>
        exit();
 38f:	e8 ee 03 00 00       	call   782 <exit>
 394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 39a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003a0 <old_act_test>:
old_act_test(){
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	56                   	push   %esi
 3a4:	53                   	push   %ebx
    printf(1, "\n\n[start] old act test | should print : C B\n\n[");
 3a5:	83 ec 08             	sub    $0x8,%esp
 3a8:	68 50 0d 00 00       	push   $0xd50
 3ad:	6a 01                	push   $0x1
 3af:	e8 2c 05 00 00       	call   8e0 <printf>
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 3b4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 3bb:	e8 80 07 00 00       	call   b40 <malloc>
    sigaction(2,act,null);
 3c0:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=signalHandler2;
 3c3:	c7 00 80 00 00 00    	movl   $0x80,(%eax)
    act->sigmask=0;
 3c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    sigaction(2,act,null);
 3d0:	6a 00                	push   $0x0
 3d2:	50                   	push   %eax
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 3d3:	89 c3                	mov    %eax,%ebx
    sigaction(2,act,null);
 3d5:	6a 02                	push   $0x2
 3d7:	e8 4e 04 00 00       	call   82a <sigaction>
    struct sigaction *old_act= malloc(sizeof(struct sigaction*));
 3dc:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 3e3:	e8 58 07 00 00       	call   b40 <malloc>
    sigaction(2,act,old_act);
 3e8:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=signalHandlerNoExit;
 3eb:	c7 03 40 00 00 00    	movl   $0x40,(%ebx)
    struct sigaction *old_act= malloc(sizeof(struct sigaction*));
 3f1:	89 c6                	mov    %eax,%esi
    sigaction(2,act,old_act);
 3f3:	50                   	push   %eax
 3f4:	53                   	push   %ebx
 3f5:	6a 02                	push   $0x2
 3f7:	e8 2e 04 00 00       	call   82a <sigaction>
    sigaction(1,old_act, null);
 3fc:	83 c4 0c             	add    $0xc,%esp
 3ff:	6a 00                	push   $0x0
 401:	56                   	push   %esi
 402:	6a 01                	push   $0x1
 404:	e8 21 04 00 00       	call   82a <sigaction>
    int currpid = getpid();
 409:	e8 f4 03 00 00       	call   802 <getpid>
 40e:	89 c6                	mov    %eax,%esi
    int pid = fork();
 410:	e8 65 03 00 00       	call   77a <fork>
    if(pid == 0){
 415:	83 c4 10             	add    $0x10,%esp
 418:	85 c0                	test   %eax,%eax
 41a:	74 44                	je     460 <old_act_test+0xc0>
        kill(currpid,2);
 41c:	83 ec 08             	sub    $0x8,%esp
 41f:	89 c3                	mov    %eax,%ebx
 421:	6a 02                	push   $0x2
 423:	56                   	push   %esi
 424:	e8 89 03 00 00       	call   7b2 <kill>
        sleep(10);
 429:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 430:	e8 dd 03 00 00       	call   812 <sleep>
        kill(pid,1);
 435:	58                   	pop    %eax
 436:	5a                   	pop    %edx
 437:	6a 01                	push   $0x1
 439:	53                   	push   %ebx
 43a:	e8 73 03 00 00       	call   7b2 <kill>
 43f:	83 c4 10             	add    $0x10,%esp
    wait();
 442:	e8 43 03 00 00       	call   78a <wait>
    printf(1, " ] [finished]\n\n");
 447:	83 ec 08             	sub    $0x8,%esp
 44a:	68 41 0c 00 00       	push   $0xc41
 44f:	6a 01                	push   $0x1
 451:	e8 8a 04 00 00       	call   8e0 <printf>
}
 456:	83 c4 10             	add    $0x10,%esp
 459:	8d 65 f8             	lea    -0x8(%ebp),%esp
 45c:	5b                   	pop    %ebx
 45d:	5e                   	pop    %esi
 45e:	5d                   	pop    %ebp
 45f:	c3                   	ret    
        sleep(100);
 460:	83 ec 0c             	sub    $0xc,%esp
 463:	6a 64                	push   $0x64
 465:	e8 a8 03 00 00       	call   812 <sleep>
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	eb d3                	jmp    442 <old_act_test+0xa2>
 46f:	90                   	nop

00000470 <modify_test>:
modify_test(){
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	83 ec 0c             	sub    $0xc,%esp
    printf(1, "\n\n[start]");
 477:	68 63 0c 00 00       	push   $0xc63
 47c:	6a 01                	push   $0x1
 47e:	e8 5d 04 00 00       	call   8e0 <printf>
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 483:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 48a:	e8 b1 06 00 00       	call   b40 <malloc>
    if(sigaction(SIGKILL,act,null) != -1){
 48f:	83 c4 0c             	add    $0xc,%esp
    act->sa_handler=(void*)SIGSTOP;
 492:	c7 00 11 00 00 00    	movl   $0x11,(%eax)
    act->sigmask=0;
 498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    if(sigaction(SIGKILL,act,null) != -1){
 49f:	6a 00                	push   $0x0
 4a1:	50                   	push   %eax
    struct sigaction *act= malloc(sizeof(struct sigaction*));
 4a2:	89 c3                	mov    %eax,%ebx
    if(sigaction(SIGKILL,act,null) != -1){
 4a4:	6a 09                	push   $0x9
 4a6:	e8 7f 03 00 00       	call   82a <sigaction>
 4ab:	83 c4 10             	add    $0x10,%esp
 4ae:	83 f8 ff             	cmp    $0xffffffff,%eax
 4b1:	74 1d                	je     4d0 <modify_test+0x60>
      printf(1,"failed\n");
 4b3:	83 ec 08             	sub    $0x8,%esp
 4b6:	68 6d 0c 00 00       	push   $0xc6d
 4bb:	6a 01                	push   $0x1
 4bd:	e8 1e 04 00 00       	call   8e0 <printf>
 4c2:	83 c4 10             	add    $0x10,%esp
}
 4c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if(sigaction(SIGSTOP,act,null) != -1){
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	6a 00                	push   $0x0
 4d5:	53                   	push   %ebx
 4d6:	6a 11                	push   $0x11
 4d8:	e8 4d 03 00 00       	call   82a <sigaction>
 4dd:	83 c4 10             	add    $0x10,%esp
 4e0:	83 f8 ff             	cmp    $0xffffffff,%eax
 4e3:	75 ce                	jne    4b3 <modify_test+0x43>
    else if(sigaction(5,act,null) != 0){
 4e5:	83 ec 04             	sub    $0x4,%esp
 4e8:	6a 00                	push   $0x0
 4ea:	53                   	push   %ebx
 4eb:	6a 05                	push   $0x5
 4ed:	e8 38 03 00 00       	call   82a <sigaction>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	85 c0                	test   %eax,%eax
 4f7:	75 ba                	jne    4b3 <modify_test+0x43>
    else if(sigaction(5,act,null) != 0){
 4f9:	83 ec 04             	sub    $0x4,%esp
 4fc:	6a 00                	push   $0x0
 4fe:	53                   	push   %ebx
 4ff:	6a 05                	push   $0x5
 501:	e8 24 03 00 00       	call   82a <sigaction>
 506:	83 c4 10             	add    $0x10,%esp
 509:	85 c0                	test   %eax,%eax
 50b:	75 a6                	jne    4b3 <modify_test+0x43>
      printf(1, " [finished]\n\n");
 50d:	83 ec 08             	sub    $0x8,%esp
 510:	68 43 0c 00 00       	push   $0xc43
 515:	6a 01                	push   $0x1
 517:	e8 c4 03 00 00       	call   8e0 <printf>
 51c:	83 c4 10             	add    $0x10,%esp
}
 51f:	eb a4                	jmp    4c5 <modify_test+0x55>
 521:	66 90                	xchg   %ax,%ax
 523:	66 90                	xchg   %ax,%ax
 525:	66 90                	xchg   %ax,%ax
 527:	66 90                	xchg   %ax,%ax
 529:	66 90                	xchg   %ax,%ax
 52b:	66 90                	xchg   %ax,%ax
 52d:	66 90                	xchg   %ax,%ax
 52f:	90                   	nop

00000530 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 53a:	89 c2                	mov    %eax,%edx
 53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 540:	83 c1 01             	add    $0x1,%ecx
 543:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 547:	83 c2 01             	add    $0x1,%edx
 54a:	84 db                	test   %bl,%bl
 54c:	88 5a ff             	mov    %bl,-0x1(%edx)
 54f:	75 ef                	jne    540 <strcpy+0x10>
    ;
  return os;
}
 551:	5b                   	pop    %ebx
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    
 554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 55a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000560 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	53                   	push   %ebx
 564:	8b 55 08             	mov    0x8(%ebp),%edx
 567:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 56a:	0f b6 02             	movzbl (%edx),%eax
 56d:	0f b6 19             	movzbl (%ecx),%ebx
 570:	84 c0                	test   %al,%al
 572:	75 1c                	jne    590 <strcmp+0x30>
 574:	eb 2a                	jmp    5a0 <strcmp+0x40>
 576:	8d 76 00             	lea    0x0(%esi),%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 580:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 583:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 586:	83 c1 01             	add    $0x1,%ecx
 589:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 58c:	84 c0                	test   %al,%al
 58e:	74 10                	je     5a0 <strcmp+0x40>
 590:	38 d8                	cmp    %bl,%al
 592:	74 ec                	je     580 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 594:	29 d8                	sub    %ebx,%eax
}
 596:	5b                   	pop    %ebx
 597:	5d                   	pop    %ebp
 598:	c3                   	ret    
 599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 5a2:	29 d8                	sub    %ebx,%eax
}
 5a4:	5b                   	pop    %ebx
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    
 5a7:	89 f6                	mov    %esi,%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005b0 <strlen>:

uint
strlen(const char *s)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 5b6:	80 39 00             	cmpb   $0x0,(%ecx)
 5b9:	74 15                	je     5d0 <strlen+0x20>
 5bb:	31 d2                	xor    %edx,%edx
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
 5c0:	83 c2 01             	add    $0x1,%edx
 5c3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5c7:	89 d0                	mov    %edx,%eax
 5c9:	75 f5                	jne    5c0 <strlen+0x10>
    ;
  return n;
}
 5cb:	5d                   	pop    %ebp
 5cc:	c3                   	ret    
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 5d0:	31 c0                	xor    %eax,%eax
}
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000005e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	57                   	push   %edi
 5e4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ed:	89 d7                	mov    %edx,%edi
 5ef:	fc                   	cld    
 5f0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5f2:	89 d0                	mov    %edx,%eax
 5f4:	5f                   	pop    %edi
 5f5:	5d                   	pop    %ebp
 5f6:	c3                   	ret    
 5f7:	89 f6                	mov    %esi,%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000600 <strchr>:

char*
strchr(const char *s, char c)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 60a:	0f b6 10             	movzbl (%eax),%edx
 60d:	84 d2                	test   %dl,%dl
 60f:	74 1d                	je     62e <strchr+0x2e>
    if(*s == c)
 611:	38 d3                	cmp    %dl,%bl
 613:	89 d9                	mov    %ebx,%ecx
 615:	75 0d                	jne    624 <strchr+0x24>
 617:	eb 17                	jmp    630 <strchr+0x30>
 619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 620:	38 ca                	cmp    %cl,%dl
 622:	74 0c                	je     630 <strchr+0x30>
  for(; *s; s++)
 624:	83 c0 01             	add    $0x1,%eax
 627:	0f b6 10             	movzbl (%eax),%edx
 62a:	84 d2                	test   %dl,%dl
 62c:	75 f2                	jne    620 <strchr+0x20>
      return (char*)s;
  return 0;
 62e:	31 c0                	xor    %eax,%eax
}
 630:	5b                   	pop    %ebx
 631:	5d                   	pop    %ebp
 632:	c3                   	ret    
 633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000640 <gets>:

char*
gets(char *buf, int max)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 646:	31 f6                	xor    %esi,%esi
 648:	89 f3                	mov    %esi,%ebx
{
 64a:	83 ec 1c             	sub    $0x1c,%esp
 64d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 650:	eb 2f                	jmp    681 <gets+0x41>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 658:	8d 45 e7             	lea    -0x19(%ebp),%eax
 65b:	83 ec 04             	sub    $0x4,%esp
 65e:	6a 01                	push   $0x1
 660:	50                   	push   %eax
 661:	6a 00                	push   $0x0
 663:	e8 32 01 00 00       	call   79a <read>
    if(cc < 1)
 668:	83 c4 10             	add    $0x10,%esp
 66b:	85 c0                	test   %eax,%eax
 66d:	7e 1c                	jle    68b <gets+0x4b>
      break;
    buf[i++] = c;
 66f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 673:	83 c7 01             	add    $0x1,%edi
 676:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 679:	3c 0a                	cmp    $0xa,%al
 67b:	74 23                	je     6a0 <gets+0x60>
 67d:	3c 0d                	cmp    $0xd,%al
 67f:	74 1f                	je     6a0 <gets+0x60>
  for(i=0; i+1 < max; ){
 681:	83 c3 01             	add    $0x1,%ebx
 684:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 687:	89 fe                	mov    %edi,%esi
 689:	7c cd                	jl     658 <gets+0x18>
 68b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 690:	c6 03 00             	movb   $0x0,(%ebx)
}
 693:	8d 65 f4             	lea    -0xc(%ebp),%esp
 696:	5b                   	pop    %ebx
 697:	5e                   	pop    %esi
 698:	5f                   	pop    %edi
 699:	5d                   	pop    %ebp
 69a:	c3                   	ret    
 69b:	90                   	nop
 69c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6a0:	8b 75 08             	mov    0x8(%ebp),%esi
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	01 de                	add    %ebx,%esi
 6a8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6aa:	c6 03 00             	movb   $0x0,(%ebx)
}
 6ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b0:	5b                   	pop    %ebx
 6b1:	5e                   	pop    %esi
 6b2:	5f                   	pop    %edi
 6b3:	5d                   	pop    %ebp
 6b4:	c3                   	ret    
 6b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	56                   	push   %esi
 6c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	6a 00                	push   $0x0
 6ca:	ff 75 08             	pushl  0x8(%ebp)
 6cd:	e8 f0 00 00 00       	call   7c2 <open>
  if(fd < 0)
 6d2:	83 c4 10             	add    $0x10,%esp
 6d5:	85 c0                	test   %eax,%eax
 6d7:	78 27                	js     700 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	ff 75 0c             	pushl  0xc(%ebp)
 6df:	89 c3                	mov    %eax,%ebx
 6e1:	50                   	push   %eax
 6e2:	e8 f3 00 00 00       	call   7da <fstat>
  close(fd);
 6e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6ea:	89 c6                	mov    %eax,%esi
  close(fd);
 6ec:	e8 b9 00 00 00       	call   7aa <close>
  return r;
 6f1:	83 c4 10             	add    $0x10,%esp
}
 6f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6f7:	89 f0                	mov    %esi,%eax
 6f9:	5b                   	pop    %ebx
 6fa:	5e                   	pop    %esi
 6fb:	5d                   	pop    %ebp
 6fc:	c3                   	ret    
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 700:	be ff ff ff ff       	mov    $0xffffffff,%esi
 705:	eb ed                	jmp    6f4 <stat+0x34>
 707:	89 f6                	mov    %esi,%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000710 <atoi>:

int
atoi(const char *s)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	53                   	push   %ebx
 714:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 717:	0f be 11             	movsbl (%ecx),%edx
 71a:	8d 42 d0             	lea    -0x30(%edx),%eax
 71d:	3c 09                	cmp    $0x9,%al
  n = 0;
 71f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 724:	77 1f                	ja     745 <atoi+0x35>
 726:	8d 76 00             	lea    0x0(%esi),%esi
 729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 730:	8d 04 80             	lea    (%eax,%eax,4),%eax
 733:	83 c1 01             	add    $0x1,%ecx
 736:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 73a:	0f be 11             	movsbl (%ecx),%edx
 73d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 740:	80 fb 09             	cmp    $0x9,%bl
 743:	76 eb                	jbe    730 <atoi+0x20>
  return n;
}
 745:	5b                   	pop    %ebx
 746:	5d                   	pop    %ebp
 747:	c3                   	ret    
 748:	90                   	nop
 749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000750 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 750:	55                   	push   %ebp
 751:	89 e5                	mov    %esp,%ebp
 753:	56                   	push   %esi
 754:	53                   	push   %ebx
 755:	8b 5d 10             	mov    0x10(%ebp),%ebx
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 75e:	85 db                	test   %ebx,%ebx
 760:	7e 14                	jle    776 <memmove+0x26>
 762:	31 d2                	xor    %edx,%edx
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 768:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 76c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 76f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 772:	39 d3                	cmp    %edx,%ebx
 774:	75 f2                	jne    768 <memmove+0x18>
  return vdst;
}
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5d                   	pop    %ebp
 779:	c3                   	ret    

0000077a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 77a:	b8 01 00 00 00       	mov    $0x1,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <exit>:
SYSCALL(exit)
 782:	b8 02 00 00 00       	mov    $0x2,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <wait>:
SYSCALL(wait)
 78a:	b8 03 00 00 00       	mov    $0x3,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <pipe>:
SYSCALL(pipe)
 792:	b8 04 00 00 00       	mov    $0x4,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <read>:
SYSCALL(read)
 79a:	b8 05 00 00 00       	mov    $0x5,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <write>:
SYSCALL(write)
 7a2:	b8 10 00 00 00       	mov    $0x10,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <close>:
SYSCALL(close)
 7aa:	b8 15 00 00 00       	mov    $0x15,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <kill>:
SYSCALL(kill)
 7b2:	b8 06 00 00 00       	mov    $0x6,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <exec>:
SYSCALL(exec)
 7ba:	b8 07 00 00 00       	mov    $0x7,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <open>:
SYSCALL(open)
 7c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <mknod>:
SYSCALL(mknod)
 7ca:	b8 11 00 00 00       	mov    $0x11,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <unlink>:
SYSCALL(unlink)
 7d2:	b8 12 00 00 00       	mov    $0x12,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <fstat>:
SYSCALL(fstat)
 7da:	b8 08 00 00 00       	mov    $0x8,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <link>:
SYSCALL(link)
 7e2:	b8 13 00 00 00       	mov    $0x13,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <mkdir>:
SYSCALL(mkdir)
 7ea:	b8 14 00 00 00       	mov    $0x14,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <chdir>:
SYSCALL(chdir)
 7f2:	b8 09 00 00 00       	mov    $0x9,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <dup>:
SYSCALL(dup)
 7fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <getpid>:
SYSCALL(getpid)
 802:	b8 0b 00 00 00       	mov    $0xb,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <sbrk>:
SYSCALL(sbrk)
 80a:	b8 0c 00 00 00       	mov    $0xc,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <sleep>:
SYSCALL(sleep)
 812:	b8 0d 00 00 00       	mov    $0xd,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <uptime>:
SYSCALL(uptime)
 81a:	b8 0e 00 00 00       	mov    $0xe,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <sigprocmask>:
SYSCALL(sigprocmask)
 822:	b8 16 00 00 00       	mov    $0x16,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <sigaction>:
SYSCALL(sigaction)
 82a:	b8 17 00 00 00       	mov    $0x17,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <sigret>:
SYSCALL(sigret)
 832:	b8 18 00 00 00       	mov    $0x18,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    
 83a:	66 90                	xchg   %ax,%ax
 83c:	66 90                	xchg   %ax,%ax
 83e:	66 90                	xchg   %ax,%ax

00000840 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 849:	85 d2                	test   %edx,%edx
{
 84b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 84e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 850:	79 76                	jns    8c8 <printint+0x88>
 852:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 856:	74 70                	je     8c8 <printint+0x88>
    x = -xx;
 858:	f7 d8                	neg    %eax
    neg = 1;
 85a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 861:	31 f6                	xor    %esi,%esi
 863:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 866:	eb 0a                	jmp    872 <printint+0x32>
 868:	90                   	nop
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 870:	89 fe                	mov    %edi,%esi
 872:	31 d2                	xor    %edx,%edx
 874:	8d 7e 01             	lea    0x1(%esi),%edi
 877:	f7 f1                	div    %ecx
 879:	0f b6 92 88 0d 00 00 	movzbl 0xd88(%edx),%edx
  }while((x /= base) != 0);
 880:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 882:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 885:	75 e9                	jne    870 <printint+0x30>
  if(neg)
 887:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 88a:	85 c0                	test   %eax,%eax
 88c:	74 08                	je     896 <printint+0x56>
    buf[i++] = '-';
 88e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 893:	8d 7e 02             	lea    0x2(%esi),%edi
 896:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 89a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 89d:	8d 76 00             	lea    0x0(%esi),%esi
 8a0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 8a3:	83 ec 04             	sub    $0x4,%esp
 8a6:	83 ee 01             	sub    $0x1,%esi
 8a9:	6a 01                	push   $0x1
 8ab:	53                   	push   %ebx
 8ac:	57                   	push   %edi
 8ad:	88 45 d7             	mov    %al,-0x29(%ebp)
 8b0:	e8 ed fe ff ff       	call   7a2 <write>

  while(--i >= 0)
 8b5:	83 c4 10             	add    $0x10,%esp
 8b8:	39 de                	cmp    %ebx,%esi
 8ba:	75 e4                	jne    8a0 <printint+0x60>
    putc(fd, buf[i]);
}
 8bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8bf:	5b                   	pop    %ebx
 8c0:	5e                   	pop    %esi
 8c1:	5f                   	pop    %edi
 8c2:	5d                   	pop    %ebp
 8c3:	c3                   	ret    
 8c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8c8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 8cf:	eb 90                	jmp    861 <printint+0x21>
 8d1:	eb 0d                	jmp    8e0 <printf>
 8d3:	90                   	nop
 8d4:	90                   	nop
 8d5:	90                   	nop
 8d6:	90                   	nop
 8d7:	90                   	nop
 8d8:	90                   	nop
 8d9:	90                   	nop
 8da:	90                   	nop
 8db:	90                   	nop
 8dc:	90                   	nop
 8dd:	90                   	nop
 8de:	90                   	nop
 8df:	90                   	nop

000008e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	57                   	push   %edi
 8e4:	56                   	push   %esi
 8e5:	53                   	push   %ebx
 8e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8e9:	8b 75 0c             	mov    0xc(%ebp),%esi
 8ec:	0f b6 1e             	movzbl (%esi),%ebx
 8ef:	84 db                	test   %bl,%bl
 8f1:	0f 84 b3 00 00 00    	je     9aa <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 8f7:	8d 45 10             	lea    0x10(%ebp),%eax
 8fa:	83 c6 01             	add    $0x1,%esi
  state = 0;
 8fd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 8ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 902:	eb 2f                	jmp    933 <printf+0x53>
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 908:	83 f8 25             	cmp    $0x25,%eax
 90b:	0f 84 a7 00 00 00    	je     9b8 <printf+0xd8>
  write(fd, &c, 1);
 911:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 914:	83 ec 04             	sub    $0x4,%esp
 917:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 91a:	6a 01                	push   $0x1
 91c:	50                   	push   %eax
 91d:	ff 75 08             	pushl  0x8(%ebp)
 920:	e8 7d fe ff ff       	call   7a2 <write>
 925:	83 c4 10             	add    $0x10,%esp
 928:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 92b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 92f:	84 db                	test   %bl,%bl
 931:	74 77                	je     9aa <printf+0xca>
    if(state == 0){
 933:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 935:	0f be cb             	movsbl %bl,%ecx
 938:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 93b:	74 cb                	je     908 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 93d:	83 ff 25             	cmp    $0x25,%edi
 940:	75 e6                	jne    928 <printf+0x48>
      if(c == 'd'){
 942:	83 f8 64             	cmp    $0x64,%eax
 945:	0f 84 05 01 00 00    	je     a50 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 94b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 951:	83 f9 70             	cmp    $0x70,%ecx
 954:	74 72                	je     9c8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 956:	83 f8 73             	cmp    $0x73,%eax
 959:	0f 84 99 00 00 00    	je     9f8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 95f:	83 f8 63             	cmp    $0x63,%eax
 962:	0f 84 08 01 00 00    	je     a70 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 968:	83 f8 25             	cmp    $0x25,%eax
 96b:	0f 84 ef 00 00 00    	je     a60 <printf+0x180>
  write(fd, &c, 1);
 971:	8d 45 e7             	lea    -0x19(%ebp),%eax
 974:	83 ec 04             	sub    $0x4,%esp
 977:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 97b:	6a 01                	push   $0x1
 97d:	50                   	push   %eax
 97e:	ff 75 08             	pushl  0x8(%ebp)
 981:	e8 1c fe ff ff       	call   7a2 <write>
 986:	83 c4 0c             	add    $0xc,%esp
 989:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 98c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 98f:	6a 01                	push   $0x1
 991:	50                   	push   %eax
 992:	ff 75 08             	pushl  0x8(%ebp)
 995:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 998:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 99a:	e8 03 fe ff ff       	call   7a2 <write>
  for(i = 0; fmt[i]; i++){
 99f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 9a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 9a6:	84 db                	test   %bl,%bl
 9a8:	75 89                	jne    933 <printf+0x53>
    }
  }
}
 9aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9ad:	5b                   	pop    %ebx
 9ae:	5e                   	pop    %esi
 9af:	5f                   	pop    %edi
 9b0:	5d                   	pop    %ebp
 9b1:	c3                   	ret    
 9b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 9b8:	bf 25 00 00 00       	mov    $0x25,%edi
 9bd:	e9 66 ff ff ff       	jmp    928 <printf+0x48>
 9c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 9c8:	83 ec 0c             	sub    $0xc,%esp
 9cb:	b9 10 00 00 00       	mov    $0x10,%ecx
 9d0:	6a 00                	push   $0x0
 9d2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	8b 17                	mov    (%edi),%edx
 9da:	e8 61 fe ff ff       	call   840 <printint>
        ap++;
 9df:	89 f8                	mov    %edi,%eax
 9e1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9e4:	31 ff                	xor    %edi,%edi
        ap++;
 9e6:	83 c0 04             	add    $0x4,%eax
 9e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 9ec:	e9 37 ff ff ff       	jmp    928 <printf+0x48>
 9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 9fb:	8b 08                	mov    (%eax),%ecx
        ap++;
 9fd:	83 c0 04             	add    $0x4,%eax
 a00:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 a03:	85 c9                	test   %ecx,%ecx
 a05:	0f 84 8e 00 00 00    	je     a99 <printf+0x1b9>
        while(*s != 0){
 a0b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 a0e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 a10:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 a12:	84 c0                	test   %al,%al
 a14:	0f 84 0e ff ff ff    	je     928 <printf+0x48>
 a1a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 a1d:	89 de                	mov    %ebx,%esi
 a1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a22:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 a25:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 a28:	83 ec 04             	sub    $0x4,%esp
          s++;
 a2b:	83 c6 01             	add    $0x1,%esi
 a2e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 a31:	6a 01                	push   $0x1
 a33:	57                   	push   %edi
 a34:	53                   	push   %ebx
 a35:	e8 68 fd ff ff       	call   7a2 <write>
        while(*s != 0){
 a3a:	0f b6 06             	movzbl (%esi),%eax
 a3d:	83 c4 10             	add    $0x10,%esp
 a40:	84 c0                	test   %al,%al
 a42:	75 e4                	jne    a28 <printf+0x148>
 a44:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 a47:	31 ff                	xor    %edi,%edi
 a49:	e9 da fe ff ff       	jmp    928 <printf+0x48>
 a4e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 a50:	83 ec 0c             	sub    $0xc,%esp
 a53:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a58:	6a 01                	push   $0x1
 a5a:	e9 73 ff ff ff       	jmp    9d2 <printf+0xf2>
 a5f:	90                   	nop
  write(fd, &c, 1);
 a60:	83 ec 04             	sub    $0x4,%esp
 a63:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a66:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a69:	6a 01                	push   $0x1
 a6b:	e9 21 ff ff ff       	jmp    991 <printf+0xb1>
        putc(fd, *ap);
 a70:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 a73:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a76:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 a78:	6a 01                	push   $0x1
        ap++;
 a7a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 a7d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 a80:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a83:	50                   	push   %eax
 a84:	ff 75 08             	pushl  0x8(%ebp)
 a87:	e8 16 fd ff ff       	call   7a2 <write>
        ap++;
 a8c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 a8f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a92:	31 ff                	xor    %edi,%edi
 a94:	e9 8f fe ff ff       	jmp    928 <printf+0x48>
          s = "(null)";
 a99:	bb 80 0d 00 00       	mov    $0xd80,%ebx
        while(*s != 0){
 a9e:	b8 28 00 00 00       	mov    $0x28,%eax
 aa3:	e9 72 ff ff ff       	jmp    a1a <printf+0x13a>
 aa8:	66 90                	xchg   %ax,%ax
 aaa:	66 90                	xchg   %ax,%ax
 aac:	66 90                	xchg   %ax,%ax
 aae:	66 90                	xchg   %ax,%ax

00000ab0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab1:	a1 98 11 00 00       	mov    0x1198,%eax
{
 ab6:	89 e5                	mov    %esp,%ebp
 ab8:	57                   	push   %edi
 ab9:	56                   	push   %esi
 aba:	53                   	push   %ebx
 abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 abe:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac8:	39 c8                	cmp    %ecx,%eax
 aca:	8b 10                	mov    (%eax),%edx
 acc:	73 32                	jae    b00 <free+0x50>
 ace:	39 d1                	cmp    %edx,%ecx
 ad0:	72 04                	jb     ad6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad2:	39 d0                	cmp    %edx,%eax
 ad4:	72 32                	jb     b08 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 ad9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 adc:	39 fa                	cmp    %edi,%edx
 ade:	74 30                	je     b10 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ae0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ae3:	8b 50 04             	mov    0x4(%eax),%edx
 ae6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ae9:	39 f1                	cmp    %esi,%ecx
 aeb:	74 3a                	je     b27 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 aed:	89 08                	mov    %ecx,(%eax)
  freep = p;
 aef:	a3 98 11 00 00       	mov    %eax,0x1198
}
 af4:	5b                   	pop    %ebx
 af5:	5e                   	pop    %esi
 af6:	5f                   	pop    %edi
 af7:	5d                   	pop    %ebp
 af8:	c3                   	ret    
 af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b00:	39 d0                	cmp    %edx,%eax
 b02:	72 04                	jb     b08 <free+0x58>
 b04:	39 d1                	cmp    %edx,%ecx
 b06:	72 ce                	jb     ad6 <free+0x26>
{
 b08:	89 d0                	mov    %edx,%eax
 b0a:	eb bc                	jmp    ac8 <free+0x18>
 b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 b10:	03 72 04             	add    0x4(%edx),%esi
 b13:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b16:	8b 10                	mov    (%eax),%edx
 b18:	8b 12                	mov    (%edx),%edx
 b1a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b1d:	8b 50 04             	mov    0x4(%eax),%edx
 b20:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b23:	39 f1                	cmp    %esi,%ecx
 b25:	75 c6                	jne    aed <free+0x3d>
    p->s.size += bp->s.size;
 b27:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b2a:	a3 98 11 00 00       	mov    %eax,0x1198
    p->s.size += bp->s.size;
 b2f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b32:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b35:	89 10                	mov    %edx,(%eax)
}
 b37:	5b                   	pop    %ebx
 b38:	5e                   	pop    %esi
 b39:	5f                   	pop    %edi
 b3a:	5d                   	pop    %ebp
 b3b:	c3                   	ret    
 b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	57                   	push   %edi
 b44:	56                   	push   %esi
 b45:	53                   	push   %ebx
 b46:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b49:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b4c:	8b 15 98 11 00 00    	mov    0x1198,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b52:	8d 78 07             	lea    0x7(%eax),%edi
 b55:	c1 ef 03             	shr    $0x3,%edi
 b58:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b5b:	85 d2                	test   %edx,%edx
 b5d:	0f 84 9d 00 00 00    	je     c00 <malloc+0xc0>
 b63:	8b 02                	mov    (%edx),%eax
 b65:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b68:	39 cf                	cmp    %ecx,%edi
 b6a:	76 6c                	jbe    bd8 <malloc+0x98>
 b6c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b72:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b77:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 b7a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 b81:	eb 0e                	jmp    b91 <malloc+0x51>
 b83:	90                   	nop
 b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b88:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b8a:	8b 48 04             	mov    0x4(%eax),%ecx
 b8d:	39 f9                	cmp    %edi,%ecx
 b8f:	73 47                	jae    bd8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b91:	39 05 98 11 00 00    	cmp    %eax,0x1198
 b97:	89 c2                	mov    %eax,%edx
 b99:	75 ed                	jne    b88 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b9b:	83 ec 0c             	sub    $0xc,%esp
 b9e:	56                   	push   %esi
 b9f:	e8 66 fc ff ff       	call   80a <sbrk>
  if(p == (char*)-1)
 ba4:	83 c4 10             	add    $0x10,%esp
 ba7:	83 f8 ff             	cmp    $0xffffffff,%eax
 baa:	74 1c                	je     bc8 <malloc+0x88>
  hp->s.size = nu;
 bac:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 baf:	83 ec 0c             	sub    $0xc,%esp
 bb2:	83 c0 08             	add    $0x8,%eax
 bb5:	50                   	push   %eax
 bb6:	e8 f5 fe ff ff       	call   ab0 <free>
  return freep;
 bbb:	8b 15 98 11 00 00    	mov    0x1198,%edx
      if((p = morecore(nunits)) == 0)
 bc1:	83 c4 10             	add    $0x10,%esp
 bc4:	85 d2                	test   %edx,%edx
 bc6:	75 c0                	jne    b88 <malloc+0x48>
        return 0;
  }
}
 bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 bcb:	31 c0                	xor    %eax,%eax
}
 bcd:	5b                   	pop    %ebx
 bce:	5e                   	pop    %esi
 bcf:	5f                   	pop    %edi
 bd0:	5d                   	pop    %ebp
 bd1:	c3                   	ret    
 bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 bd8:	39 cf                	cmp    %ecx,%edi
 bda:	74 54                	je     c30 <malloc+0xf0>
        p->s.size -= nunits;
 bdc:	29 f9                	sub    %edi,%ecx
 bde:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 be1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 be4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 be7:	89 15 98 11 00 00    	mov    %edx,0x1198
}
 bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 bf0:	83 c0 08             	add    $0x8,%eax
}
 bf3:	5b                   	pop    %ebx
 bf4:	5e                   	pop    %esi
 bf5:	5f                   	pop    %edi
 bf6:	5d                   	pop    %ebp
 bf7:	c3                   	ret    
 bf8:	90                   	nop
 bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 c00:	c7 05 98 11 00 00 9c 	movl   $0x119c,0x1198
 c07:	11 00 00 
 c0a:	c7 05 9c 11 00 00 9c 	movl   $0x119c,0x119c
 c11:	11 00 00 
    base.s.size = 0;
 c14:	b8 9c 11 00 00       	mov    $0x119c,%eax
 c19:	c7 05 a0 11 00 00 00 	movl   $0x0,0x11a0
 c20:	00 00 00 
 c23:	e9 44 ff ff ff       	jmp    b6c <malloc+0x2c>
 c28:	90                   	nop
 c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 c30:	8b 08                	mov    (%eax),%ecx
 c32:	89 0a                	mov    %ecx,(%edx)
 c34:	eb b1                	jmp    be7 <malloc+0xa7>
