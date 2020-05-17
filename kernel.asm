
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 2e 10 80       	mov    $0x80102ee0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 76 10 80       	push   $0x801076e0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 e5 48 00 00       	call   80104940 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 76 10 80       	push   $0x801076e7
80100097:	50                   	push   %eax
80100098:	e8 73 47 00 00       	call   80104810 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 97 49 00 00       	call   80104a80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 d9 49 00 00       	call   80104b40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 46 00 00       	call   80104850 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 1f 00 00       	call   80102150 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 76 10 80       	push   $0x801076ee
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 47 00 00       	call   801048f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 76 10 80       	push   $0x801076ff
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 46 00 00       	call   801048f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 46 00 00       	call   801048b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 70 48 00 00       	call   80104a80 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 df 48 00 00       	jmp    80104b40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 77 10 80       	push   $0x80107706
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 0b 15 00 00       	call   80101790 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 ef 47 00 00       	call   80104a80 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 c6 3e 00 00       	call   80104190 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 35 00 00       	call   80103800 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 4c 48 00 00       	call   80104b40 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 13 00 00       	call   801016b0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ee 47 00 00       	call   80104b40 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 13 00 00       	call   801016b0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 c2 23 00 00       	call   80102770 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 77 10 80       	push   $0x8010770d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 81 10 80 	movl   $0x80108103,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 45 00 00       	call   80104960 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 77 10 80       	push   $0x80107721
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 b1 5e 00 00       	call   801062f0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 ff 5d 00 00       	call   801062f0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 5d 00 00       	call   801062f0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 5d 00 00       	call   801062f0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 17 47 00 00       	call   80104c40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 4a 46 00 00       	call   80104b90 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 77 10 80       	push   $0x80107725
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 50 77 10 80 	movzbl -0x7fef88b0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 7c 11 00 00       	call   80101790 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 60 44 00 00       	call   80104a80 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 f4 44 00 00       	call   80104b40 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 10 00 00       	call   801016b0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 1c 44 00 00       	call   80104b40 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 38 77 10 80       	mov    $0x80107738,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 8b 42 00 00       	call   80104a80 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 77 10 80       	push   $0x8010773f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 58 42 00 00       	call   80104a80 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 b3 42 00 00       	call   80104b40 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 35 39 00 00       	call   80104250 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 39 00 00       	jmp    80104390 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 48 77 10 80       	push   $0x80107748
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 6b 3f 00 00       	call   80104940 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 19 00 00       	call   80102310 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 df 2d 00 00       	call   80103800 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 b4 21 00 00       	call   80102be0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 d9 14 00 00       	call   80101f10 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 63 0c 00 00       	call   801016b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 32 0f 00 00       	call   80101990 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 d1 0e 00 00       	call   80101940 <iunlockput>
    end_op();
80100a6f:	e8 dc 21 00 00       	call   80102c50 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 a7 69 00 00       	call   80107440 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 bb 02 00 00    	je     80100d7a <exec+0x36a>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 65 67 00 00       	call   80107260 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 73 66 00 00       	call   801071a0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 33 0e 00 00       	call   80101990 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 49 68 00 00       	call   801073c0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 a6 0d 00 00       	call   80101940 <iunlockput>
  end_op();
80100b9a:	e8 b1 20 00 00       	call   80102c50 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 b1 66 00 00       	call   80107260 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 fa 67 00 00       	call   801073c0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 78 20 00 00       	call   80102c50 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 61 77 10 80       	push   $0x80107761
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 d5 68 00 00       	call   801074e0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 72 41 00 00       	call   80104db0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 5f 41 00 00       	call   80104db0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 de 69 00 00       	call   80107640 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 74 69 00 00       	call   80107640 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	8d 47 70             	lea    0x70(%edi),%eax
80100d07:	50                   	push   %eax
80100d08:	e8 63 40 00 00       	call   80104d70 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d13:	89 fa                	mov    %edi,%edx
80100d15:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d18:	8b 42 18             	mov    0x18(%edx),%eax
  curproc->sz = sz;
80100d1b:	89 32                	mov    %esi,(%edx)
80100d1d:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80100d20:	89 4a 04             	mov    %ecx,0x4(%edx)
  curproc->tf->eip = elf.entry;  // main
80100d23:	89 d1                	mov    %edx,%ecx
80100d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2e:	8b 41 18             	mov    0x18(%ecx),%eax
80100d31:	89 ca                	mov    %ecx,%edx
80100d33:	81 c2 8c 01 00 00    	add    $0x18c,%edx
80100d39:	89 58 44             	mov    %ebx,0x44(%eax)
80100d3c:	89 c8                	mov    %ecx,%eax
80100d3e:	05 0c 01 00 00       	add    $0x10c,%eax
80100d43:	90                   	nop
80100d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->signalHandler[i]!=(void*)SIG_IGN&&curproc->signalHandler[i]!=(void*)SIG_DFL){
80100d48:	83 38 01             	cmpl   $0x1,(%eax)
80100d4b:	76 06                	jbe    80100d53 <exec+0x343>
      curproc->signalHandler[i]=SIG_DFL;
80100d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80100d53:	83 c0 04             	add    $0x4,%eax
  for(int i = 0 ; i < SIGNAL_HANDLERS_SIZE ; i++){
80100d56:	39 c2                	cmp    %eax,%edx
80100d58:	75 ee                	jne    80100d48 <exec+0x338>
  switchuvm(curproc);
80100d5a:	83 ec 0c             	sub    $0xc,%esp
80100d5d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d63:	e8 a8 62 00 00       	call   80107010 <switchuvm>
  freevm(oldpgdir);
80100d68:	89 3c 24             	mov    %edi,(%esp)
80100d6b:	e8 50 66 00 00       	call   801073c0 <freevm>
  return 0;
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	31 c0                	xor    %eax,%eax
80100d75:	e9 02 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d7a:	be 00 20 00 00       	mov    $0x2000,%esi
80100d7f:	e9 0d fe ff ff       	jmp    80100b91 <exec+0x181>
80100d84:	66 90                	xchg   %ax,%ax
80100d86:	66 90                	xchg   %ax,%ax
80100d88:	66 90                	xchg   %ax,%ax
80100d8a:	66 90                	xchg   %ax,%ax
80100d8c:	66 90                	xchg   %ax,%ax
80100d8e:	66 90                	xchg   %ax,%ax

80100d90 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d96:	68 6d 77 10 80       	push   $0x8010776d
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 9b 3b 00 00       	call   80104940 <initlock>
}
80100da5:	83 c4 10             	add    $0x10,%esp
80100da8:	c9                   	leave  
80100da9:	c3                   	ret    
80100daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100db0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100db4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100db9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 ba 3c 00 00       	call   80104a80 <acquire>
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	eb 10                	jmp    80100ddb <filealloc+0x2b>
80100dcb:	90                   	nop
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dd0:	83 c3 18             	add    $0x18,%ebx
80100dd3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100dd9:	73 25                	jae    80100e00 <filealloc+0x50>
    if(f->ref == 0){
80100ddb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dde:	85 c0                	test   %eax,%eax
80100de0:	75 ee                	jne    80100dd0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100de2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100de5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dec:	68 c0 0f 11 80       	push   $0x80110fc0
80100df1:	e8 4a 3d 00 00       	call   80104b40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100df6:	89 d8                	mov    %ebx,%eax
      return f;
80100df8:	83 c4 10             	add    $0x10,%esp
}
80100dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dfe:	c9                   	leave  
80100dff:	c3                   	ret    
  release(&ftable.lock);
80100e00:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e03:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e05:	68 c0 0f 11 80       	push   $0x80110fc0
80100e0a:	e8 31 3d 00 00       	call   80104b40 <release>
}
80100e0f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
}
80100e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e17:	c9                   	leave  
80100e18:	c3                   	ret    
80100e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	53                   	push   %ebx
80100e24:	83 ec 10             	sub    $0x10,%esp
80100e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e2a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e2f:	e8 4c 3c 00 00       	call   80104a80 <acquire>
  if(f->ref < 1)
80100e34:	8b 43 04             	mov    0x4(%ebx),%eax
80100e37:	83 c4 10             	add    $0x10,%esp
80100e3a:	85 c0                	test   %eax,%eax
80100e3c:	7e 1a                	jle    80100e58 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e3e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e41:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e44:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e47:	68 c0 0f 11 80       	push   $0x80110fc0
80100e4c:	e8 ef 3c 00 00       	call   80104b40 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 74 77 10 80       	push   $0x80107774
80100e60:	e8 2b f5 ff ff       	call   80100390 <panic>
80100e65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	57                   	push   %edi
80100e74:	56                   	push   %esi
80100e75:	53                   	push   %ebx
80100e76:	83 ec 28             	sub    $0x28,%esp
80100e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e7c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e81:	e8 fa 3b 00 00       	call   80104a80 <acquire>
  if(f->ref < 1)
80100e86:	8b 43 04             	mov    0x4(%ebx),%eax
80100e89:	83 c4 10             	add    $0x10,%esp
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	0f 8e 9b 00 00 00    	jle    80100f2f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e94:	83 e8 01             	sub    $0x1,%eax
80100e97:	85 c0                	test   %eax,%eax
80100e99:	89 43 04             	mov    %eax,0x4(%ebx)
80100e9c:	74 1a                	je     80100eb8 <fileclose+0x48>
    release(&ftable.lock);
80100e9e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea8:	5b                   	pop    %ebx
80100ea9:	5e                   	pop    %esi
80100eaa:	5f                   	pop    %edi
80100eab:	5d                   	pop    %ebp
    release(&ftable.lock);
80100eac:	e9 8f 3c 00 00       	jmp    80104b40 <release>
80100eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100eb8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ebc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ebe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ec1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ec4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eca:	88 45 e7             	mov    %al,-0x19(%ebp)
80100ecd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ed5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ed8:	e8 63 3c 00 00       	call   80104b40 <release>
  if(ff.type == FD_PIPE)
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	83 ff 01             	cmp    $0x1,%edi
80100ee3:	74 13                	je     80100ef8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ee5:	83 ff 02             	cmp    $0x2,%edi
80100ee8:	74 26                	je     80100f10 <fileclose+0xa0>
}
80100eea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eed:	5b                   	pop    %ebx
80100eee:	5e                   	pop    %esi
80100eef:	5f                   	pop    %edi
80100ef0:	5d                   	pop    %ebp
80100ef1:	c3                   	ret    
80100ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ef8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100efc:	83 ec 08             	sub    $0x8,%esp
80100eff:	53                   	push   %ebx
80100f00:	56                   	push   %esi
80100f01:	e8 8a 24 00 00       	call   80103390 <pipeclose>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb df                	jmp    80100eea <fileclose+0x7a>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f10:	e8 cb 1c 00 00       	call   80102be0 <begin_op>
    iput(ff.ip);
80100f15:	83 ec 0c             	sub    $0xc,%esp
80100f18:	ff 75 e0             	pushl  -0x20(%ebp)
80100f1b:	e8 c0 08 00 00       	call   801017e0 <iput>
    end_op();
80100f20:	83 c4 10             	add    $0x10,%esp
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
    end_op();
80100f2a:	e9 21 1d 00 00       	jmp    80102c50 <end_op>
    panic("fileclose");
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	68 7c 77 10 80       	push   $0x8010777c
80100f37:	e8 54 f4 ff ff       	call   80100390 <panic>
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f4a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f4d:	75 31                	jne    80100f80 <filestat+0x40>
    ilock(f->ip);
80100f4f:	83 ec 0c             	sub    $0xc,%esp
80100f52:	ff 73 10             	pushl  0x10(%ebx)
80100f55:	e8 56 07 00 00       	call   801016b0 <ilock>
    stati(f->ip, st);
80100f5a:	58                   	pop    %eax
80100f5b:	5a                   	pop    %edx
80100f5c:	ff 75 0c             	pushl  0xc(%ebp)
80100f5f:	ff 73 10             	pushl  0x10(%ebx)
80100f62:	e8 f9 09 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f67:	59                   	pop    %ecx
80100f68:	ff 73 10             	pushl  0x10(%ebx)
80100f6b:	e8 20 08 00 00       	call   80101790 <iunlock>
    return 0;
80100f70:	83 c4 10             	add    $0x10,%esp
80100f73:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f78:	c9                   	leave  
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f85:	eb ee                	jmp    80100f75 <filestat+0x35>
80100f87:	89 f6                	mov    %esi,%esi
80100f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f90 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 0c             	sub    $0xc,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fa2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fa6:	74 60                	je     80101008 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fa8:	8b 03                	mov    (%ebx),%eax
80100faa:	83 f8 01             	cmp    $0x1,%eax
80100fad:	74 41                	je     80100ff0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100faf:	83 f8 02             	cmp    $0x2,%eax
80100fb2:	75 5b                	jne    8010100f <fileread+0x7f>
    ilock(f->ip);
80100fb4:	83 ec 0c             	sub    $0xc,%esp
80100fb7:	ff 73 10             	pushl  0x10(%ebx)
80100fba:	e8 f1 06 00 00       	call   801016b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fbf:	57                   	push   %edi
80100fc0:	ff 73 14             	pushl  0x14(%ebx)
80100fc3:	56                   	push   %esi
80100fc4:	ff 73 10             	pushl  0x10(%ebx)
80100fc7:	e8 c4 09 00 00       	call   80101990 <readi>
80100fcc:	83 c4 20             	add    $0x20,%esp
80100fcf:	85 c0                	test   %eax,%eax
80100fd1:	89 c6                	mov    %eax,%esi
80100fd3:	7e 03                	jle    80100fd8 <fileread+0x48>
      f->off += r;
80100fd5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fd8:	83 ec 0c             	sub    $0xc,%esp
80100fdb:	ff 73 10             	pushl  0x10(%ebx)
80100fde:	e8 ad 07 00 00       	call   80101790 <iunlock>
    return r;
80100fe3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe9:	89 f0                	mov    %esi,%eax
80100feb:	5b                   	pop    %ebx
80100fec:	5e                   	pop    %esi
80100fed:	5f                   	pop    %edi
80100fee:	5d                   	pop    %ebp
80100fef:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100ff0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100ff3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	5b                   	pop    %ebx
80100ffa:	5e                   	pop    %esi
80100ffb:	5f                   	pop    %edi
80100ffc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100ffd:	e9 3e 25 00 00       	jmp    80103540 <piperead>
80101002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101008:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010100d:	eb d7                	jmp    80100fe6 <fileread+0x56>
  panic("fileread");
8010100f:	83 ec 0c             	sub    $0xc,%esp
80101012:	68 86 77 10 80       	push   $0x80107786
80101017:	e8 74 f3 ff ff       	call   80100390 <panic>
8010101c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101020 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 1c             	sub    $0x1c,%esp
80101029:	8b 75 08             	mov    0x8(%ebp),%esi
8010102c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010102f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101033:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101036:	8b 45 10             	mov    0x10(%ebp),%eax
80101039:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010103c:	0f 84 aa 00 00 00    	je     801010ec <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101042:	8b 06                	mov    (%esi),%eax
80101044:	83 f8 01             	cmp    $0x1,%eax
80101047:	0f 84 c3 00 00 00    	je     80101110 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104d:	83 f8 02             	cmp    $0x2,%eax
80101050:	0f 85 d9 00 00 00    	jne    8010112f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101059:	31 ff                	xor    %edi,%edi
    while(i < n){
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 34                	jg     80101093 <filewrite+0x73>
8010105f:	e9 9c 00 00 00       	jmp    80101100 <filewrite+0xe0>
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101068:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101071:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101074:	e8 17 07 00 00       	call   80101790 <iunlock>
      end_op();
80101079:	e8 d2 1b 00 00       	call   80102c50 <end_op>
8010107e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101081:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101084:	39 c3                	cmp    %eax,%ebx
80101086:	0f 85 96 00 00 00    	jne    80101122 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010108c:	01 df                	add    %ebx,%edi
    while(i < n){
8010108e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101091:	7e 6d                	jle    80101100 <filewrite+0xe0>
      int n1 = n - i;
80101093:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101096:	b8 00 06 00 00       	mov    $0x600,%eax
8010109b:	29 fb                	sub    %edi,%ebx
8010109d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010a3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010a6:	e8 35 1b 00 00       	call   80102be0 <begin_op>
      ilock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
801010b1:	e8 fa 05 00 00       	call   801016b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b9:	53                   	push   %ebx
801010ba:	ff 76 14             	pushl  0x14(%esi)
801010bd:	01 f8                	add    %edi,%eax
801010bf:	50                   	push   %eax
801010c0:	ff 76 10             	pushl  0x10(%esi)
801010c3:	e8 c8 09 00 00       	call   80101a90 <writei>
801010c8:	83 c4 20             	add    $0x20,%esp
801010cb:	85 c0                	test   %eax,%eax
801010cd:	7f 99                	jg     80101068 <filewrite+0x48>
      iunlock(f->ip);
801010cf:	83 ec 0c             	sub    $0xc,%esp
801010d2:	ff 76 10             	pushl  0x10(%esi)
801010d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010d8:	e8 b3 06 00 00       	call   80101790 <iunlock>
      end_op();
801010dd:	e8 6e 1b 00 00       	call   80102c50 <end_op>
      if(r < 0)
801010e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	85 c0                	test   %eax,%eax
801010ea:	74 98                	je     80101084 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ef:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010f4:	89 f8                	mov    %edi,%eax
801010f6:	5b                   	pop    %ebx
801010f7:	5e                   	pop    %esi
801010f8:	5f                   	pop    %edi
801010f9:	5d                   	pop    %ebp
801010fa:	c3                   	ret    
801010fb:	90                   	nop
801010fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101100:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101103:	75 e7                	jne    801010ec <filewrite+0xcc>
}
80101105:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101108:	89 f8                	mov    %edi,%eax
8010110a:	5b                   	pop    %ebx
8010110b:	5e                   	pop    %esi
8010110c:	5f                   	pop    %edi
8010110d:	5d                   	pop    %ebp
8010110e:	c3                   	ret    
8010110f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101110:	8b 46 0c             	mov    0xc(%esi),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010111d:	e9 0e 23 00 00       	jmp    80103430 <pipewrite>
        panic("short filewrite");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 8f 77 10 80       	push   $0x8010778f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 95 77 10 80       	push   $0x80107795
80101137:	e8 54 f2 ff ff       	call   80100390 <panic>
8010113c:	66 90                	xchg   %ax,%ax
8010113e:	66 90                	xchg   %ax,%ax

80101140 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	56                   	push   %esi
80101144:	53                   	push   %ebx
80101145:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101147:	c1 ea 0c             	shr    $0xc,%edx
8010114a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101150:	83 ec 08             	sub    $0x8,%esp
80101153:	52                   	push   %edx
80101154:	50                   	push   %eax
80101155:	e8 76 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010115a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010115c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010115f:	ba 01 00 00 00       	mov    $0x1,%edx
80101164:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101167:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010116d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101170:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101172:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101177:	85 d1                	test   %edx,%ecx
80101179:	74 25                	je     801011a0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010117b:	f7 d2                	not    %edx
8010117d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101182:	21 ca                	and    %ecx,%edx
80101184:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101188:	56                   	push   %esi
80101189:	e8 22 1c 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010118e:	89 34 24             	mov    %esi,(%esp)
80101191:	e8 4a f0 ff ff       	call   801001e0 <brelse>
}
80101196:	83 c4 10             	add    $0x10,%esp
80101199:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010119c:	5b                   	pop    %ebx
8010119d:	5e                   	pop    %esi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    panic("freeing free block");
801011a0:	83 ec 0c             	sub    $0xc,%esp
801011a3:	68 9f 77 10 80       	push   $0x8010779f
801011a8:	e8 e3 f1 ff ff       	call   80100390 <panic>
801011ad:	8d 76 00             	lea    0x0(%esi),%esi

801011b0 <balloc>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011b9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
801011bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011c2:	85 c9                	test   %ecx,%ecx
801011c4:	0f 84 87 00 00 00    	je     80101251 <balloc+0xa1>
801011ca:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	89 f0                	mov    %esi,%eax
801011d9:	c1 f8 0c             	sar    $0xc,%eax
801011dc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011e2:	50                   	push   %eax
801011e3:	ff 75 d8             	pushl  -0x28(%ebp)
801011e6:	e8 e5 ee ff ff       	call   801000d0 <bread>
801011eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ee:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011f3:	83 c4 10             	add    $0x10,%esp
801011f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011f9:	31 c0                	xor    %eax,%eax
801011fb:	eb 2f                	jmp    8010122c <balloc+0x7c>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101200:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101205:	bb 01 00 00 00       	mov    $0x1,%ebx
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010120f:	89 c1                	mov    %eax,%ecx
80101211:	c1 f9 03             	sar    $0x3,%ecx
80101214:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101219:	85 df                	test   %ebx,%edi
8010121b:	89 fa                	mov    %edi,%edx
8010121d:	74 41                	je     80101260 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121f:	83 c0 01             	add    $0x1,%eax
80101222:	83 c6 01             	add    $0x1,%esi
80101225:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122a:	74 05                	je     80101231 <balloc+0x81>
8010122c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010122f:	77 cf                	ja     80101200 <balloc+0x50>
    brelse(bp);
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	ff 75 e4             	pushl  -0x1c(%ebp)
80101237:	e8 a4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101243:	83 c4 10             	add    $0x10,%esp
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010124f:	77 80                	ja     801011d1 <balloc+0x21>
  panic("balloc: out of blocks");
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 b2 77 10 80       	push   $0x801077b2
80101259:	e8 32 f1 ff ff       	call   80100390 <panic>
8010125e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101260:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101263:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101266:	09 da                	or     %ebx,%edx
80101268:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010126c:	57                   	push   %edi
8010126d:	e8 3e 1b 00 00       	call   80102db0 <log_write>
        brelse(bp);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010127a:	58                   	pop    %eax
8010127b:	5a                   	pop    %edx
8010127c:	56                   	push   %esi
8010127d:	ff 75 d8             	pushl  -0x28(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101287:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128a:	83 c4 0c             	add    $0xc,%esp
8010128d:	68 00 02 00 00       	push   $0x200
80101292:	6a 00                	push   $0x0
80101294:	50                   	push   %eax
80101295:	e8 f6 38 00 00       	call   80104b90 <memset>
  log_write(bp);
8010129a:	89 1c 24             	mov    %ebx,(%esp)
8010129d:	e8 0e 1b 00 00       	call   80102db0 <log_write>
  brelse(bp);
801012a2:	89 1c 24             	mov    %ebx,(%esp)
801012a5:	e8 36 ef ff ff       	call   801001e0 <brelse>
}
801012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ad:	89 f0                	mov    %esi,%eax
801012af:	5b                   	pop    %ebx
801012b0:	5e                   	pop    %esi
801012b1:	5f                   	pop    %edi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
801012b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012c0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	57                   	push   %edi
801012c4:	56                   	push   %esi
801012c5:	53                   	push   %ebx
801012c6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012c8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ca:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012cf:	83 ec 28             	sub    $0x28,%esp
801012d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012d5:	68 e0 19 11 80       	push   $0x801119e0
801012da:	e8 a1 37 00 00       	call   80104a80 <acquire>
801012df:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012e5:	eb 17                	jmp    801012fe <iget+0x3e>
801012e7:	89 f6                	mov    %esi,%esi
801012e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012f6:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012fc:	73 22                	jae    80101320 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012fe:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101301:	85 c9                	test   %ecx,%ecx
80101303:	7e 04                	jle    80101309 <iget+0x49>
80101305:	39 3b                	cmp    %edi,(%ebx)
80101307:	74 4f                	je     80101358 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101309:	85 f6                	test   %esi,%esi
8010130b:	75 e3                	jne    801012f0 <iget+0x30>
8010130d:	85 c9                	test   %ecx,%ecx
8010130f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101318:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010131e:	72 de                	jb     801012fe <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 5b                	je     8010137f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101324:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101327:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101329:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010132c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101333:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010133a:	68 e0 19 11 80       	push   $0x801119e0
8010133f:	e8 fc 37 00 00       	call   80104b40 <release>

  return ip;
80101344:	83 c4 10             	add    $0x10,%esp
}
80101347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134a:	89 f0                	mov    %esi,%eax
8010134c:	5b                   	pop    %ebx
8010134d:	5e                   	pop    %esi
8010134e:	5f                   	pop    %edi
8010134f:	5d                   	pop    %ebp
80101350:	c3                   	ret    
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101358:	39 53 04             	cmp    %edx,0x4(%ebx)
8010135b:	75 ac                	jne    80101309 <iget+0x49>
      release(&icache.lock);
8010135d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101360:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101363:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010136a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010136d:	e8 ce 37 00 00       	call   80104b40 <release>
      return ip;
80101372:	83 c4 10             	add    $0x10,%esp
}
80101375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101378:	89 f0                	mov    %esi,%eax
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
    panic("iget: no inodes");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 c8 77 10 80       	push   $0x801077c8
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	89 c6                	mov    %eax,%esi
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	77 18                	ja     801013b8 <bmap+0x28>
801013a0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013a3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013a6:	85 db                	test   %ebx,%ebx
801013a8:	74 76                	je     80101420 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013ad:	89 d8                	mov    %ebx,%eax
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5f                   	pop    %edi
801013b2:	5d                   	pop    %ebp
801013b3:	c3                   	ret    
801013b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013b8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013bb:	83 fb 7f             	cmp    $0x7f,%ebx
801013be:	0f 87 90 00 00 00    	ja     80101454 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013ca:	8b 00                	mov    (%eax),%eax
801013cc:	85 d2                	test   %edx,%edx
801013ce:	74 70                	je     80101440 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013d0:	83 ec 08             	sub    $0x8,%esp
801013d3:	52                   	push   %edx
801013d4:	50                   	push   %eax
801013d5:	e8 f6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013da:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013de:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013e1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013e3:	8b 1a                	mov    (%edx),%ebx
801013e5:	85 db                	test   %ebx,%ebx
801013e7:	75 1d                	jne    80101406 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013e9:	8b 06                	mov    (%esi),%eax
801013eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013ee:	e8 bd fd ff ff       	call   801011b0 <balloc>
801013f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013f6:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801013f9:	89 c3                	mov    %eax,%ebx
801013fb:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013fd:	57                   	push   %edi
801013fe:	e8 ad 19 00 00       	call   80102db0 <log_write>
80101403:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
80101409:	57                   	push   %edi
8010140a:	e8 d1 ed ff ff       	call   801001e0 <brelse>
8010140f:	83 c4 10             	add    $0x10,%esp
}
80101412:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101415:	89 d8                	mov    %ebx,%eax
80101417:	5b                   	pop    %ebx
80101418:	5e                   	pop    %esi
80101419:	5f                   	pop    %edi
8010141a:	5d                   	pop    %ebp
8010141b:	c3                   	ret    
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101420:	8b 00                	mov    (%eax),%eax
80101422:	e8 89 fd ff ff       	call   801011b0 <balloc>
80101427:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010142a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010142d:	89 c3                	mov    %eax,%ebx
}
8010142f:	89 d8                	mov    %ebx,%eax
80101431:	5b                   	pop    %ebx
80101432:	5e                   	pop    %esi
80101433:	5f                   	pop    %edi
80101434:	5d                   	pop    %ebp
80101435:	c3                   	ret    
80101436:	8d 76 00             	lea    0x0(%esi),%esi
80101439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101440:	e8 6b fd ff ff       	call   801011b0 <balloc>
80101445:	89 c2                	mov    %eax,%edx
80101447:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010144d:	8b 06                	mov    (%esi),%eax
8010144f:	e9 7c ff ff ff       	jmp    801013d0 <bmap+0x40>
  panic("bmap: out of range");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 d8 77 10 80       	push   $0x801077d8
8010145c:	e8 2f ef ff ff       	call   80100390 <panic>
80101461:	eb 0d                	jmp    80101470 <readsb>
80101463:	90                   	nop
80101464:	90                   	nop
80101465:	90                   	nop
80101466:	90                   	nop
80101467:	90                   	nop
80101468:	90                   	nop
80101469:	90                   	nop
8010146a:	90                   	nop
8010146b:	90                   	nop
8010146c:	90                   	nop
8010146d:	90                   	nop
8010146e:	90                   	nop
8010146f:	90                   	nop

80101470 <readsb>:
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101478:	83 ec 08             	sub    $0x8,%esp
8010147b:	6a 01                	push   $0x1
8010147d:	ff 75 08             	pushl  0x8(%ebp)
80101480:	e8 4b ec ff ff       	call   801000d0 <bread>
80101485:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101487:	8d 40 5c             	lea    0x5c(%eax),%eax
8010148a:	83 c4 0c             	add    $0xc,%esp
8010148d:	6a 1c                	push   $0x1c
8010148f:	50                   	push   %eax
80101490:	56                   	push   %esi
80101491:	e8 aa 37 00 00       	call   80104c40 <memmove>
  brelse(bp);
80101496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101499:	83 c4 10             	add    $0x10,%esp
}
8010149c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010149f:	5b                   	pop    %ebx
801014a0:	5e                   	pop    %esi
801014a1:	5d                   	pop    %ebp
  brelse(bp);
801014a2:	e9 39 ed ff ff       	jmp    801001e0 <brelse>
801014a7:	89 f6                	mov    %esi,%esi
801014a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014b0 <iinit>:
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	53                   	push   %ebx
801014b4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014b9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014bc:	68 eb 77 10 80       	push   $0x801077eb
801014c1:	68 e0 19 11 80       	push   $0x801119e0
801014c6:	e8 75 34 00 00       	call   80104940 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 f2 77 10 80       	push   $0x801077f2
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 2c 33 00 00       	call   80104810 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014e4:	83 c4 10             	add    $0x10,%esp
801014e7:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801014ed:	75 e1                	jne    801014d0 <iinit+0x20>
  readsb(dev, &sb);
801014ef:	83 ec 08             	sub    $0x8,%esp
801014f2:	68 c0 19 11 80       	push   $0x801119c0
801014f7:	ff 75 08             	pushl  0x8(%ebp)
801014fa:	e8 71 ff ff ff       	call   80101470 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014ff:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101505:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010150b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101511:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101517:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010151d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101523:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101529:	68 58 78 10 80       	push   $0x80107858
8010152e:	e8 2d f1 ff ff       	call   80100660 <cprintf>
}
80101533:	83 c4 30             	add    $0x30,%esp
80101536:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101539:	c9                   	leave  
8010153a:	c3                   	ret    
8010153b:	90                   	nop
8010153c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101540 <ialloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101550:	8b 45 0c             	mov    0xc(%ebp),%eax
80101553:	8b 75 08             	mov    0x8(%ebp),%esi
80101556:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	0f 86 91 00 00 00    	jbe    801015f0 <ialloc+0xb0>
8010155f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101564:	eb 21                	jmp    80101587 <ialloc+0x47>
80101566:	8d 76 00             	lea    0x0(%esi),%esi
80101569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101570:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101573:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101576:	57                   	push   %edi
80101577:	e8 64 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101585:	76 69                	jbe    801015f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101587:	89 d8                	mov    %ebx,%eax
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	c1 e8 03             	shr    $0x3,%eax
8010158f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101595:	50                   	push   %eax
80101596:	56                   	push   %esi
80101597:	e8 34 eb ff ff       	call   801000d0 <bread>
8010159c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010159e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015a0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015a3:	83 e0 07             	and    $0x7,%eax
801015a6:	c1 e0 06             	shl    $0x6,%eax
801015a9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015b1:	75 bd                	jne    80101570 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015b3:	83 ec 04             	sub    $0x4,%esp
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	6a 40                	push   $0x40
801015bb:	6a 00                	push   $0x0
801015bd:	51                   	push   %ecx
801015be:	e8 cd 35 00 00       	call   80104b90 <memset>
      dip->type = type;
801015c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015cd:	89 3c 24             	mov    %edi,(%esp)
801015d0:	e8 db 17 00 00       	call   80102db0 <log_write>
      brelse(bp);
801015d5:	89 3c 24             	mov    %edi,(%esp)
801015d8:	e8 03 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015dd:	83 c4 10             	add    $0x10,%esp
}
801015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015e3:	89 da                	mov    %ebx,%edx
801015e5:	89 f0                	mov    %esi,%eax
}
801015e7:	5b                   	pop    %ebx
801015e8:	5e                   	pop    %esi
801015e9:	5f                   	pop    %edi
801015ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801015eb:	e9 d0 fc ff ff       	jmp    801012c0 <iget>
  panic("ialloc: no inodes");
801015f0:	83 ec 0c             	sub    $0xc,%esp
801015f3:	68 f8 77 10 80       	push   $0x801077f8
801015f8:	e8 93 ed ff ff       	call   80100390 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101608:	83 ec 08             	sub    $0x8,%esp
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010161a:	50                   	push   %eax
8010161b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010161e:	e8 ad ea ff ff       	call   801000d0 <bread>
80101623:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101625:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101628:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010162f:	83 e0 07             	and    $0x7,%eax
80101632:	c1 e0 06             	shl    $0x6,%eax
80101635:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101639:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010163c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101640:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101643:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101647:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010164b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010164f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101653:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101657:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010165a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165d:	6a 34                	push   $0x34
8010165f:	53                   	push   %ebx
80101660:	50                   	push   %eax
80101661:	e8 da 35 00 00       	call   80104c40 <memmove>
  log_write(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 42 17 00 00       	call   80102db0 <log_write>
  brelse(bp);
8010166e:	89 75 08             	mov    %esi,0x8(%ebp)
80101671:	83 c4 10             	add    $0x10,%esp
}
80101674:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5d                   	pop    %ebp
  brelse(bp);
8010167a:	e9 61 eb ff ff       	jmp    801001e0 <brelse>
8010167f:	90                   	nop

80101680 <idup>:
{
80101680:	55                   	push   %ebp
80101681:	89 e5                	mov    %esp,%ebp
80101683:	53                   	push   %ebx
80101684:	83 ec 10             	sub    $0x10,%esp
80101687:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010168a:	68 e0 19 11 80       	push   $0x801119e0
8010168f:	e8 ec 33 00 00       	call   80104a80 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010169f:	e8 9c 34 00 00       	call   80104b40 <release>
}
801016a4:	89 d8                	mov    %ebx,%eax
801016a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a9:	c9                   	leave  
801016aa:	c3                   	ret    
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <ilock>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	56                   	push   %esi
801016b4:	53                   	push   %ebx
801016b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016b8:	85 db                	test   %ebx,%ebx
801016ba:	0f 84 b7 00 00 00    	je     80101777 <ilock+0xc7>
801016c0:	8b 53 08             	mov    0x8(%ebx),%edx
801016c3:	85 d2                	test   %edx,%edx
801016c5:	0f 8e ac 00 00 00    	jle    80101777 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ce:	83 ec 0c             	sub    $0xc,%esp
801016d1:	50                   	push   %eax
801016d2:	e8 79 31 00 00       	call   80104850 <acquiresleep>
  if(ip->valid == 0){
801016d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016da:	83 c4 10             	add    $0x10,%esp
801016dd:	85 c0                	test   %eax,%eax
801016df:	74 0f                	je     801016f0 <ilock+0x40>
}
801016e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016e4:	5b                   	pop    %ebx
801016e5:	5e                   	pop    %esi
801016e6:	5d                   	pop    %ebp
801016e7:	c3                   	ret    
801016e8:	90                   	nop
801016e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f0:	8b 43 04             	mov    0x4(%ebx),%eax
801016f3:	83 ec 08             	sub    $0x8,%esp
801016f6:	c1 e8 03             	shr    $0x3,%eax
801016f9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ff:	50                   	push   %eax
80101700:	ff 33                	pushl  (%ebx)
80101702:	e8 c9 e9 ff ff       	call   801000d0 <bread>
80101707:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101709:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010170c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010170f:	83 e0 07             	and    $0x7,%eax
80101712:	c1 e0 06             	shl    $0x6,%eax
80101715:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101719:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010171f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101723:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101727:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010172b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010172f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101733:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101737:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010173b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010173e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101741:	6a 34                	push   $0x34
80101743:	50                   	push   %eax
80101744:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101747:	50                   	push   %eax
80101748:	e8 f3 34 00 00       	call   80104c40 <memmove>
    brelse(bp);
8010174d:	89 34 24             	mov    %esi,(%esp)
80101750:	e8 8b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101755:	83 c4 10             	add    $0x10,%esp
80101758:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010175d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101764:	0f 85 77 ff ff ff    	jne    801016e1 <ilock+0x31>
      panic("ilock: no type");
8010176a:	83 ec 0c             	sub    $0xc,%esp
8010176d:	68 10 78 10 80       	push   $0x80107810
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 0a 78 10 80       	push   $0x8010780a
8010177f:	e8 0c ec ff ff       	call   80100390 <panic>
80101784:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010178a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101790 <iunlock>:
{
80101790:	55                   	push   %ebp
80101791:	89 e5                	mov    %esp,%ebp
80101793:	56                   	push   %esi
80101794:	53                   	push   %ebx
80101795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101798:	85 db                	test   %ebx,%ebx
8010179a:	74 28                	je     801017c4 <iunlock+0x34>
8010179c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	56                   	push   %esi
801017a3:	e8 48 31 00 00       	call   801048f0 <holdingsleep>
801017a8:	83 c4 10             	add    $0x10,%esp
801017ab:	85 c0                	test   %eax,%eax
801017ad:	74 15                	je     801017c4 <iunlock+0x34>
801017af:	8b 43 08             	mov    0x8(%ebx),%eax
801017b2:	85 c0                	test   %eax,%eax
801017b4:	7e 0e                	jle    801017c4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017b6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017bf:	e9 ec 30 00 00       	jmp    801048b0 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 1f 78 10 80       	push   $0x8010781f
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <iput>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 28             	sub    $0x28,%esp
801017e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017ec:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ef:	57                   	push   %edi
801017f0:	e8 5b 30 00 00       	call   80104850 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 d2                	test   %edx,%edx
801017fd:	74 07                	je     80101806 <iput+0x26>
801017ff:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101804:	74 32                	je     80101838 <iput+0x58>
  releasesleep(&ip->lock);
80101806:	83 ec 0c             	sub    $0xc,%esp
80101809:	57                   	push   %edi
8010180a:	e8 a1 30 00 00       	call   801048b0 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101816:	e8 65 32 00 00       	call   80104a80 <acquire>
  ip->ref--;
8010181b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010181f:	83 c4 10             	add    $0x10,%esp
80101822:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101829:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182c:	5b                   	pop    %ebx
8010182d:	5e                   	pop    %esi
8010182e:	5f                   	pop    %edi
8010182f:	5d                   	pop    %ebp
  release(&icache.lock);
80101830:	e9 0b 33 00 00       	jmp    80104b40 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 e0 19 11 80       	push   $0x801119e0
80101840:	e8 3b 32 00 00       	call   80104a80 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010184f:	e8 ec 32 00 00       	call   80104b40 <release>
    if(r == 1){
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	83 fe 01             	cmp    $0x1,%esi
8010185a:	75 aa                	jne    80101806 <iput+0x26>
8010185c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101862:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101865:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101868:	89 cf                	mov    %ecx,%edi
8010186a:	eb 0b                	jmp    80101877 <iput+0x97>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101870:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101873:	39 fe                	cmp    %edi,%esi
80101875:	74 19                	je     80101890 <iput+0xb0>
    if(ip->addrs[i]){
80101877:	8b 16                	mov    (%esi),%edx
80101879:	85 d2                	test   %edx,%edx
8010187b:	74 f3                	je     80101870 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010187d:	8b 03                	mov    (%ebx),%eax
8010187f:	e8 bc f8 ff ff       	call   80101140 <bfree>
      ip->addrs[i] = 0;
80101884:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010188a:	eb e4                	jmp    80101870 <iput+0x90>
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101890:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101896:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101899:	85 c0                	test   %eax,%eax
8010189b:	75 33                	jne    801018d0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010189d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018a7:	53                   	push   %ebx
801018a8:	e8 53 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
801018ad:	31 c0                	xor    %eax,%eax
801018af:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018b3:	89 1c 24             	mov    %ebx,(%esp)
801018b6:	e8 45 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018bb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018c2:	83 c4 10             	add    $0x10,%esp
801018c5:	e9 3c ff ff ff       	jmp    80101806 <iput+0x26>
801018ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	ff 33                	pushl  (%ebx)
801018d6:	e8 f5 e7 ff ff       	call   801000d0 <bread>
801018db:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018e1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018e7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ea:	83 c4 10             	add    $0x10,%esp
801018ed:	89 cf                	mov    %ecx,%edi
801018ef:	eb 0e                	jmp    801018ff <iput+0x11f>
801018f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018fb:	39 fe                	cmp    %edi,%esi
801018fd:	74 0f                	je     8010190e <iput+0x12e>
      if(a[j])
801018ff:	8b 16                	mov    (%esi),%edx
80101901:	85 d2                	test   %edx,%edx
80101903:	74 f3                	je     801018f8 <iput+0x118>
        bfree(ip->dev, a[j]);
80101905:	8b 03                	mov    (%ebx),%eax
80101907:	e8 34 f8 ff ff       	call   80101140 <bfree>
8010190c:	eb ea                	jmp    801018f8 <iput+0x118>
    brelse(bp);
8010190e:	83 ec 0c             	sub    $0xc,%esp
80101911:	ff 75 e4             	pushl  -0x1c(%ebp)
80101914:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101917:	e8 c4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010191c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101922:	8b 03                	mov    (%ebx),%eax
80101924:	e8 17 f8 ff ff       	call   80101140 <bfree>
    ip->addrs[NDIRECT] = 0;
80101929:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101930:	00 00 00 
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	e9 62 ff ff ff       	jmp    8010189d <iput+0xbd>
8010193b:	90                   	nop
8010193c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 10             	sub    $0x10,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	53                   	push   %ebx
8010194b:	e8 40 fe ff ff       	call   80101790 <iunlock>
  iput(ip);
80101950:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101953:	83 c4 10             	add    $0x10,%esp
}
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
  iput(ip);
8010195a:	e9 81 fe ff ff       	jmp    801017e0 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 1c             	sub    $0x1c,%esp
80101999:	8b 45 08             	mov    0x8(%ebp),%eax
8010199c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010199f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019a7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019ad:	8b 75 10             	mov    0x10(%ebp),%esi
801019b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b3:	0f 84 a7 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019bc:	8b 40 58             	mov    0x58(%eax),%eax
801019bf:	39 c6                	cmp    %eax,%esi
801019c1:	0f 87 ba 00 00 00    	ja     80101a81 <readi+0xf1>
801019c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ca:	89 f9                	mov    %edi,%ecx
801019cc:	01 f1                	add    %esi,%ecx
801019ce:	0f 82 ad 00 00 00    	jb     80101a81 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019d4:	89 c2                	mov    %eax,%edx
801019d6:	29 f2                	sub    %esi,%edx
801019d8:	39 c8                	cmp    %ecx,%eax
801019da:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019dd:	31 ff                	xor    %edi,%edi
801019df:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019e4:	74 6c                	je     80101a52 <readi+0xc2>
801019e6:	8d 76 00             	lea    0x0(%esi),%esi
801019e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019f0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019f3:	89 f2                	mov    %esi,%edx
801019f5:	c1 ea 09             	shr    $0x9,%edx
801019f8:	89 d8                	mov    %ebx,%eax
801019fa:	e8 91 f9 ff ff       	call   80101390 <bmap>
801019ff:	83 ec 08             	sub    $0x8,%esp
80101a02:	50                   	push   %eax
80101a03:	ff 33                	pushl  (%ebx)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0f:	89 f0                	mov    %esi,%eax
80101a11:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a16:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a1b:	83 c4 0c             	add    $0xc,%esp
80101a1e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a24:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	29 fb                	sub    %edi,%ebx
80101a29:	39 d9                	cmp    %ebx,%ecx
80101a2b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2e:	53                   	push   %ebx
80101a2f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a30:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a35:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a37:	e8 04 32 00 00       	call   80104c40 <memmove>
    brelse(bp);
80101a3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a3f:	89 14 24             	mov    %edx,(%esp)
80101a42:	e8 99 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a50:	77 9e                	ja     801019f0 <readi+0x60>
  }
  return n;
80101a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a58:	5b                   	pop    %ebx
80101a59:	5e                   	pop    %esi
80101a5a:	5f                   	pop    %edi
80101a5b:	5d                   	pop    %ebp
80101a5c:	c3                   	ret    
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 17                	ja     80101a81 <readi+0xf1>
80101a6a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 0c                	je     80101a81 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a7b:	5b                   	pop    %ebx
80101a7c:	5e                   	pop    %esi
80101a7d:	5f                   	pop    %edi
80101a7e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a7f:	ff e0                	jmp    *%eax
      return -1;
80101a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a86:	eb cd                	jmp    80101a55 <readi+0xc5>
80101a88:	90                   	nop
80101a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 1c             	sub    $0x1c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aad:	8b 75 10             	mov    0x10(%ebp),%esi
80101ab0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 eb 00 00 00    	jb     80101bb0 <writei+0x120>
80101ac5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ac8:	31 d2                	xor    %edx,%edx
80101aca:	89 f8                	mov    %edi,%eax
80101acc:	01 f0                	add    %esi,%eax
80101ace:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad6:	0f 87 d4 00 00 00    	ja     80101bb0 <writei+0x120>
80101adc:	85 d2                	test   %edx,%edx
80101ade:	0f 85 cc 00 00 00    	jne    80101bb0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ae4:	85 ff                	test   %edi,%edi
80101ae6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aed:	74 72                	je     80101b61 <writei+0xd1>
80101aef:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101af3:	89 f2                	mov    %esi,%edx
80101af5:	c1 ea 09             	shr    $0x9,%edx
80101af8:	89 f8                	mov    %edi,%eax
80101afa:	e8 91 f8 ff ff       	call   80101390 <bmap>
80101aff:	83 ec 08             	sub    $0x8,%esp
80101b02:	50                   	push   %eax
80101b03:	ff 37                	pushl  (%edi)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b0d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b12:	89 f0                	mov    %esi,%eax
80101b14:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b19:	83 c4 0c             	add    $0xc,%esp
80101b1c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b21:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b27:	39 d9                	cmp    %ebx,%ecx
80101b29:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b2c:	53                   	push   %ebx
80101b2d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b30:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b32:	50                   	push   %eax
80101b33:	e8 08 31 00 00       	call   80104c40 <memmove>
    log_write(bp);
80101b38:	89 3c 24             	mov    %edi,(%esp)
80101b3b:	e8 70 12 00 00       	call   80102db0 <log_write>
    brelse(bp);
80101b40:	89 3c 24             	mov    %edi,(%esp)
80101b43:	e8 98 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b48:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b4e:	83 c4 10             	add    $0x10,%esp
80101b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b57:	77 97                	ja     80101af0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b5f:	77 37                	ja     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b67:	5b                   	pop    %ebx
80101b68:	5e                   	pop    %esi
80101b69:	5f                   	pop    %edi
80101b6a:	5d                   	pop    %ebp
80101b6b:	c3                   	ret    
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 36                	ja     80101bb0 <writei+0x120>
80101b7a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 2b                	je     80101bb0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b9b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b9e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101ba1:	50                   	push   %eax
80101ba2:	e8 59 fa ff ff       	call   80101600 <iupdate>
80101ba7:	83 c4 10             	add    $0x10,%esp
80101baa:	eb b5                	jmp    80101b61 <writei+0xd1>
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb5:	eb ad                	jmp    80101b64 <writei+0xd4>
80101bb7:	89 f6                	mov    %esi,%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	6a 0e                	push   $0xe
80101bc8:	ff 75 0c             	pushl  0xc(%ebp)
80101bcb:	ff 75 08             	pushl  0x8(%ebp)
80101bce:	e8 dd 30 00 00       	call   80104cb0 <strncmp>
}
80101bd3:	c9                   	leave  
80101bd4:	c3                   	ret    
80101bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101be0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101be0:	55                   	push   %ebp
80101be1:	89 e5                	mov    %esp,%ebp
80101be3:	57                   	push   %edi
80101be4:	56                   	push   %esi
80101be5:	53                   	push   %ebx
80101be6:	83 ec 1c             	sub    $0x1c,%esp
80101be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bf1:	0f 85 85 00 00 00    	jne    80101c7c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bf7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bfa:	31 ff                	xor    %edi,%edi
80101bfc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bff:	85 d2                	test   %edx,%edx
80101c01:	74 3e                	je     80101c41 <dirlookup+0x61>
80101c03:	90                   	nop
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c08:	6a 10                	push   $0x10
80101c0a:	57                   	push   %edi
80101c0b:	56                   	push   %esi
80101c0c:	53                   	push   %ebx
80101c0d:	e8 7e fd ff ff       	call   80101990 <readi>
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	83 f8 10             	cmp    $0x10,%eax
80101c18:	75 55                	jne    80101c6f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c1f:	74 18                	je     80101c39 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c24:	83 ec 04             	sub    $0x4,%esp
80101c27:	6a 0e                	push   $0xe
80101c29:	50                   	push   %eax
80101c2a:	ff 75 0c             	pushl  0xc(%ebp)
80101c2d:	e8 7e 30 00 00       	call   80104cb0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	85 c0                	test   %eax,%eax
80101c37:	74 17                	je     80101c50 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c39:	83 c7 10             	add    $0x10,%edi
80101c3c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c3f:	72 c7                	jb     80101c08 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c44:	31 c0                	xor    %eax,%eax
}
80101c46:	5b                   	pop    %ebx
80101c47:	5e                   	pop    %esi
80101c48:	5f                   	pop    %edi
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c50:	8b 45 10             	mov    0x10(%ebp),%eax
80101c53:	85 c0                	test   %eax,%eax
80101c55:	74 05                	je     80101c5c <dirlookup+0x7c>
        *poff = off;
80101c57:	8b 45 10             	mov    0x10(%ebp),%eax
80101c5a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c5c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c60:	8b 03                	mov    (%ebx),%eax
80101c62:	e8 59 f6 ff ff       	call   801012c0 <iget>
}
80101c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6a:	5b                   	pop    %ebx
80101c6b:	5e                   	pop    %esi
80101c6c:	5f                   	pop    %edi
80101c6d:	5d                   	pop    %ebp
80101c6e:	c3                   	ret    
      panic("dirlookup read");
80101c6f:	83 ec 0c             	sub    $0xc,%esp
80101c72:	68 39 78 10 80       	push   $0x80107839
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 27 78 10 80       	push   $0x80107827
80101c84:	e8 07 e7 ff ff       	call   80100390 <panic>
80101c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	56                   	push   %esi
80101c95:	53                   	push   %ebx
80101c96:	89 cf                	mov    %ecx,%edi
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 67 01 00 00    	je     80101e10 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 52 1b 00 00       	call   80103800 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 e0 19 11 80       	push   $0x801119e0
80101cb9:	e8 c2 2d 00 00       	call   80104a80 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cc9:	e8 72 2e 00 00       	call   80104b40 <release>
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	eb 08                	jmp    80101cdb <namex+0x4b>
80101cd3:	90                   	nop
80101cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cd8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cdb:	0f b6 03             	movzbl (%ebx),%eax
80101cde:	3c 2f                	cmp    $0x2f,%al
80101ce0:	74 f6                	je     80101cd8 <namex+0x48>
  if(*path == 0)
80101ce2:	84 c0                	test   %al,%al
80101ce4:	0f 84 ee 00 00 00    	je     80101dd8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cea:	0f b6 03             	movzbl (%ebx),%eax
80101ced:	3c 2f                	cmp    $0x2f,%al
80101cef:	0f 84 b3 00 00 00    	je     80101da8 <namex+0x118>
80101cf5:	84 c0                	test   %al,%al
80101cf7:	89 da                	mov    %ebx,%edx
80101cf9:	75 09                	jne    80101d04 <namex+0x74>
80101cfb:	e9 a8 00 00 00       	jmp    80101da8 <namex+0x118>
80101d00:	84 c0                	test   %al,%al
80101d02:	74 0a                	je     80101d0e <namex+0x7e>
    path++;
80101d04:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d07:	0f b6 02             	movzbl (%edx),%eax
80101d0a:	3c 2f                	cmp    $0x2f,%al
80101d0c:	75 f2                	jne    80101d00 <namex+0x70>
80101d0e:	89 d1                	mov    %edx,%ecx
80101d10:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d12:	83 f9 0d             	cmp    $0xd,%ecx
80101d15:	0f 8e 91 00 00 00    	jle    80101dac <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d1b:	83 ec 04             	sub    $0x4,%esp
80101d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d21:	6a 0e                	push   $0xe
80101d23:	53                   	push   %ebx
80101d24:	57                   	push   %edi
80101d25:	e8 16 2f 00 00       	call   80104c40 <memmove>
    path++;
80101d2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d2d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d30:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d32:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d35:	75 11                	jne    80101d48 <namex+0xb8>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	83 ec 0c             	sub    $0xc,%esp
80101d4b:	56                   	push   %esi
80101d4c:	e8 5f f9 ff ff       	call   801016b0 <ilock>
    if(ip->type != T_DIR){
80101d51:	83 c4 10             	add    $0x10,%esp
80101d54:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d59:	0f 85 91 00 00 00    	jne    80101df0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d62:	85 d2                	test   %edx,%edx
80101d64:	74 09                	je     80101d6f <namex+0xdf>
80101d66:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d69:	0f 84 b7 00 00 00    	je     80101e26 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6f:	83 ec 04             	sub    $0x4,%esp
80101d72:	6a 00                	push   $0x0
80101d74:	57                   	push   %edi
80101d75:	56                   	push   %esi
80101d76:	e8 65 fe ff ff       	call   80101be0 <dirlookup>
80101d7b:	83 c4 10             	add    $0x10,%esp
80101d7e:	85 c0                	test   %eax,%eax
80101d80:	74 6e                	je     80101df0 <namex+0x160>
  iunlock(ip);
80101d82:	83 ec 0c             	sub    $0xc,%esp
80101d85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d88:	56                   	push   %esi
80101d89:	e8 02 fa ff ff       	call   80101790 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	83 c4 10             	add    $0x10,%esp
80101d9c:	89 c6                	mov    %eax,%esi
80101d9e:	e9 38 ff ff ff       	jmp    80101cdb <namex+0x4b>
80101da3:	90                   	nop
80101da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101da8:	89 da                	mov    %ebx,%edx
80101daa:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dac:	83 ec 04             	sub    $0x4,%esp
80101daf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db5:	51                   	push   %ecx
80101db6:	53                   	push   %ebx
80101db7:	57                   	push   %edi
80101db8:	e8 83 2e 00 00       	call   80104c40 <memmove>
    name[len] = 0;
80101dbd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc3:	83 c4 10             	add    $0x10,%esp
80101dc6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dca:	89 d3                	mov    %edx,%ebx
80101dcc:	e9 61 ff ff ff       	jmp    80101d32 <namex+0xa2>
80101dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ddb:	85 c0                	test   %eax,%eax
80101ddd:	75 5d                	jne    80101e3c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ddf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de2:	89 f0                	mov    %esi,%eax
80101de4:	5b                   	pop    %ebx
80101de5:	5e                   	pop    %esi
80101de6:	5f                   	pop    %edi
80101de7:	5d                   	pop    %ebp
80101de8:	c3                   	ret    
80101de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 97 f9 ff ff       	call   80101790 <iunlock>
  iput(ip);
80101df9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101dfc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dfe:	e8 dd f9 ff ff       	call   801017e0 <iput>
      return 0;
80101e03:	83 c4 10             	add    $0x10,%esp
}
80101e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e09:	89 f0                	mov    %esi,%eax
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
80101e0f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e10:	ba 01 00 00 00       	mov    $0x1,%edx
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 a1 f4 ff ff       	call   801012c0 <iget>
80101e1f:	89 c6                	mov    %eax,%esi
80101e21:	e9 b5 fe ff ff       	jmp    80101cdb <namex+0x4b>
      iunlock(ip);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	56                   	push   %esi
80101e2a:	e8 61 f9 ff ff       	call   80101790 <iunlock>
      return ip;
80101e2f:	83 c4 10             	add    $0x10,%esp
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e35:	89 f0                	mov    %esi,%eax
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
    iput(ip);
80101e3c:	83 ec 0c             	sub    $0xc,%esp
80101e3f:	56                   	push   %esi
    return 0;
80101e40:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e42:	e8 99 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	eb 93                	jmp    80101ddf <namex+0x14f>
80101e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 20             	sub    $0x20,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	6a 00                	push   $0x0
80101e5e:	ff 75 0c             	pushl  0xc(%ebp)
80101e61:	53                   	push   %ebx
80101e62:	e8 79 fd ff ff       	call   80101be0 <dirlookup>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	75 67                	jne    80101ed5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e6e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e71:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e74:	85 ff                	test   %edi,%edi
80101e76:	74 29                	je     80101ea1 <dirlink+0x51>
80101e78:	31 ff                	xor    %edi,%edi
80101e7a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e7d:	eb 09                	jmp    80101e88 <dirlink+0x38>
80101e7f:	90                   	nop
80101e80:	83 c7 10             	add    $0x10,%edi
80101e83:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e86:	73 19                	jae    80101ea1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e88:	6a 10                	push   $0x10
80101e8a:	57                   	push   %edi
80101e8b:	56                   	push   %esi
80101e8c:	53                   	push   %ebx
80101e8d:	e8 fe fa ff ff       	call   80101990 <readi>
80101e92:	83 c4 10             	add    $0x10,%esp
80101e95:	83 f8 10             	cmp    $0x10,%eax
80101e98:	75 4e                	jne    80101ee8 <dirlink+0x98>
    if(de.inum == 0)
80101e9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9f:	75 df                	jne    80101e80 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ea1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ea4:	83 ec 04             	sub    $0x4,%esp
80101ea7:	6a 0e                	push   $0xe
80101ea9:	ff 75 0c             	pushl  0xc(%ebp)
80101eac:	50                   	push   %eax
80101ead:	e8 5e 2e 00 00       	call   80104d10 <strncpy>
  de.inum = inum;
80101eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb5:	6a 10                	push   $0x10
80101eb7:	57                   	push   %edi
80101eb8:	56                   	push   %esi
80101eb9:	53                   	push   %ebx
  de.inum = inum;
80101eba:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebe:	e8 cd fb ff ff       	call   80101a90 <writei>
80101ec3:	83 c4 20             	add    $0x20,%esp
80101ec6:	83 f8 10             	cmp    $0x10,%eax
80101ec9:	75 2a                	jne    80101ef5 <dirlink+0xa5>
  return 0;
80101ecb:	31 c0                	xor    %eax,%eax
}
80101ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
    iput(ip);
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	50                   	push   %eax
80101ed9:	e8 02 f9 ff ff       	call   801017e0 <iput>
    return -1;
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ee6:	eb e5                	jmp    80101ecd <dirlink+0x7d>
      panic("dirlink read");
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 48 78 10 80       	push   $0x80107848
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 ea 7e 10 80       	push   $0x80107eea
80101efd:	e8 8e e4 ff ff       	call   80100390 <panic>
80101f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f59:	85 c0                	test   %eax,%eax
80101f5b:	0f 84 b4 00 00 00    	je     80102015 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f61:	8b 58 08             	mov    0x8(%eax),%ebx
80101f64:	89 c6                	mov    %eax,%esi
80101f66:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f6c:	0f 87 96 00 00 00    	ja     80102008 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f72:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101f77:	89 f6                	mov    %esi,%esi
80101f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101f80:	89 ca                	mov    %ecx,%edx
80101f82:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f83:	83 e0 c0             	and    $0xffffffc0,%eax
80101f86:	3c 40                	cmp    $0x40,%al
80101f88:	75 f6                	jne    80101f80 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f91:	89 f8                	mov    %edi,%eax
80101f93:	ee                   	out    %al,(%dx)
80101f94:	b8 01 00 00 00       	mov    $0x1,%eax
80101f99:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f9e:	ee                   	out    %al,(%dx)
80101f9f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fa4:	89 d8                	mov    %ebx,%eax
80101fa6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fae:	c1 f8 08             	sar    $0x8,%eax
80101fb1:	ee                   	out    %al,(%dx)
80101fb2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fb7:	89 f8                	mov    %edi,%eax
80101fb9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fbe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fc3:	c1 e0 04             	shl    $0x4,%eax
80101fc6:	83 e0 10             	and    $0x10,%eax
80101fc9:	83 c8 e0             	or     $0xffffffe0,%eax
80101fcc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fcd:	f6 06 04             	testb  $0x4,(%esi)
80101fd0:	75 16                	jne    80101fe8 <idestart+0x98>
80101fd2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fd7:	89 ca                	mov    %ecx,%edx
80101fd9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fdd:	5b                   	pop    %ebx
80101fde:	5e                   	pop    %esi
80101fdf:	5f                   	pop    %edi
80101fe0:	5d                   	pop    %ebp
80101fe1:	c3                   	ret    
80101fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fe8:	b8 30 00 00 00       	mov    $0x30,%eax
80101fed:	89 ca                	mov    %ecx,%edx
80101fef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ff5:	83 c6 5c             	add    $0x5c,%esi
80101ff8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ffd:	fc                   	cld    
80101ffe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102000:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
    panic("incorrect blockno");
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	68 b4 78 10 80       	push   $0x801078b4
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 ab 78 10 80       	push   $0x801078ab
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 c6 78 10 80       	push   $0x801078c6
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 fb 28 00 00       	call   80104940 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102045:	58                   	pop    %eax
80102046:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010204b:	5a                   	pop    %edx
8010204c:	83 e8 01             	sub    $0x1,%eax
8010204f:	50                   	push   %eax
80102050:	6a 0e                	push   $0xe
80102052:	e8 b9 02 00 00       	call   80102310 <ioapicenable>
80102057:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010205a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205f:	90                   	nop
80102060:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102061:	83 e0 c0             	and    $0xffffffc0,%eax
80102064:	3c 40                	cmp    $0x40,%al
80102066:	75 f8                	jne    80102060 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102068:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010206d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102072:	ee                   	out    %al,(%dx)
80102073:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102078:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010207d:	eb 06                	jmp    80102085 <ideinit+0x55>
8010207f:	90                   	nop
  for(i=0; i<1000; i++){
80102080:	83 e9 01             	sub    $0x1,%ecx
80102083:	74 0f                	je     80102094 <ideinit+0x64>
80102085:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102086:	84 c0                	test   %al,%al
80102088:	74 f6                	je     80102080 <ideinit+0x50>
      havedisk1 = 1;
8010208a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102091:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102094:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102099:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010209e:	ee                   	out    %al,(%dx)
}
8010209f:	c9                   	leave  
801020a0:	c3                   	ret    
801020a1:	eb 0d                	jmp    801020b0 <ideintr>
801020a3:	90                   	nop
801020a4:	90                   	nop
801020a5:	90                   	nop
801020a6:	90                   	nop
801020a7:	90                   	nop
801020a8:	90                   	nop
801020a9:	90                   	nop
801020aa:	90                   	nop
801020ab:	90                   	nop
801020ac:	90                   	nop
801020ad:	90                   	nop
801020ae:	90                   	nop
801020af:	90                   	nop

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	68 80 b5 10 80       	push   $0x8010b580
801020be:	e8 bd 29 00 00       	call   80104a80 <acquire>

  if((b = idequeue) == 0){
801020c3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020c9:	83 c4 10             	add    $0x10,%esp
801020cc:	85 db                	test   %ebx,%ebx
801020ce:	74 67                	je     80102137 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020d0:	8b 43 58             	mov    0x58(%ebx),%eax
801020d3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d8:	8b 3b                	mov    (%ebx),%edi
801020da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801020e0:	75 31                	jne    80102113 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020e7:	89 f6                	mov    %esi,%esi
801020e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801020f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	89 c6                	mov    %eax,%esi
801020f3:	83 e6 c0             	and    $0xffffffc0,%esi
801020f6:	89 f1                	mov    %esi,%ecx
801020f8:	80 f9 40             	cmp    $0x40,%cl
801020fb:	75 f3                	jne    801020f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020fd:	a8 21                	test   $0x21,%al
801020ff:	75 12                	jne    80102113 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102101:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102104:	b9 80 00 00 00       	mov    $0x80,%ecx
80102109:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010210e:	fc                   	cld    
8010210f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102111:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102113:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102116:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102119:	89 f9                	mov    %edi,%ecx
8010211b:	83 c9 02             	or     $0x2,%ecx
8010211e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102120:	53                   	push   %ebx
80102121:	e8 2a 21 00 00       	call   80104250 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102126:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010212b:	83 c4 10             	add    $0x10,%esp
8010212e:	85 c0                	test   %eax,%eax
80102130:	74 05                	je     80102137 <ideintr+0x87>
    idestart(idequeue);
80102132:	e8 19 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
80102137:	83 ec 0c             	sub    $0xc,%esp
8010213a:	68 80 b5 10 80       	push   $0x8010b580
8010213f:	e8 fc 29 00 00       	call   80104b40 <release>

  release(&idelock);
}
80102144:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102147:	5b                   	pop    %ebx
80102148:	5e                   	pop    %esi
80102149:	5f                   	pop    %edi
8010214a:	5d                   	pop    %ebp
8010214b:	c3                   	ret    
8010214c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 10             	sub    $0x10,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	50                   	push   %eax
8010215e:	e8 8d 27 00 00       	call   801048f0 <holdingsleep>
80102163:	83 c4 10             	add    $0x10,%esp
80102166:	85 c0                	test   %eax,%eax
80102168:	0f 84 c6 00 00 00    	je     80102234 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	0f 84 ab 00 00 00    	je     80102227 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217c:	8b 53 04             	mov    0x4(%ebx),%edx
8010217f:	85 d2                	test   %edx,%edx
80102181:	74 0d                	je     80102190 <iderw+0x40>
80102183:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102188:	85 c0                	test   %eax,%eax
8010218a:	0f 84 b1 00 00 00    	je     80102241 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102190:	83 ec 0c             	sub    $0xc,%esp
80102193:	68 80 b5 10 80       	push   $0x8010b580
80102198:	e8 e3 28 00 00       	call   80104a80 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801021a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ad:	85 d2                	test   %edx,%edx
801021af:	75 09                	jne    801021ba <iderw+0x6a>
801021b1:	eb 6d                	jmp    80102220 <iderw+0xd0>
801021b3:	90                   	nop
801021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021b8:	89 c2                	mov    %eax,%edx
801021ba:	8b 42 58             	mov    0x58(%edx),%eax
801021bd:	85 c0                	test   %eax,%eax
801021bf:	75 f7                	jne    801021b8 <iderw+0x68>
801021c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021c6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801021cc:	74 42                	je     80102210 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ce:	8b 03                	mov    (%ebx),%eax
801021d0:	83 e0 06             	and    $0x6,%eax
801021d3:	83 f8 02             	cmp    $0x2,%eax
801021d6:	74 23                	je     801021fb <iderw+0xab>
801021d8:	90                   	nop
801021d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801021e0:	83 ec 08             	sub    $0x8,%esp
801021e3:	68 80 b5 10 80       	push   $0x8010b580
801021e8:	53                   	push   %ebx
801021e9:	e8 a2 1f 00 00       	call   80104190 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 c4 10             	add    $0x10,%esp
801021f3:	83 e0 06             	and    $0x6,%eax
801021f6:	83 f8 02             	cmp    $0x2,%eax
801021f9:	75 e5                	jne    801021e0 <iderw+0x90>
  }


  release(&idelock);
801021fb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102202:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102205:	c9                   	leave  
  release(&idelock);
80102206:	e9 35 29 00 00       	jmp    80104b40 <release>
8010220b:	90                   	nop
8010220c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102210:	89 d8                	mov    %ebx,%eax
80102212:	e8 39 fd ff ff       	call   80101f50 <idestart>
80102217:	eb b5                	jmp    801021ce <iderw+0x7e>
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102220:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102225:	eb 9d                	jmp    801021c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102227:	83 ec 0c             	sub    $0xc,%esp
8010222a:	68 e0 78 10 80       	push   $0x801078e0
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 ca 78 10 80       	push   $0x801078ca
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 f5 78 10 80       	push   $0x801078f5
80102249:	e8 42 e1 ff ff       	call   80100390 <panic>

8010224e <sigret_start>:

.globl sigret_start
.globl sigret_end

sigret_start: 
  movl $SYS_sigret, %eax; 
8010224e:	b8 18 00 00 00       	mov    $0x18,%eax
  int $T_SYSCALL; 
80102253:	cd 40                	int    $0x40

80102255 <sigret_end>:
80102255:	66 90                	xchg   %ax,%ax
80102257:	66 90                	xchg   %ax,%ax
80102259:	66 90                	xchg   %ax,%ax
8010225b:	66 90                	xchg   %ax,%ax
8010225d:	66 90                	xchg   %ax,%ax
8010225f:	90                   	nop

80102260 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102260:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102261:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102268:	00 c0 fe 
{
8010226b:	89 e5                	mov    %esp,%ebp
8010226d:	56                   	push   %esi
8010226e:	53                   	push   %ebx
  ioapic->reg = reg;
8010226f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102276:	00 00 00 
  return ioapic->data;
80102279:	a1 34 36 11 80       	mov    0x80113634,%eax
8010227e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102281:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102287:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010228d:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102294:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102297:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010229a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010229d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022a0:	39 c2                	cmp    %eax,%edx
801022a2:	74 16                	je     801022ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022a4:	83 ec 0c             	sub    $0xc,%esp
801022a7:	68 14 79 10 80       	push   $0x80107914
801022ac:	e8 af e3 ff ff       	call   80100660 <cprintf>
801022b1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	83 c3 21             	add    $0x21,%ebx
{
801022bd:	ba 10 00 00 00       	mov    $0x10,%edx
801022c2:	b8 20 00 00 00       	mov    $0x20,%eax
801022c7:	89 f6                	mov    %esi,%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022d2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022d8:	89 c6                	mov    %eax,%esi
801022da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801022e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022e3:	89 71 10             	mov    %esi,0x10(%ecx)
801022e6:	8d 72 01             	lea    0x1(%edx),%esi
801022e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801022ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801022ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801022f0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801022f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022fd:	75 d1                	jne    801022d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102302:	5b                   	pop    %ebx
80102303:	5e                   	pop    %esi
80102304:	5d                   	pop    %ebp
80102305:	c3                   	ret    
80102306:	8d 76 00             	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102310:	55                   	push   %ebp
  ioapic->reg = reg;
80102311:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102317:	89 e5                	mov    %esp,%ebp
80102319:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010231c:	8d 50 20             	lea    0x20(%eax),%edx
8010231f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102323:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102325:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010232b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010232e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102331:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102334:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102336:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010233b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010233e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102341:	5d                   	pop    %ebp
80102342:	c3                   	ret    
80102343:	66 90                	xchg   %ax,%ax
80102345:	66 90                	xchg   %ax,%ax
80102347:	66 90                	xchg   %ax,%ax
80102349:	66 90                	xchg   %ax,%ax
8010234b:	66 90                	xchg   %ax,%ax
8010234d:	66 90                	xchg   %ax,%ax
8010234f:	90                   	nop

80102350 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 04             	sub    $0x4,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010235a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102360:	75 70                	jne    801023d2 <kfree+0x82>
80102362:	81 fb a8 a9 11 80    	cmp    $0x8011a9a8,%ebx
80102368:	72 68                	jb     801023d2 <kfree+0x82>
8010236a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102370:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102375:	77 5b                	ja     801023d2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	68 00 10 00 00       	push   $0x1000
8010237f:	6a 01                	push   $0x1
80102381:	53                   	push   %ebx
80102382:	e8 09 28 00 00       	call   80104b90 <memset>

  if(kmem.use_lock)
80102387:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 d2                	test   %edx,%edx
80102392:	75 2c                	jne    801023c0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102394:	a1 78 36 11 80       	mov    0x80113678,%eax
80102399:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010239b:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801023a0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801023a6:	85 c0                	test   %eax,%eax
801023a8:	75 06                	jne    801023b0 <kfree+0x60>
    release(&kmem.lock);
}
801023aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ad:	c9                   	leave  
801023ae:	c3                   	ret    
801023af:	90                   	nop
    release(&kmem.lock);
801023b0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ba:	c9                   	leave  
    release(&kmem.lock);
801023bb:	e9 80 27 00 00       	jmp    80104b40 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 40 36 11 80       	push   $0x80113640
801023c8:	e8 b3 26 00 00       	call   80104a80 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 46 79 10 80       	push   $0x80107946
801023da:	e8 b1 df ff ff       	call   80100390 <panic>
801023df:	90                   	nop

801023e0 <freerange>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	56                   	push   %esi
801023e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801023e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fd:	39 de                	cmp    %ebx,%esi
801023ff:	72 23                	jb     80102424 <freerange+0x44>
80102401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102408:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010240e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102417:	50                   	push   %eax
80102418:	e8 33 ff ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	39 f3                	cmp    %esi,%ebx
80102422:	76 e4                	jbe    80102408 <freerange+0x28>
}
80102424:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102427:	5b                   	pop    %ebx
80102428:	5e                   	pop    %esi
80102429:	5d                   	pop    %ebp
8010242a:	c3                   	ret    
8010242b:	90                   	nop
8010242c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102430 <kinit1>:
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
80102435:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102438:	83 ec 08             	sub    $0x8,%esp
8010243b:	68 4c 79 10 80       	push   $0x8010794c
80102440:	68 40 36 11 80       	push   $0x80113640
80102445:	e8 f6 24 00 00       	call   80104940 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010244a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102450:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102457:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010245a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102460:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102466:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246c:	39 de                	cmp    %ebx,%esi
8010246e:	72 1c                	jb     8010248c <kinit1+0x5c>
    kfree(p);
80102470:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102476:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102479:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010247f:	50                   	push   %eax
80102480:	e8 cb fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102485:	83 c4 10             	add    $0x10,%esp
80102488:	39 de                	cmp    %ebx,%esi
8010248a:	73 e4                	jae    80102470 <kinit1+0x40>
}
8010248c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010248f:	5b                   	pop    %ebx
80102490:	5e                   	pop    %esi
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <kinit2>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024bd:	39 de                	cmp    %ebx,%esi
801024bf:	72 23                	jb     801024e4 <kinit2+0x44>
801024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024d7:	50                   	push   %eax
801024d8:	e8 73 fe ff ff       	call   80102350 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024dd:	83 c4 10             	add    $0x10,%esp
801024e0:	39 de                	cmp    %ebx,%esi
801024e2:	73 e4                	jae    801024c8 <kinit2+0x28>
  kmem.use_lock = 1;
801024e4:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801024eb:	00 00 00 
}
801024ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024f1:	5b                   	pop    %ebx
801024f2:	5e                   	pop    %esi
801024f3:	5d                   	pop    %ebp
801024f4:	c3                   	ret    
801024f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102500:	a1 74 36 11 80       	mov    0x80113674,%eax
80102505:	85 c0                	test   %eax,%eax
80102507:	75 1f                	jne    80102528 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102509:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010250e:	85 c0                	test   %eax,%eax
80102510:	74 0e                	je     80102520 <kalloc+0x20>
    kmem.freelist = r->next;
80102512:	8b 10                	mov    (%eax),%edx
80102514:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010251a:	c3                   	ret    
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102520:	f3 c3                	repz ret 
80102522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102528:	55                   	push   %ebp
80102529:	89 e5                	mov    %esp,%ebp
8010252b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010252e:	68 40 36 11 80       	push   $0x80113640
80102533:	e8 48 25 00 00       	call   80104a80 <acquire>
  r = kmem.freelist;
80102538:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102546:	85 c0                	test   %eax,%eax
80102548:	74 08                	je     80102552 <kalloc+0x52>
    kmem.freelist = r->next;
8010254a:	8b 08                	mov    (%eax),%ecx
8010254c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102552:	85 d2                	test   %edx,%edx
80102554:	74 16                	je     8010256c <kalloc+0x6c>
    release(&kmem.lock);
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010255c:	68 40 36 11 80       	push   $0x80113640
80102561:	e8 da 25 00 00       	call   80104b40 <release>
  return (char*)r;
80102566:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102569:	83 c4 10             	add    $0x10,%esp
}
8010256c:	c9                   	leave  
8010256d:	c3                   	ret    
8010256e:	66 90                	xchg   %ax,%ax

80102570 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102570:	ba 64 00 00 00       	mov    $0x64,%edx
80102575:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102576:	a8 01                	test   $0x1,%al
80102578:	0f 84 c2 00 00 00    	je     80102640 <kbdgetc+0xd0>
8010257e:	ba 60 00 00 00       	mov    $0x60,%edx
80102583:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102584:	0f b6 d0             	movzbl %al,%edx
80102587:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
8010258d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102593:	0f 84 7f 00 00 00    	je     80102618 <kbdgetc+0xa8>
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	53                   	push   %ebx
8010259d:	89 cb                	mov    %ecx,%ebx
8010259f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025a2:	84 c0                	test   %al,%al
801025a4:	78 4a                	js     801025f0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025a6:	85 db                	test   %ebx,%ebx
801025a8:	74 09                	je     801025b3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025aa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025ad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025b0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025b3:	0f b6 82 80 7a 10 80 	movzbl -0x7fef8580(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 80 79 10 80 	movzbl -0x7fef8680(%edx),%eax
801025c3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025c5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025c7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025cd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025d0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025d3:	8b 04 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%eax
801025da:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025de:	74 31                	je     80102611 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801025e0:	8d 50 9f             	lea    -0x61(%eax),%edx
801025e3:	83 fa 19             	cmp    $0x19,%edx
801025e6:	77 40                	ja     80102628 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025e8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025eb:	5b                   	pop    %ebx
801025ec:	5d                   	pop    %ebp
801025ed:	c3                   	ret    
801025ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801025f0:	83 e0 7f             	and    $0x7f,%eax
801025f3:	85 db                	test   %ebx,%ebx
801025f5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801025f8:	0f b6 82 80 7a 10 80 	movzbl -0x7fef8580(%edx),%eax
801025ff:	83 c8 40             	or     $0x40,%eax
80102602:	0f b6 c0             	movzbl %al,%eax
80102605:	f7 d0                	not    %eax
80102607:	21 c1                	and    %eax,%ecx
    return 0;
80102609:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010260b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102611:	5b                   	pop    %ebx
80102612:	5d                   	pop    %ebp
80102613:	c3                   	ret    
80102614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102618:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010261b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010261d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102623:	c3                   	ret    
80102624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102628:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010262b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010262e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010262f:	83 f9 1a             	cmp    $0x1a,%ecx
80102632:	0f 42 c2             	cmovb  %edx,%eax
}
80102635:	5d                   	pop    %ebp
80102636:	c3                   	ret    
80102637:	89 f6                	mov    %esi,%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102645:	c3                   	ret    
80102646:	8d 76 00             	lea    0x0(%esi),%esi
80102649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102650 <kbdintr>:

void
kbdintr(void)
{
80102650:	55                   	push   %ebp
80102651:	89 e5                	mov    %esp,%ebp
80102653:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102656:	68 70 25 10 80       	push   $0x80102570
8010265b:	e8 b0 e1 ff ff       	call   80100810 <consoleintr>
}
80102660:	83 c4 10             	add    $0x10,%esp
80102663:	c9                   	leave  
80102664:	c3                   	ret    
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102670:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102675:	55                   	push   %ebp
80102676:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102678:	85 c0                	test   %eax,%eax
8010267a:	0f 84 c8 00 00 00    	je     80102748 <lapicinit+0xd8>
  lapic[index] = value;
80102680:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102687:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010268d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026a1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026a7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026b1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026bb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026c8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ce:	8b 50 30             	mov    0x30(%eax),%edx
801026d1:	c1 ea 10             	shr    $0x10,%edx
801026d4:	80 fa 03             	cmp    $0x3,%dl
801026d7:	77 77                	ja     80102750 <lapicinit+0xe0>
  lapic[index] = value;
801026d9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026e0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026ed:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102700:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102707:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102714:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102717:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102721:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102724:	8b 50 20             	mov    0x20(%eax),%edx
80102727:	89 f6                	mov    %esi,%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102730:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102736:	80 e6 10             	and    $0x10,%dh
80102739:	75 f5                	jne    80102730 <lapicinit+0xc0>
  lapic[index] = value;
8010273b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102742:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102745:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102748:	5d                   	pop    %ebp
80102749:	c3                   	ret    
8010274a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102750:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102757:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx
8010275d:	e9 77 ff ff ff       	jmp    801026d9 <lapicinit+0x69>
80102762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102770:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102776:	55                   	push   %ebp
80102777:	31 c0                	xor    %eax,%eax
80102779:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010277b:	85 d2                	test   %edx,%edx
8010277d:	74 06                	je     80102785 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010277f:	8b 42 20             	mov    0x20(%edx),%eax
80102782:	c1 e8 18             	shr    $0x18,%eax
}
80102785:	5d                   	pop    %ebp
80102786:	c3                   	ret    
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027c6:	ba 70 00 00 00       	mov    $0x70,%edx
801027cb:	89 e5                	mov    %esp,%ebp
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	ba 71 00 00 00       	mov    $0x71,%edx
801027df:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027e0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027e2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801027e5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027eb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027ed:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
801027f0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
801027f3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801027f8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027fe:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102803:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102809:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010280c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102813:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102819:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102820:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102823:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102826:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010282c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010282f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102838:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102847:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010284a:	5b                   	pop    %ebx
8010284b:	5d                   	pop    %ebp
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	b8 0b 00 00 00       	mov    $0xb,%eax
80102856:	ba 70 00 00 00       	mov    $0x70,%edx
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	ba 71 00 00 00       	mov    $0x71,%edx
80102869:	ec                   	in     (%dx),%al
8010286a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010286d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102872:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102875:	8d 76 00             	lea    0x0(%esi),%esi
80102878:	31 c0                	xor    %eax,%eax
8010287a:	89 da                	mov    %ebx,%edx
8010287c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102882:	89 ca                	mov    %ecx,%edx
80102884:	ec                   	in     (%dx),%al
80102885:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102888:	89 da                	mov    %ebx,%edx
8010288a:	b8 02 00 00 00       	mov    $0x2,%eax
8010288f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
80102893:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102896:	89 da                	mov    %ebx,%edx
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
801028a1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 da                	mov    %ebx,%edx
801028a6:	b8 07 00 00 00       	mov    $0x7,%eax
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	89 ca                	mov    %ecx,%edx
801028ae:	ec                   	in     (%dx),%al
801028af:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b2:	89 da                	mov    %ebx,%edx
801028b4:	b8 08 00 00 00       	mov    $0x8,%eax
801028b9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ba:	89 ca                	mov    %ecx,%edx
801028bc:	ec                   	in     (%dx),%al
801028bd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028bf:	89 da                	mov    %ebx,%edx
801028c1:	b8 09 00 00 00       	mov    $0x9,%eax
801028c6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c7:	89 ca                	mov    %ecx,%edx
801028c9:	ec                   	in     (%dx),%al
801028ca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028cc:	89 da                	mov    %ebx,%edx
801028ce:	b8 0a 00 00 00       	mov    $0xa,%eax
801028d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	89 ca                	mov    %ecx,%edx
801028d6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d7:	84 c0                	test   %al,%al
801028d9:	78 9d                	js     80102878 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028db:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028df:	89 fa                	mov    %edi,%edx
801028e1:	0f b6 fa             	movzbl %dl,%edi
801028e4:	89 f2                	mov    %esi,%edx
801028e6:	0f b6 f2             	movzbl %dl,%esi
801028e9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	89 75 cc             	mov    %esi,-0x34(%ebp)
801028f1:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028f4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801028f8:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028fb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801028ff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102902:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102906:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102909:	31 c0                	xor    %eax,%eax
8010290b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290c:	89 ca                	mov    %ecx,%edx
8010290e:	ec                   	in     (%dx),%al
8010290f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102912:	89 da                	mov    %ebx,%edx
80102914:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102917:	b8 02 00 00 00       	mov    $0x2,%eax
8010291c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291d:	89 ca                	mov    %ecx,%edx
8010291f:	ec                   	in     (%dx),%al
80102920:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102923:	89 da                	mov    %ebx,%edx
80102925:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102928:	b8 04 00 00 00       	mov    $0x4,%eax
8010292d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292e:	89 ca                	mov    %ecx,%edx
80102930:	ec                   	in     (%dx),%al
80102931:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102934:	89 da                	mov    %ebx,%edx
80102936:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102939:	b8 07 00 00 00       	mov    $0x7,%eax
8010293e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293f:	89 ca                	mov    %ecx,%edx
80102941:	ec                   	in     (%dx),%al
80102942:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	89 da                	mov    %ebx,%edx
80102947:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010294a:	b8 08 00 00 00       	mov    $0x8,%eax
8010294f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102950:	89 ca                	mov    %ecx,%edx
80102952:	ec                   	in     (%dx),%al
80102953:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102956:	89 da                	mov    %ebx,%edx
80102958:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010295b:	b8 09 00 00 00       	mov    $0x9,%eax
80102960:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	89 ca                	mov    %ecx,%edx
80102963:	ec                   	in     (%dx),%al
80102964:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102967:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010296a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010296d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102970:	6a 18                	push   $0x18
80102972:	50                   	push   %eax
80102973:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102976:	50                   	push   %eax
80102977:	e8 64 22 00 00       	call   80104be0 <memcmp>
8010297c:	83 c4 10             	add    $0x10,%esp
8010297f:	85 c0                	test   %eax,%eax
80102981:	0f 85 f1 fe ff ff    	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102987:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010298b:	75 78                	jne    80102a05 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010298d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102990:	89 c2                	mov    %eax,%edx
80102992:	83 e0 0f             	and    $0xf,%eax
80102995:	c1 ea 04             	shr    $0x4,%edx
80102998:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010299b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010299e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029a1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029a4:	89 c2                	mov    %eax,%edx
801029a6:	83 e0 0f             	and    $0xf,%eax
801029a9:	c1 ea 04             	shr    $0x4,%edx
801029ac:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029af:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029b2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029b8:	89 c2                	mov    %eax,%edx
801029ba:	83 e0 0f             	and    $0xf,%eax
801029bd:	c1 ea 04             	shr    $0x4,%edx
801029c0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029c3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029c9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029cc:	89 c2                	mov    %eax,%edx
801029ce:	83 e0 0f             	and    $0xf,%eax
801029d1:	c1 ea 04             	shr    $0x4,%edx
801029d4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029da:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029e0:	89 c2                	mov    %eax,%edx
801029e2:	83 e0 0f             	and    $0xf,%eax
801029e5:	c1 ea 04             	shr    $0x4,%edx
801029e8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029eb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f4:	89 c2                	mov    %eax,%edx
801029f6:	83 e0 0f             	and    $0xf,%eax
801029f9:	c1 ea 04             	shr    $0x4,%edx
801029fc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a02:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a05:	8b 75 08             	mov    0x8(%ebp),%esi
80102a08:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a0b:	89 06                	mov    %eax,(%esi)
80102a0d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a10:	89 46 04             	mov    %eax,0x4(%esi)
80102a13:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a16:	89 46 08             	mov    %eax,0x8(%esi)
80102a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a1c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a22:	89 46 10             	mov    %eax,0x10(%esi)
80102a25:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a28:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a2b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a35:	5b                   	pop    %ebx
80102a36:	5e                   	pop    %esi
80102a37:	5f                   	pop    %edi
80102a38:	5d                   	pop    %ebp
80102a39:	c3                   	ret    
80102a3a:	66 90                	xchg   %ax,%ax
80102a3c:	66 90                	xchg   %ax,%ax
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a40:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102a46:	85 c9                	test   %ecx,%ecx
80102a48:	0f 8e 8a 00 00 00    	jle    80102ad8 <install_trans+0x98>
{
80102a4e:	55                   	push   %ebp
80102a4f:	89 e5                	mov    %esp,%ebp
80102a51:	57                   	push   %edi
80102a52:	56                   	push   %esi
80102a53:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a54:	31 db                	xor    %ebx,%ebx
{
80102a56:	83 ec 0c             	sub    $0xc,%esp
80102a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a60:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a65:	83 ec 08             	sub    $0x8,%esp
80102a68:	01 d8                	add    %ebx,%eax
80102a6a:	83 c0 01             	add    $0x1,%eax
80102a6d:	50                   	push   %eax
80102a6e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a74:	e8 57 d6 ff ff       	call   801000d0 <bread>
80102a79:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a7b:	58                   	pop    %eax
80102a7c:	5a                   	pop    %edx
80102a7d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102a84:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102a8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a8d:	e8 3e d6 ff ff       	call   801000d0 <bread>
80102a92:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a94:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a97:	83 c4 0c             	add    $0xc,%esp
80102a9a:	68 00 02 00 00       	push   $0x200
80102a9f:	50                   	push   %eax
80102aa0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102aa3:	50                   	push   %eax
80102aa4:	e8 97 21 00 00       	call   80104c40 <memmove>
    bwrite(dbuf);  // write dst to disk
80102aa9:	89 34 24             	mov    %esi,(%esp)
80102aac:	e8 ef d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ab1:	89 3c 24             	mov    %edi,(%esp)
80102ab4:	e8 27 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ab9:	89 34 24             	mov    %esi,(%esp)
80102abc:	e8 1f d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac1:	83 c4 10             	add    $0x10,%esp
80102ac4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102aca:	7f 94                	jg     80102a60 <install_trans+0x20>
  }
}
80102acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102acf:	5b                   	pop    %ebx
80102ad0:	5e                   	pop    %esi
80102ad1:	5f                   	pop    %edi
80102ad2:	5d                   	pop    %ebp
80102ad3:	c3                   	ret    
80102ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ad8:	f3 c3                	repz ret 
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	56                   	push   %esi
80102ae4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ae5:	83 ec 08             	sub    $0x8,%esp
80102ae8:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102aee:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102af4:	e8 d7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102af9:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102aff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b02:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b04:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b06:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b09:	7e 16                	jle    80102b21 <write_head+0x41>
80102b0b:	c1 e3 02             	shl    $0x2,%ebx
80102b0e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b10:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102b16:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b1a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <write_head+0x30>
  }
  bwrite(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	56                   	push   %esi
80102b25:	e8 76 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b2a:	89 34 24             	mov    %esi,(%esp)
80102b2d:	e8 ae d6 ff ff       	call   801001e0 <brelse>
}
80102b32:	83 c4 10             	add    $0x10,%esp
80102b35:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b38:	5b                   	pop    %ebx
80102b39:	5e                   	pop    %esi
80102b3a:	5d                   	pop    %ebp
80102b3b:	c3                   	ret    
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b40 <initlog>:
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 2c             	sub    $0x2c,%esp
80102b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b4a:	68 80 7b 10 80       	push   $0x80107b80
80102b4f:	68 80 36 11 80       	push   $0x80113680
80102b54:	e8 e7 1d 00 00       	call   80104940 <initlock>
  readsb(dev, &sb);
80102b59:	58                   	pop    %eax
80102b5a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b5d:	5a                   	pop    %edx
80102b5e:	50                   	push   %eax
80102b5f:	53                   	push   %ebx
80102b60:	e8 0b e9 ff ff       	call   80101470 <readsb>
  log.size = sb.nlog;
80102b65:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b6b:	59                   	pop    %ecx
  log.dev = dev;
80102b6c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b72:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b78:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 4b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102b85:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102b8d:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102b93:	7e 1c                	jle    80102bb1 <initlog+0x71>
80102b95:	c1 e3 02             	shl    $0x2,%ebx
80102b98:	31 d2                	xor    %edx,%edx
80102b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102ba0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ba4:	83 c2 04             	add    $0x4,%edx
80102ba7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bad:	39 d3                	cmp    %edx,%ebx
80102baf:	75 ef                	jne    80102ba0 <initlog+0x60>
  brelse(buf);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	50                   	push   %eax
80102bb5:	e8 26 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bba:	e8 81 fe ff ff       	call   80102a40 <install_trans>
  log.lh.n = 0;
80102bbf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102bc6:	00 00 00 
  write_head(); // clear the log
80102bc9:	e8 12 ff ff ff       	call   80102ae0 <write_head>
}
80102bce:	83 c4 10             	add    $0x10,%esp
80102bd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bd4:	c9                   	leave  
80102bd5:	c3                   	ret    
80102bd6:	8d 76 00             	lea    0x0(%esi),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102be6:	68 80 36 11 80       	push   $0x80113680
80102beb:	e8 90 1e 00 00       	call   80104a80 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 80 36 11 80       	push   $0x80113680
80102c00:	68 80 36 11 80       	push   $0x80113680
80102c05:	e8 86 15 00 00       	call   80104190 <sleep>
80102c0a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c0d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102c12:	85 c0                	test   %eax,%eax
80102c14:	75 e2                	jne    80102bf8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c16:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102c21:	83 c0 01             	add    $0x1,%eax
80102c24:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c27:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c2a:	83 fa 1e             	cmp    $0x1e,%edx
80102c2d:	7f c9                	jg     80102bf8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c2f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c32:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c37:	68 80 36 11 80       	push   $0x80113680
80102c3c:	e8 ff 1e 00 00       	call   80104b40 <release>
      break;
    }
  }
}
80102c41:	83 c4 10             	add    $0x10,%esp
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	57                   	push   %edi
80102c54:	56                   	push   %esi
80102c55:	53                   	push   %ebx
80102c56:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c59:	68 80 36 11 80       	push   $0x80113680
80102c5e:	e8 1d 1e 00 00       	call   80104a80 <acquire>
  log.outstanding -= 1;
80102c63:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c68:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c6e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c71:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c74:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c76:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102c7c:	0f 85 1a 01 00 00    	jne    80102d9c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102c82:	85 db                	test   %ebx,%ebx
80102c84:	0f 85 ee 00 00 00    	jne    80102d78 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c8a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102c8d:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102c94:	00 00 00 
  release(&log.lock);
80102c97:	68 80 36 11 80       	push   $0x80113680
80102c9c:	e8 9f 1e 00 00       	call   80104b40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ca1:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ca7:	83 c4 10             	add    $0x10,%esp
80102caa:	85 c9                	test   %ecx,%ecx
80102cac:	0f 8e 85 00 00 00    	jle    80102d37 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cb2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102cb7:	83 ec 08             	sub    $0x8,%esp
80102cba:	01 d8                	add    %ebx,%eax
80102cbc:	83 c0 01             	add    $0x1,%eax
80102cbf:	50                   	push   %eax
80102cc0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102cc6:	e8 05 d4 ff ff       	call   801000d0 <bread>
80102ccb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ccd:	58                   	pop    %eax
80102cce:	5a                   	pop    %edx
80102ccf:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cd6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cdc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cdf:	e8 ec d3 ff ff       	call   801000d0 <bread>
80102ce4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ce6:	8d 40 5c             	lea    0x5c(%eax),%eax
80102ce9:	83 c4 0c             	add    $0xc,%esp
80102cec:	68 00 02 00 00       	push   $0x200
80102cf1:	50                   	push   %eax
80102cf2:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cf5:	50                   	push   %eax
80102cf6:	e8 45 1f 00 00       	call   80104c40 <memmove>
    bwrite(to);  // write the log
80102cfb:	89 34 24             	mov    %esi,(%esp)
80102cfe:	e8 9d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d03:	89 3c 24             	mov    %edi,(%esp)
80102d06:	e8 d5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d0b:	89 34 24             	mov    %esi,(%esp)
80102d0e:	e8 cd d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d13:	83 c4 10             	add    $0x10,%esp
80102d16:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102d1c:	7c 94                	jl     80102cb2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d1e:	e8 bd fd ff ff       	call   80102ae0 <write_head>
    install_trans(); // Now install writes to home locations
80102d23:	e8 18 fd ff ff       	call   80102a40 <install_trans>
    log.lh.n = 0;
80102d28:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d2f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d32:	e8 a9 fd ff ff       	call   80102ae0 <write_head>
    acquire(&log.lock);
80102d37:	83 ec 0c             	sub    $0xc,%esp
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 3c 1d 00 00       	call   80104a80 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d4b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 f6 14 00 00       	call   80104250 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d61:	e8 da 1d 00 00       	call   80104b40 <release>
80102d66:	83 c4 10             	add    $0x10,%esp
}
80102d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6c:	5b                   	pop    %ebx
80102d6d:	5e                   	pop    %esi
80102d6e:	5f                   	pop    %edi
80102d6f:	5d                   	pop    %ebp
80102d70:	c3                   	ret    
80102d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d78:	83 ec 0c             	sub    $0xc,%esp
80102d7b:	68 80 36 11 80       	push   $0x80113680
80102d80:	e8 cb 14 00 00       	call   80104250 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d8c:	e8 af 1d 00 00       	call   80104b40 <release>
80102d91:	83 c4 10             	add    $0x10,%esp
}
80102d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d97:	5b                   	pop    %ebx
80102d98:	5e                   	pop    %esi
80102d99:	5f                   	pop    %edi
80102d9a:	5d                   	pop    %ebp
80102d9b:	c3                   	ret    
    panic("log.committing");
80102d9c:	83 ec 0c             	sub    $0xc,%esp
80102d9f:	68 84 7b 10 80       	push   $0x80107b84
80102da4:	e8 e7 d5 ff ff       	call   80100390 <panic>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102db0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102db7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dc0:	83 fa 1d             	cmp    $0x1d,%edx
80102dc3:	0f 8f 9d 00 00 00    	jg     80102e66 <log_write+0xb6>
80102dc9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dce:	83 e8 01             	sub    $0x1,%eax
80102dd1:	39 c2                	cmp    %eax,%edx
80102dd3:	0f 8d 8d 00 00 00    	jge    80102e66 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102dd9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dde:	85 c0                	test   %eax,%eax
80102de0:	0f 8e 8d 00 00 00    	jle    80102e73 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102de6:	83 ec 0c             	sub    $0xc,%esp
80102de9:	68 80 36 11 80       	push   $0x80113680
80102dee:	e8 8d 1c 00 00       	call   80104a80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102df3:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	83 f9 00             	cmp    $0x0,%ecx
80102dff:	7e 57                	jle    80102e58 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e01:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e04:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e06:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102e0c:	75 0b                	jne    80102e19 <log_write+0x69>
80102e0e:	eb 38                	jmp    80102e48 <log_write+0x98>
80102e10:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102e17:	74 2f                	je     80102e48 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e19:	83 c0 01             	add    $0x1,%eax
80102e1c:	39 c1                	cmp    %eax,%ecx
80102e1e:	75 f0                	jne    80102e10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e20:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e27:	83 c0 01             	add    $0x1,%eax
80102e2a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e2f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e32:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e3c:	c9                   	leave  
  release(&log.lock);
80102e3d:	e9 fe 1c 00 00       	jmp    80104b40 <release>
80102e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e48:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e4f:	eb de                	jmp    80102e2f <log_write+0x7f>
80102e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e58:	8b 43 08             	mov    0x8(%ebx),%eax
80102e5b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e60:	75 cd                	jne    80102e2f <log_write+0x7f>
80102e62:	31 c0                	xor    %eax,%eax
80102e64:	eb c1                	jmp    80102e27 <log_write+0x77>
    panic("too big a transaction");
80102e66:	83 ec 0c             	sub    $0xc,%esp
80102e69:	68 93 7b 10 80       	push   $0x80107b93
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 a9 7b 10 80       	push   $0x80107ba9
80102e7b:	e8 10 d5 ff ff       	call   80100390 <panic>

80102e80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	53                   	push   %ebx
80102e84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e87:	e8 54 09 00 00       	call   801037e0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 4d 09 00 00       	call   801037e0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 c4 7b 10 80       	push   $0x80107bc4
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 59 30 00 00       	call   80105f00 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 b4 08 00 00       	call   80103760 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 b1 0d 00 00       	call   80103c70 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 25 41 00 00       	call   80106ff0 <switchkvm>
  seginit();
80102ecb:	e8 90 40 00 00       	call   80106f60 <seginit>
  lapicinit();
80102ed0:	e8 9b f7 ff ff       	call   80102670 <lapicinit>
  mpmain();
80102ed5:	e8 a6 ff ff ff       	call   80102e80 <mpmain>
80102eda:	66 90                	xchg   %ax,%ax
80102edc:	66 90                	xchg   %ax,%ax
80102ede:	66 90                	xchg   %ax,%ax

80102ee0 <main>:
{
80102ee0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ee4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ee7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eea:	55                   	push   %ebp
80102eeb:	89 e5                	mov    %esp,%ebp
80102eed:	53                   	push   %ebx
80102eee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 00 40 80       	push   $0x80400000
80102ef7:	68 a8 a9 11 80       	push   $0x8011a9a8
80102efc:	e8 2f f5 ff ff       	call   80102430 <kinit1>
  kvmalloc();      // kernel page table
80102f01:	e8 ba 45 00 00       	call   801074c0 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 4b 40 00 00       	call   80106f60 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 07 33 00 00       	call   80106230 <uartinit>
  pinit();         // process table
80102f29:	e8 12 08 00 00       	call   80103740 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 4d 2f 00 00       	call   80105e80 <tvinit>
  binit();         // buffer cache
80102f33:	e8 08 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f38:	e8 53 de ff ff       	call   80100d90 <fileinit>
  ideinit();       // disk 
80102f3d:	e8 ee f0 ff ff       	call   80102030 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f42:	83 c4 0c             	add    $0xc,%esp
80102f45:	68 8a 00 00 00       	push   $0x8a
80102f4a:	68 8c b4 10 80       	push   $0x8010b48c
80102f4f:	68 00 70 00 80       	push   $0x80007000
80102f54:	e8 e7 1c 00 00       	call   80104c40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f59:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f60:	00 00 00 
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	05 80 37 11 80       	add    $0x80113780,%eax
80102f6b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f70:	76 71                	jbe    80102fe3 <main+0x103>
80102f72:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f77:	89 f6                	mov    %esi,%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102f80:	e8 db 07 00 00       	call   80103760 <mycpu>
80102f85:	39 d8                	cmp    %ebx,%eax
80102f87:	74 41                	je     80102fca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f89:	e8 72 f5 ff ff       	call   80102500 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f8e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f93:	c7 05 f8 6f 00 80 c0 	movl   $0x80102ec0,0x80006ff8
80102f9a:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f9d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fa4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fa7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fac:	0f b6 03             	movzbl (%ebx),%eax
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 70 00 00       	push   $0x7000
80102fb7:	50                   	push   %eax
80102fb8:	e8 03 f8 ff ff       	call   801027c0 <lapicstartap>
80102fbd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fc0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fc6:	85 c0                	test   %eax,%eax
80102fc8:	74 f6                	je     80102fc0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fca:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102fd1:	00 00 00 
80102fd4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102fda:	05 80 37 11 80       	add    $0x80113780,%eax
80102fdf:	39 c3                	cmp    %eax,%ebx
80102fe1:	72 9d                	jb     80102f80 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102fe3:	83 ec 08             	sub    $0x8,%esp
80102fe6:	68 00 00 00 8e       	push   $0x8e000000
80102feb:	68 00 00 40 80       	push   $0x80400000
80102ff0:	e8 ab f4 ff ff       	call   801024a0 <kinit2>
  userinit();      // first user process
80102ff5:	e8 66 09 00 00       	call   80103960 <userinit>
  mpmain();        // finish this processor's setup
80102ffa:	e8 81 fe ff ff       	call   80102e80 <mpmain>
80102fff:	90                   	nop

80103000 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103005:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010300b:	53                   	push   %ebx
  e = addr+len;
8010300c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010300f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103012:	39 de                	cmp    %ebx,%esi
80103014:	72 10                	jb     80103026 <mpsearch1+0x26>
80103016:	eb 50                	jmp    80103068 <mpsearch1+0x68>
80103018:	90                   	nop
80103019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103020:	39 fb                	cmp    %edi,%ebx
80103022:	89 fe                	mov    %edi,%esi
80103024:	76 42                	jbe    80103068 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103026:	83 ec 04             	sub    $0x4,%esp
80103029:	8d 7e 10             	lea    0x10(%esi),%edi
8010302c:	6a 04                	push   $0x4
8010302e:	68 d8 7b 10 80       	push   $0x80107bd8
80103033:	56                   	push   %esi
80103034:	e8 a7 1b 00 00       	call   80104be0 <memcmp>
80103039:	83 c4 10             	add    $0x10,%esp
8010303c:	85 c0                	test   %eax,%eax
8010303e:	75 e0                	jne    80103020 <mpsearch1+0x20>
80103040:	89 f1                	mov    %esi,%ecx
80103042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103048:	0f b6 11             	movzbl (%ecx),%edx
8010304b:	83 c1 01             	add    $0x1,%ecx
8010304e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103050:	39 f9                	cmp    %edi,%ecx
80103052:	75 f4                	jne    80103048 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103054:	84 c0                	test   %al,%al
80103056:	75 c8                	jne    80103020 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010305b:	89 f0                	mov    %esi,%eax
8010305d:	5b                   	pop    %ebx
8010305e:	5e                   	pop    %esi
8010305f:	5f                   	pop    %edi
80103060:	5d                   	pop    %ebp
80103061:	c3                   	ret    
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010306b:	31 f6                	xor    %esi,%esi
}
8010306d:	89 f0                	mov    %esi,%eax
8010306f:	5b                   	pop    %ebx
80103070:	5e                   	pop    %esi
80103071:	5f                   	pop    %edi
80103072:	5d                   	pop    %ebp
80103073:	c3                   	ret    
80103074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010307a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103080 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	57                   	push   %edi
80103084:	56                   	push   %esi
80103085:	53                   	push   %ebx
80103086:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103089:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103090:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103097:	c1 e0 08             	shl    $0x8,%eax
8010309a:	09 d0                	or     %edx,%eax
8010309c:	c1 e0 04             	shl    $0x4,%eax
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 1b                	jne    801030be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030b1:	c1 e0 08             	shl    $0x8,%eax
801030b4:	09 d0                	or     %edx,%eax
801030b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030be:	ba 00 04 00 00       	mov    $0x400,%edx
801030c3:	e8 38 ff ff ff       	call   80103000 <mpsearch1>
801030c8:	85 c0                	test   %eax,%eax
801030ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030cd:	0f 84 3d 01 00 00    	je     80103210 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030d6:	8b 58 04             	mov    0x4(%eax),%ebx
801030d9:	85 db                	test   %ebx,%ebx
801030db:	0f 84 4f 01 00 00    	je     80103230 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801030e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801030e7:	83 ec 04             	sub    $0x4,%esp
801030ea:	6a 04                	push   $0x4
801030ec:	68 f5 7b 10 80       	push   $0x80107bf5
801030f1:	56                   	push   %esi
801030f2:	e8 e9 1a 00 00       	call   80104be0 <memcmp>
801030f7:	83 c4 10             	add    $0x10,%esp
801030fa:	85 c0                	test   %eax,%eax
801030fc:	0f 85 2e 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103102:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103109:	3c 01                	cmp    $0x1,%al
8010310b:	0f 95 c2             	setne  %dl
8010310e:	3c 04                	cmp    $0x4,%al
80103110:	0f 95 c0             	setne  %al
80103113:	20 c2                	and    %al,%dl
80103115:	0f 85 15 01 00 00    	jne    80103230 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010311b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103122:	66 85 ff             	test   %di,%di
80103125:	74 1a                	je     80103141 <mpinit+0xc1>
80103127:	89 f0                	mov    %esi,%eax
80103129:	01 f7                	add    %esi,%edi
  sum = 0;
8010312b:	31 d2                	xor    %edx,%edx
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103130:	0f b6 08             	movzbl (%eax),%ecx
80103133:	83 c0 01             	add    $0x1,%eax
80103136:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103138:	39 c7                	cmp    %eax,%edi
8010313a:	75 f4                	jne    80103130 <mpinit+0xb0>
8010313c:	84 d2                	test   %dl,%dl
8010313e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103141:	85 f6                	test   %esi,%esi
80103143:	0f 84 e7 00 00 00    	je     80103230 <mpinit+0x1b0>
80103149:	84 d2                	test   %dl,%dl
8010314b:	0f 85 df 00 00 00    	jne    80103230 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103151:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103157:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010315c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103163:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103169:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010316e:	01 d6                	add    %edx,%esi
80103170:	39 c6                	cmp    %eax,%esi
80103172:	76 23                	jbe    80103197 <mpinit+0x117>
    switch(*p){
80103174:	0f b6 10             	movzbl (%eax),%edx
80103177:	80 fa 04             	cmp    $0x4,%dl
8010317a:	0f 87 ca 00 00 00    	ja     8010324a <mpinit+0x1ca>
80103180:	ff 24 95 1c 7c 10 80 	jmp    *-0x7fef83e4(,%edx,4)
80103187:	89 f6                	mov    %esi,%esi
80103189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103190:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103193:	39 c6                	cmp    %eax,%esi
80103195:	77 dd                	ja     80103174 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103197:	85 db                	test   %ebx,%ebx
80103199:	0f 84 9e 00 00 00    	je     8010323d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031a6:	74 15                	je     801031bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a8:	b8 70 00 00 00       	mov    $0x70,%eax
801031ad:	ba 22 00 00 00       	mov    $0x22,%edx
801031b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b3:	ba 23 00 00 00       	mov    $0x23,%edx
801031b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031bc:	ee                   	out    %al,(%dx)
  }
}
801031bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031c0:	5b                   	pop    %ebx
801031c1:	5e                   	pop    %esi
801031c2:	5f                   	pop    %edi
801031c3:	5d                   	pop    %ebp
801031c4:	c3                   	ret    
801031c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031c8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801031ce:	83 f9 07             	cmp    $0x7,%ecx
801031d1:	7f 19                	jg     801031ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031dd:	83 c1 01             	add    $0x1,%ecx
801031e0:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031e6:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801031ec:	83 c0 14             	add    $0x14,%eax
      continue;
801031ef:	e9 7c ff ff ff       	jmp    80103170 <mpinit+0xf0>
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801031f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801031fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801031ff:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103205:	e9 66 ff ff ff       	jmp    80103170 <mpinit+0xf0>
8010320a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103210:	ba 00 00 01 00       	mov    $0x10000,%edx
80103215:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010321a:	e8 e1 fd ff ff       	call   80103000 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010321f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103221:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103224:	0f 85 a9 fe ff ff    	jne    801030d3 <mpinit+0x53>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103230:	83 ec 0c             	sub    $0xc,%esp
80103233:	68 dd 7b 10 80       	push   $0x80107bdd
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 fc 7b 10 80       	push   $0x80107bfc
80103245:	e8 46 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010324a:	31 db                	xor    %ebx,%ebx
8010324c:	e9 26 ff ff ff       	jmp    80103177 <mpinit+0xf7>
80103251:	66 90                	xchg   %ax,%ax
80103253:	66 90                	xchg   %ax,%ax
80103255:	66 90                	xchg   %ax,%ax
80103257:	66 90                	xchg   %ax,%ax
80103259:	66 90                	xchg   %ax,%ax
8010325b:	66 90                	xchg   %ax,%ax
8010325d:	66 90                	xchg   %ax,%ax
8010325f:	90                   	nop

80103260 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103260:	55                   	push   %ebp
80103261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103266:	ba 21 00 00 00       	mov    $0x21,%edx
8010326b:	89 e5                	mov    %esp,%ebp
8010326d:	ee                   	out    %al,(%dx)
8010326e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103273:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103274:	5d                   	pop    %ebp
80103275:	c3                   	ret    
80103276:	66 90                	xchg   %ax,%ax
80103278:	66 90                	xchg   %ax,%ax
8010327a:	66 90                	xchg   %ax,%ax
8010327c:	66 90                	xchg   %ax,%ax
8010327e:	66 90                	xchg   %ax,%ax

80103280 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	57                   	push   %edi
80103284:	56                   	push   %esi
80103285:	53                   	push   %ebx
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010328c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010328f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010329b:	e8 10 db ff ff       	call   80100db0 <filealloc>
801032a0:	85 c0                	test   %eax,%eax
801032a2:	89 03                	mov    %eax,(%ebx)
801032a4:	74 22                	je     801032c8 <pipealloc+0x48>
801032a6:	e8 05 db ff ff       	call   80100db0 <filealloc>
801032ab:	85 c0                	test   %eax,%eax
801032ad:	89 06                	mov    %eax,(%esi)
801032af:	74 3f                	je     801032f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032b1:	e8 4a f2 ff ff       	call   80102500 <kalloc>
801032b6:	85 c0                	test   %eax,%eax
801032b8:	89 c7                	mov    %eax,%edi
801032ba:	75 54                	jne    80103310 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032bc:	8b 03                	mov    (%ebx),%eax
801032be:	85 c0                	test   %eax,%eax
801032c0:	75 34                	jne    801032f6 <pipealloc+0x76>
801032c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032c8:	8b 06                	mov    (%esi),%eax
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 0c                	je     801032da <pipealloc+0x5a>
    fileclose(*f1);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	50                   	push   %eax
801032d2:	e8 99 db ff ff       	call   80100e70 <fileclose>
801032d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032e2:	5b                   	pop    %ebx
801032e3:	5e                   	pop    %esi
801032e4:	5f                   	pop    %edi
801032e5:	5d                   	pop    %ebp
801032e6:	c3                   	ret    
801032e7:	89 f6                	mov    %esi,%esi
801032e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801032f0:	8b 03                	mov    (%ebx),%eax
801032f2:	85 c0                	test   %eax,%eax
801032f4:	74 e4                	je     801032da <pipealloc+0x5a>
    fileclose(*f0);
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	50                   	push   %eax
801032fa:	e8 71 db ff ff       	call   80100e70 <fileclose>
  if(*f1)
801032ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103301:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103304:	85 c0                	test   %eax,%eax
80103306:	75 c6                	jne    801032ce <pipealloc+0x4e>
80103308:	eb d0                	jmp    801032da <pipealloc+0x5a>
8010330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103310:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103313:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010331a:	00 00 00 
  p->writeopen = 1;
8010331d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103324:	00 00 00 
  p->nwrite = 0;
80103327:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010332e:	00 00 00 
  p->nread = 0;
80103331:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103338:	00 00 00 
  initlock(&p->lock, "pipe");
8010333b:	68 30 7c 10 80       	push   $0x80107c30
80103340:	50                   	push   %eax
80103341:	e8 fa 15 00 00       	call   80104940 <initlock>
  (*f0)->type = FD_PIPE;
80103346:	8b 03                	mov    (%ebx),%eax
  return 0;
80103348:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010334b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103351:	8b 03                	mov    (%ebx),%eax
80103353:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103357:	8b 03                	mov    (%ebx),%eax
80103359:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010335d:	8b 03                	mov    (%ebx),%eax
8010335f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103362:	8b 06                	mov    (%esi),%eax
80103364:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010336a:	8b 06                	mov    (%esi),%eax
8010336c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103370:	8b 06                	mov    (%esi),%eax
80103372:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103376:	8b 06                	mov    (%esi),%eax
80103378:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010337b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010337e:	31 c0                	xor    %eax,%eax
}
80103380:	5b                   	pop    %ebx
80103381:	5e                   	pop    %esi
80103382:	5f                   	pop    %edi
80103383:	5d                   	pop    %ebp
80103384:	c3                   	ret    
80103385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103390 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	56                   	push   %esi
80103394:	53                   	push   %ebx
80103395:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103398:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	53                   	push   %ebx
8010339f:	e8 dc 16 00 00       	call   80104a80 <acquire>
  if(writable){
801033a4:	83 c4 10             	add    $0x10,%esp
801033a7:	85 f6                	test   %esi,%esi
801033a9:	74 45                	je     801033f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033bb:	00 00 00 
    wakeup(&p->nread);
801033be:	50                   	push   %eax
801033bf:	e8 8c 0e 00 00       	call   80104250 <wakeup>
801033c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033cd:	85 d2                	test   %edx,%edx
801033cf:	75 0a                	jne    801033db <pipeclose+0x4b>
801033d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033d7:	85 c0                	test   %eax,%eax
801033d9:	74 35                	je     80103410 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801033e1:	5b                   	pop    %ebx
801033e2:	5e                   	pop    %esi
801033e3:	5d                   	pop    %ebp
    release(&p->lock);
801033e4:	e9 57 17 00 00       	jmp    80104b40 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 47 0e 00 00       	call   80104250 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 27 17 00 00       	call   80104b40 <release>
    kfree((char*)p);
80103419:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010341c:	83 c4 10             	add    $0x10,%esp
}
8010341f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103422:	5b                   	pop    %ebx
80103423:	5e                   	pop    %esi
80103424:	5d                   	pop    %ebp
    kfree((char*)p);
80103425:	e9 26 ef ff ff       	jmp    80102350 <kfree>
8010342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103430 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103430:	55                   	push   %ebp
80103431:	89 e5                	mov    %esp,%ebp
80103433:	57                   	push   %edi
80103434:	56                   	push   %esi
80103435:	53                   	push   %ebx
80103436:	83 ec 28             	sub    $0x28,%esp
80103439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010343c:	53                   	push   %ebx
8010343d:	e8 3e 16 00 00       	call   80104a80 <acquire>
  for(i = 0; i < n; i++){
80103442:	8b 45 10             	mov    0x10(%ebp),%eax
80103445:	83 c4 10             	add    $0x10,%esp
80103448:	85 c0                	test   %eax,%eax
8010344a:	0f 8e c9 00 00 00    	jle    80103519 <pipewrite+0xe9>
80103450:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103453:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103459:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010345f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103462:	03 4d 10             	add    0x10(%ebp),%ecx
80103465:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103468:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010346e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103474:	39 d0                	cmp    %edx,%eax
80103476:	75 71                	jne    801034e9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103478:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010347e:	85 c0                	test   %eax,%eax
80103480:	74 4e                	je     801034d0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103482:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103488:	eb 3a                	jmp    801034c4 <pipewrite+0x94>
8010348a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103490:	83 ec 0c             	sub    $0xc,%esp
80103493:	57                   	push   %edi
80103494:	e8 b7 0d 00 00       	call   80104250 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 ee 0c 00 00       	call   80104190 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034a2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034a8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ae:	83 c4 10             	add    $0x10,%esp
801034b1:	05 00 02 00 00       	add    $0x200,%eax
801034b6:	39 c2                	cmp    %eax,%edx
801034b8:	75 36                	jne    801034f0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034c0:	85 c0                	test   %eax,%eax
801034c2:	74 0c                	je     801034d0 <pipewrite+0xa0>
801034c4:	e8 37 03 00 00       	call   80103800 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 67 16 00 00       	call   80104b40 <release>
        return -1;
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034e9:	89 c2                	mov    %eax,%edx
801034eb:	90                   	nop
801034ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801034f0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801034f3:	8d 42 01             	lea    0x1(%edx),%eax
801034f6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801034fc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103502:	83 c6 01             	add    $0x1,%esi
80103505:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103509:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010350c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010350f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103513:	0f 85 4f ff ff ff    	jne    80103468 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103519:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	50                   	push   %eax
80103523:	e8 28 0d 00 00       	call   80104250 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 10 16 00 00       	call   80104b40 <release>
  return n;
80103530:	83 c4 10             	add    $0x10,%esp
80103533:	8b 45 10             	mov    0x10(%ebp),%eax
80103536:	eb a9                	jmp    801034e1 <pipewrite+0xb1>
80103538:	90                   	nop
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103540 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 18             	sub    $0x18,%esp
80103549:	8b 75 08             	mov    0x8(%ebp),%esi
8010354c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010354f:	56                   	push   %esi
80103550:	e8 2b 15 00 00       	call   80104a80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103555:	83 c4 10             	add    $0x10,%esp
80103558:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010355e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103564:	75 6a                	jne    801035d0 <piperead+0x90>
80103566:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010356c:	85 db                	test   %ebx,%ebx
8010356e:	0f 84 c4 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103574:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010357a:	eb 2d                	jmp    801035a9 <piperead+0x69>
8010357c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103580:	83 ec 08             	sub    $0x8,%esp
80103583:	56                   	push   %esi
80103584:	53                   	push   %ebx
80103585:	e8 06 0c 00 00       	call   80104190 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 52 02 00 00       	call   80103800 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 7d 15 00 00       	call   80104b40 <release>
      return -1;
801035c3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035c9:	89 d8                	mov    %ebx,%eax
801035cb:	5b                   	pop    %ebx
801035cc:	5e                   	pop    %esi
801035cd:	5f                   	pop    %edi
801035ce:	5d                   	pop    %ebp
801035cf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035d0:	8b 45 10             	mov    0x10(%ebp),%eax
801035d3:	85 c0                	test   %eax,%eax
801035d5:	7e 61                	jle    80103638 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035d7:	31 db                	xor    %ebx,%ebx
801035d9:	eb 13                	jmp    801035ee <piperead+0xae>
801035db:	90                   	nop
801035dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035e0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035e6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035ec:	74 1f                	je     8010360d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801035ee:	8d 41 01             	lea    0x1(%ecx),%eax
801035f1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801035f7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801035fd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103602:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103605:	83 c3 01             	add    $0x1,%ebx
80103608:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010360b:	75 d3                	jne    801035e0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010360d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103613:	83 ec 0c             	sub    $0xc,%esp
80103616:	50                   	push   %eax
80103617:	e8 34 0c 00 00       	call   80104250 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 1c 15 00 00       	call   80104b40 <release>
  return i;
80103624:	83 c4 10             	add    $0x10,%esp
}
80103627:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010362a:	89 d8                	mov    %ebx,%eax
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103638:	31 db                	xor    %ebx,%ebx
8010363a:	eb d1                	jmp    8010360d <piperead+0xcd>
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103640:	55                   	push   %ebp

static inline int
cas(volatile void *addr, int expected, int newval){
  int eflags;

  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103641:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
80103646:	89 e5                	mov    %esp,%ebp
80103648:	57                   	push   %edi
80103649:	56                   	push   %esi
8010364a:	53                   	push   %ebx
8010364b:	89 c7                	mov    %eax,%edi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010364d:	be 54 3d 11 80       	mov    $0x80113d54,%esi
{
80103652:	83 ec 2c             	sub    $0x2c,%esp
80103655:	eb 17                	jmp    8010366e <wakeup1+0x2e>
80103657:	89 f6                	mov    %esi,%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103660:	81 c6 90 01 00 00    	add    $0x190,%esi
80103666:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
8010366c:	73 78                	jae    801036e6 <wakeup1+0xa6>
    if(p->chan == chan && (p->state == SLEEPING || p->state == -SLEEPING)){
8010366e:	39 7e 20             	cmp    %edi,0x20(%esi)
80103671:	75 ed                	jne    80103660 <wakeup1+0x20>
80103673:	8b 46 0c             	mov    0xc(%esi),%eax
80103676:	83 f8 02             	cmp    $0x2,%eax
80103679:	74 0d                	je     80103688 <wakeup1+0x48>
8010367b:	8b 46 0c             	mov    0xc(%esi),%eax
8010367e:	83 f8 fe             	cmp    $0xfffffffe,%eax
80103681:	75 dd                	jne    80103660 <wakeup1+0x20>
80103683:	90                   	nop
80103684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(p->state == -SLEEPING);
80103688:	8b 46 0c             	mov    0xc(%esi),%eax
8010368b:	83 f8 fe             	cmp    $0xfffffffe,%eax
8010368e:	74 f8                	je     80103688 <wakeup1+0x48>
80103690:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103693:	b8 02 00 00 00       	mov    $0x2,%eax
80103698:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010369c:	9c                   	pushf  
8010369d:	8f 45 e4             	popl   -0x1c(%ebp)
      if(cas(&p->state,SLEEPING,-RUNNABLE)){
801036a0:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801036a4:	74 ba                	je     80103660 <wakeup1+0x20>
        p->chan = 0;
801036a6:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
801036ad:	b9 03 00 00 00       	mov    $0x3,%ecx
801036b2:	89 d0                	mov    %edx,%eax
801036b4:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
801036b8:	9c                   	pushf  
801036b9:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&p->state,-RUNNABLE,RUNNABLE)){
801036bc:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801036c0:	75 9e                	jne    80103660 <wakeup1+0x20>
          cprintf("wakeup1 cas err\n");
801036c2:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036c5:	81 c6 90 01 00 00    	add    $0x190,%esi
801036cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
          cprintf("wakeup1 cas err\n");
801036ce:	68 35 7c 10 80       	push   $0x80107c35
801036d3:	e8 88 cf ff ff       	call   80100660 <cprintf>
801036d8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036db:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
          cprintf("wakeup1 cas err\n");
801036e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036e4:	72 88                	jb     8010366e <wakeup1+0x2e>
      }

    }
      
  }
}
801036e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036e9:	5b                   	pop    %ebx
801036ea:	5e                   	pop    %esi
801036eb:	5f                   	pop    %edi
801036ec:	5d                   	pop    %ebp
801036ed:	c3                   	ret    
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <forkret>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	83 ec 08             	sub    $0x8,%esp
  popcli();
801036f6:	e8 f5 12 00 00       	call   801049f0 <popcli>
  if (first) {
801036fb:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103700:	85 c0                	test   %eax,%eax
80103702:	75 0c                	jne    80103710 <forkret+0x20>
}
80103704:	c9                   	leave  
80103705:	c3                   	ret    
80103706:	8d 76 00             	lea    0x0(%esi),%esi
80103709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iinit(ROOTDEV);
80103710:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103713:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010371a:	00 00 00 
    iinit(ROOTDEV);
8010371d:	6a 01                	push   $0x1
8010371f:	e8 8c dd ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103724:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010372b:	e8 10 f4 ff ff       	call   80102b40 <initlog>
80103730:	83 c4 10             	add    $0x10,%esp
}
80103733:	c9                   	leave  
80103734:	c3                   	ret    
80103735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103740 <pinit>:
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103746:	68 46 7c 10 80       	push   $0x80107c46
8010374b:	68 20 3d 11 80       	push   $0x80113d20
80103750:	e8 eb 11 00 00       	call   80104940 <initlock>
}
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	c9                   	leave  
80103759:	c3                   	ret    
8010375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103760 <mycpu>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103765:	9c                   	pushf  
80103766:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103767:	f6 c4 02             	test   $0x2,%ah
8010376a:	75 5e                	jne    801037ca <mycpu+0x6a>
  apicid = lapicid();
8010376c:	e8 ff ef ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103771:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103777:	85 f6                	test   %esi,%esi
80103779:	7e 42                	jle    801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010377b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103782:	39 d0                	cmp    %edx,%eax
80103784:	74 30                	je     801037b6 <mycpu+0x56>
80103786:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010378b:	31 d2                	xor    %edx,%edx
8010378d:	8d 76 00             	lea    0x0(%esi),%esi
80103790:	83 c2 01             	add    $0x1,%edx
80103793:	39 f2                	cmp    %esi,%edx
80103795:	74 26                	je     801037bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103797:	0f b6 19             	movzbl (%ecx),%ebx
8010379a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037a0:	39 c3                	cmp    %eax,%ebx
801037a2:	75 ec                	jne    80103790 <mycpu+0x30>
801037a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037aa:	05 80 37 11 80       	add    $0x80113780,%eax
}
801037af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b2:	5b                   	pop    %ebx
801037b3:	5e                   	pop    %esi
801037b4:	5d                   	pop    %ebp
801037b5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037b6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
801037bb:	eb f2                	jmp    801037af <mycpu+0x4f>
  panic("unknown apicid\n");
801037bd:	83 ec 0c             	sub    $0xc,%esp
801037c0:	68 4d 7c 10 80       	push   $0x80107c4d
801037c5:	e8 c6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	68 b8 7d 10 80       	push   $0x80107db8
801037d2:	e8 b9 cb ff ff       	call   80100390 <panic>
801037d7:	89 f6                	mov    %esi,%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <cpuid>:
cpuid() {
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037e6:	e8 75 ff ff ff       	call   80103760 <mycpu>
801037eb:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801037f0:	c9                   	leave  
  return mycpu()-cpus;
801037f1:	c1 f8 04             	sar    $0x4,%eax
801037f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037fa:	c3                   	ret    
801037fb:	90                   	nop
801037fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103800 <myproc>:
myproc(void) {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103807:	e8 a4 11 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010380c:	e8 4f ff ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103811:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103817:	e8 d4 11 00 00       	call   801049f0 <popcli>
}
8010381c:	83 c4 04             	add    $0x4,%esp
8010381f:	89 d8                	mov    %ebx,%eax
80103821:	5b                   	pop    %ebx
80103822:	5d                   	pop    %ebp
80103823:	c3                   	ret    
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <allocpid>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
80103835:	bb 04 b0 10 80       	mov    $0x8010b004,%ebx
8010383a:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010383d:	e8 6e 11 00 00       	call   801049b0 <pushcli>
80103842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = nextpid;
80103848:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  }while (!cas(&nextpid,pid,pid+1));
8010384d:	8d 70 01             	lea    0x1(%eax),%esi
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103850:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103854:	9c                   	pushf  
80103855:	8f 45 f4             	popl   -0xc(%ebp)
80103858:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
8010385c:	74 ea                	je     80103848 <allocpid+0x18>
  popcli();
8010385e:	e8 8d 11 00 00       	call   801049f0 <popcli>
}
80103863:	83 c4 10             	add    $0x10,%esp
80103866:	89 f0                	mov    %esi,%eax
80103868:	5b                   	pop    %ebx
80103869:	5e                   	pop    %esi
8010386a:	5d                   	pop    %ebp
8010386b:	c3                   	ret    
8010386c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103870 <allocproc>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103875:	be 54 3d 11 80       	mov    $0x80113d54,%esi
{
8010387a:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010387d:	e8 2e 11 00 00       	call   801049b0 <pushcli>
80103882:	31 c0                	xor    %eax,%eax
80103884:	ba 01 00 00 00       	mov    $0x1,%edx
80103889:	eb 17                	jmp    801038a2 <allocproc+0x32>
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103890:	81 c6 90 01 00 00    	add    $0x190,%esi
80103896:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
8010389c:	0f 83 a2 00 00 00    	jae    80103944 <allocproc+0xd4>
801038a2:	8d 5e 0c             	lea    0xc(%esi),%ebx
801038a5:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801038a9:	9c                   	pushf  
801038aa:	8f 45 f4             	popl   -0xc(%ebp)
      if(cas(&(p->state),UNUSED,EMBRYO)){
801038ad:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
801038b1:	74 dd                	je     80103890 <allocproc+0x20>
  popcli();
801038b3:	e8 38 11 00 00       	call   801049f0 <popcli>
  p->pid = allocpid();
801038b8:	e8 73 ff ff ff       	call   80103830 <allocpid>
801038bd:	89 46 10             	mov    %eax,0x10(%esi)
  if((p->kstack = kalloc()) == 0){
801038c0:	e8 3b ec ff ff       	call   80102500 <kalloc>
801038c5:	85 c0                	test   %eax,%eax
801038c7:	89 46 08             	mov    %eax,0x8(%esi)
801038ca:	0f 84 84 00 00 00    	je     80103954 <allocproc+0xe4>
  sp -= sizeof *p->tf;
801038d0:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801038d6:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038d9:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038de:	89 56 18             	mov    %edx,0x18(%esi)
  *(uint*)sp = (uint)trapret;
801038e1:	c7 40 14 67 5e 10 80 	movl   $0x80105e67,0x14(%eax)
  p->context = (struct context*)sp;
801038e8:	89 46 1c             	mov    %eax,0x1c(%esi)
  memset(p->context, 0, sizeof *p->context);
801038eb:	6a 14                	push   $0x14
801038ed:	6a 00                	push   $0x0
801038ef:	50                   	push   %eax
801038f0:	e8 9b 12 00 00       	call   80104b90 <memset>
  p->context->eip = (uint)forkret;
801038f5:	8b 46 1c             	mov    0x1c(%esi),%eax
801038f8:	8d 96 0c 01 00 00    	lea    0x10c(%esi),%edx
801038fe:	83 c4 10             	add    $0x10,%esp
80103901:	c7 40 10 f0 36 10 80 	movl   $0x801036f0,0x10(%eax)
80103908:	8d 86 8c 00 00 00    	lea    0x8c(%esi),%eax
8010390e:	66 90                	xchg   %ax,%ax
    p->signalHandler[i] =(void*)SIG_DFL;
80103910:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103917:	00 00 00 
    p->signalHandlerMasks[i] = 0;
8010391a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103920:	83 c0 04             	add    $0x4,%eax
  for(int i = 0 ; i < SIGNAL_HANDLERS_SIZE ; i++){
80103923:	39 c2                	cmp    %eax,%edx
80103925:	75 e9                	jne    80103910 <allocproc+0xa0>
  p->pendingSignals = 0;
80103927:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010392e:	00 00 00 
  p->signalMask = 0;
80103931:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80103938:	00 00 00 
}
8010393b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010393e:	89 f0                	mov    %esi,%eax
80103940:	5b                   	pop    %ebx
80103941:	5e                   	pop    %esi
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    
    popcli();
80103944:	e8 a7 10 00 00       	call   801049f0 <popcli>
}
80103949:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010394c:	31 f6                	xor    %esi,%esi
}
8010394e:	89 f0                	mov    %esi,%eax
80103950:	5b                   	pop    %ebx
80103951:	5e                   	pop    %esi
80103952:	5d                   	pop    %ebp
80103953:	c3                   	ret    
    p->state = UNUSED;
80103954:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return 0;
8010395b:	31 f6                	xor    %esi,%esi
8010395d:	eb dc                	jmp    8010393b <allocproc+0xcb>
8010395f:	90                   	nop

80103960 <userinit>:
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103967:	e8 04 ff ff ff       	call   80103870 <allocproc>
8010396c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010396e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103973:	e8 c8 3a 00 00       	call   80107440 <setupkvm>
80103978:	85 c0                	test   %eax,%eax
8010397a:	89 43 04             	mov    %eax,0x4(%ebx)
8010397d:	0f 84 d3 00 00 00    	je     80103a56 <userinit+0xf6>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103983:	83 ec 04             	sub    $0x4,%esp
80103986:	68 2c 00 00 00       	push   $0x2c
8010398b:	68 60 b4 10 80       	push   $0x8010b460
80103990:	50                   	push   %eax
80103991:	e8 8a 37 00 00       	call   80107120 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103996:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103999:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010399f:	6a 4c                	push   $0x4c
801039a1:	6a 00                	push   $0x0
801039a3:	ff 73 18             	pushl  0x18(%ebx)
801039a6:	e8 e5 11 00 00       	call   80104b90 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ab:	8b 43 18             	mov    0x18(%ebx),%eax
801039ae:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039b3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039b8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039bb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039bf:	8b 43 18             	mov    0x18(%ebx),%eax
801039c2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039c6:	8b 43 18             	mov    0x18(%ebx),%eax
801039c9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039cd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039d1:	8b 43 18             	mov    0x18(%ebx),%eax
801039d4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039d8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039dc:	8b 43 18             	mov    0x18(%ebx),%eax
801039df:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039e6:	8b 43 18             	mov    0x18(%ebx),%eax
801039e9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039f0:	8b 43 18             	mov    0x18(%ebx),%eax
801039f3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039fa:	8d 43 70             	lea    0x70(%ebx),%eax
801039fd:	6a 10                	push   $0x10
801039ff:	68 76 7c 10 80       	push   $0x80107c76
  if(!cas(&p->state,EMBRYO,RUNNABLE)){
80103a04:	83 c3 0c             	add    $0xc,%ebx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	50                   	push   %eax
80103a08:	e8 63 13 00 00       	call   80104d70 <safestrcpy>
  p->cwd = namei("/");
80103a0d:	c7 04 24 7f 7c 10 80 	movl   $0x80107c7f,(%esp)
80103a14:	e8 f7 e4 ff ff       	call   80101f10 <namei>
80103a19:	89 43 60             	mov    %eax,0x60(%ebx)
  pushcli();
80103a1c:	e8 8f 0f 00 00       	call   801049b0 <pushcli>
80103a21:	b8 01 00 00 00       	mov    $0x1,%eax
80103a26:	ba 03 00 00 00       	mov    $0x3,%edx
80103a2b:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103a2f:	9c                   	pushf  
80103a30:	8f 45 f4             	popl   -0xc(%ebp)
  if(!cas(&p->state,EMBRYO,RUNNABLE)){
80103a33:	83 c4 10             	add    $0x10,%esp
80103a36:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
80103a3a:	75 10                	jne    80103a4c <userinit+0xec>
    cprintf("user init cas err");
80103a3c:	83 ec 0c             	sub    $0xc,%esp
80103a3f:	68 81 7c 10 80       	push   $0x80107c81
80103a44:	e8 17 cc ff ff       	call   80100660 <cprintf>
80103a49:	83 c4 10             	add    $0x10,%esp
  popcli();
80103a4c:	e8 9f 0f 00 00       	call   801049f0 <popcli>
}
80103a51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a54:	c9                   	leave  
80103a55:	c3                   	ret    
    panic("userinit: out of memory?");
80103a56:	83 ec 0c             	sub    $0xc,%esp
80103a59:	68 5d 7c 10 80       	push   $0x80107c5d
80103a5e:	e8 2d c9 ff ff       	call   80100390 <panic>
80103a63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a70 <growproc>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	56                   	push   %esi
80103a74:	53                   	push   %ebx
80103a75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a78:	e8 33 0f 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80103a7d:	e8 de fc ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103a82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a88:	e8 63 0f 00 00       	call   801049f0 <popcli>
  if(n > 0){
80103a8d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a90:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a92:	7f 1c                	jg     80103ab0 <growproc+0x40>
  } else if(n < 0){
80103a94:	75 3a                	jne    80103ad0 <growproc+0x60>
  switchuvm(curproc);
80103a96:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a99:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a9b:	53                   	push   %ebx
80103a9c:	e8 6f 35 00 00       	call   80107010 <switchuvm>
  return 0;
80103aa1:	83 c4 10             	add    $0x10,%esp
80103aa4:	31 c0                	xor    %eax,%eax
}
80103aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aa9:	5b                   	pop    %ebx
80103aaa:	5e                   	pop    %esi
80103aab:	5d                   	pop    %ebp
80103aac:	c3                   	ret    
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ab0:	83 ec 04             	sub    $0x4,%esp
80103ab3:	01 c6                	add    %eax,%esi
80103ab5:	56                   	push   %esi
80103ab6:	50                   	push   %eax
80103ab7:	ff 73 04             	pushl  0x4(%ebx)
80103aba:	e8 a1 37 00 00       	call   80107260 <allocuvm>
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	85 c0                	test   %eax,%eax
80103ac4:	75 d0                	jne    80103a96 <growproc+0x26>
      return -1;
80103ac6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103acb:	eb d9                	jmp    80103aa6 <growproc+0x36>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ad0:	83 ec 04             	sub    $0x4,%esp
80103ad3:	01 c6                	add    %eax,%esi
80103ad5:	56                   	push   %esi
80103ad6:	50                   	push   %eax
80103ad7:	ff 73 04             	pushl  0x4(%ebx)
80103ada:	e8 b1 38 00 00       	call   80107390 <deallocuvm>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	85 c0                	test   %eax,%eax
80103ae4:	75 b0                	jne    80103a96 <growproc+0x26>
80103ae6:	eb de                	jmp    80103ac6 <growproc+0x56>
80103ae8:	90                   	nop
80103ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103af0 <fork>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	57                   	push   %edi
80103af4:	56                   	push   %esi
80103af5:	53                   	push   %ebx
80103af6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103af9:	e8 b2 0e 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80103afe:	e8 5d fc ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103b03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b09:	e8 e2 0e 00 00       	call   801049f0 <popcli>
  if((np = allocproc()) == 0){
80103b0e:	e8 5d fd ff ff       	call   80103870 <allocproc>
80103b13:	85 c0                	test   %eax,%eax
80103b15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103b18:	0f 84 24 01 00 00    	je     80103c42 <fork+0x152>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b1e:	83 ec 08             	sub    $0x8,%esp
80103b21:	ff 33                	pushl  (%ebx)
80103b23:	ff 73 04             	pushl  0x4(%ebx)
80103b26:	e8 e5 39 00 00       	call   80107510 <copyuvm>
80103b2b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103b2e:	83 c4 10             	add    $0x10,%esp
80103b31:	85 c0                	test   %eax,%eax
80103b33:	89 42 04             	mov    %eax,0x4(%edx)
80103b36:	0f 84 0d 01 00 00    	je     80103c49 <fork+0x159>
  np->sz = curproc->sz;
80103b3c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103b3e:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103b43:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b46:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
80103b49:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103b4b:	8b 73 18             	mov    0x18(%ebx),%esi
80103b4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->signalMask = curproc->signalMask;
80103b50:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  np->pendingSignals = 0;
80103b56:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80103b5d:	00 00 00 
  np->signalMask = curproc->signalMask;
80103b60:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  for(int i = 0 ; i < 32 ; i++){
80103b66:	31 c0                	xor    %eax,%eax
80103b68:	90                   	nop
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->signalHandler[i] = curproc->signalHandler[i];
80103b70:	8b 8c 83 0c 01 00 00 	mov    0x10c(%ebx,%eax,4),%ecx
80103b77:	89 8c 82 0c 01 00 00 	mov    %ecx,0x10c(%edx,%eax,4)
    np->signalHandlerMasks[i] = curproc->signalHandlerMasks[i];
80103b7e:	8b 8c 83 8c 00 00 00 	mov    0x8c(%ebx,%eax,4),%ecx
80103b85:	89 8c 82 8c 00 00 00 	mov    %ecx,0x8c(%edx,%eax,4)
  for(int i = 0 ; i < 32 ; i++){
80103b8c:	83 c0 01             	add    $0x1,%eax
80103b8f:	83 f8 20             	cmp    $0x20,%eax
80103b92:	75 dc                	jne    80103b70 <fork+0x80>
  np->tf->eax = 0;
80103b94:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80103b97:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ba0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103ba4:	85 c0                	test   %eax,%eax
80103ba6:	74 16                	je     80103bbe <fork+0xce>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ba8:	83 ec 0c             	sub    $0xc,%esp
80103bab:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80103bae:	50                   	push   %eax
80103baf:	e8 6c d2 ff ff       	call   80100e20 <filedup>
80103bb4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103bb7:	83 c4 10             	add    $0x10,%esp
80103bba:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bbe:	83 c6 01             	add    $0x1,%esi
80103bc1:	83 fe 10             	cmp    $0x10,%esi
80103bc4:	75 da                	jne    80103ba0 <fork+0xb0>
  np->cwd = idup(curproc->cwd);
80103bc6:	83 ec 0c             	sub    $0xc,%esp
80103bc9:	ff 73 6c             	pushl  0x6c(%ebx)
80103bcc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bcf:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103bd2:	e8 a9 da ff ff       	call   80101680 <idup>
80103bd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bda:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdd:	89 42 6c             	mov    %eax,0x6c(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be0:	8d 42 70             	lea    0x70(%edx),%eax
80103be3:	6a 10                	push   $0x10
80103be5:	53                   	push   %ebx
80103be6:	50                   	push   %eax
80103be7:	e8 84 11 00 00       	call   80104d70 <safestrcpy>
  pid = np->pid;
80103bec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103bef:	8b 72 10             	mov    0x10(%edx),%esi
  pushcli();
80103bf2:	e8 b9 0d 00 00       	call   801049b0 <pushcli>
  if(!cas(&np->state,EMBRYO,RUNNABLE)){
80103bf7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103bfa:	b8 01 00 00 00       	mov    $0x1,%eax
80103bff:	8d 5a 0c             	lea    0xc(%edx),%ebx
80103c02:	ba 03 00 00 00       	mov    $0x3,%edx
80103c07:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103c0b:	9c                   	pushf  
80103c0c:	8f 45 e4             	popl   -0x1c(%ebp)
80103c0f:	83 c4 10             	add    $0x10,%esp
80103c12:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103c16:	74 18                	je     80103c30 <fork+0x140>
  popcli();
80103c18:	e8 d3 0d 00 00       	call   801049f0 <popcli>
}
80103c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c20:	89 f0                	mov    %esi,%eax
80103c22:	5b                   	pop    %ebx
80103c23:	5e                   	pop    %esi
80103c24:	5f                   	pop    %edi
80103c25:	5d                   	pop    %ebp
80103c26:	c3                   	ret    
80103c27:	89 f6                	mov    %esi,%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    cprintf("fork cas error");
80103c30:	83 ec 0c             	sub    $0xc,%esp
80103c33:	68 93 7c 10 80       	push   $0x80107c93
80103c38:	e8 23 ca ff ff       	call   80100660 <cprintf>
80103c3d:	83 c4 10             	add    $0x10,%esp
80103c40:	eb d6                	jmp    80103c18 <fork+0x128>
    return -1;
80103c42:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c47:	eb d4                	jmp    80103c1d <fork+0x12d>
    kfree(np->kstack);
80103c49:	83 ec 0c             	sub    $0xc,%esp
80103c4c:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80103c4f:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c54:	e8 f7 e6 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
80103c59:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    return -1;
80103c5c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103c5f:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80103c66:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80103c6d:	eb ae                	jmp    80103c1d <fork+0x12d>
80103c6f:	90                   	nop

80103c70 <scheduler>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	57                   	push   %edi
80103c74:	56                   	push   %esi
80103c75:	53                   	push   %ebx
80103c76:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80103c79:	e8 e2 fa ff ff       	call   80103760 <mycpu>
  c->proc = 0;
80103c7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c85:	00 00 00 
  struct cpu *c = mycpu();
80103c88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103c8b:	83 c0 04             	add    $0x4,%eax
80103c8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103c91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c98:	fb                   	sti    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c99:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103c9e:	be fc ff ff ff       	mov    $0xfffffffc,%esi
    pushcli();
80103ca3:	e8 08 0d 00 00       	call   801049b0 <pushcli>
80103ca8:	90                   	nop
80103ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->frozen == 1)
80103cb0:	83 7f 28 01          	cmpl   $0x1,0x28(%edi)
80103cb4:	0f 84 9d 00 00 00    	je     80103d57 <scheduler+0xe7>
80103cba:	8d 5f 0c             	lea    0xc(%edi),%ebx
80103cbd:	b8 03 00 00 00       	mov    $0x3,%eax
80103cc2:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103cc6:	9c                   	pushf  
80103cc7:	8f 45 e4             	popl   -0x1c(%ebp)
      if(!cas(&p->state, RUNNABLE, -RUNNING))
80103cca:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103cce:	0f 84 83 00 00 00    	je     80103d57 <scheduler+0xe7>
      c->proc = p;
80103cd4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      switchuvm(p);
80103cd7:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103cda:	89 ba ac 00 00 00    	mov    %edi,0xac(%edx)
      switchuvm(p);
80103ce0:	57                   	push   %edi
80103ce1:	e8 2a 33 00 00       	call   80107010 <switchuvm>
80103ce6:	b9 04 00 00 00       	mov    $0x4,%ecx
80103ceb:	89 f0                	mov    %esi,%eax
80103ced:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103cf1:	9c                   	pushf  
80103cf2:	8f 45 e4             	popl   -0x1c(%ebp)
      swtch(&(c->scheduler), p->context);
80103cf5:	58                   	pop    %eax
80103cf6:	5a                   	pop    %edx
80103cf7:	ff 77 1c             	pushl  0x1c(%edi)
80103cfa:	ff 75 d0             	pushl  -0x30(%ebp)
80103cfd:	e8 c9 10 00 00       	call   80104dcb <swtch>
      switchkvm();
80103d02:	e8 e9 32 00 00       	call   80106ff0 <switchkvm>
      c->proc = 0;
80103d07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103d0a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80103d0f:	c7 82 ac 00 00 00 00 	movl   $0x0,0xac(%edx)
80103d16:	00 00 00 
80103d19:	ba 03 00 00 00       	mov    $0x3,%edx
80103d1e:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103d22:	9c                   	pushf  
80103d23:	8f 45 e4             	popl   -0x1c(%ebp)
80103d26:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103d2b:	b9 02 00 00 00       	mov    $0x2,%ecx
80103d30:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103d34:	9c                   	pushf  
80103d35:	8f 45 e4             	popl   -0x1c(%ebp)
80103d38:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
80103d3d:	b9 05 00 00 00       	mov    $0x5,%ecx
80103d42:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103d46:	9c                   	pushf  
80103d47:	8f 45 e4             	popl   -0x1c(%ebp)
80103d4a:	31 c0                	xor    %eax,%eax
80103d4c:	f0 0f b1 03          	lock cmpxchg %eax,(%ebx)
80103d50:	9c                   	pushf  
80103d51:	8f 45 e4             	popl   -0x1c(%ebp)
80103d54:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d57:	81 c7 90 01 00 00    	add    $0x190,%edi
80103d5d:	81 ff 54 a1 11 80    	cmp    $0x8011a154,%edi
80103d63:	0f 82 47 ff ff ff    	jb     80103cb0 <scheduler+0x40>
    popcli();
80103d69:	e8 82 0c 00 00       	call   801049f0 <popcli>
    sti();
80103d6e:	e9 25 ff ff ff       	jmp    80103c98 <scheduler+0x28>
80103d73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d80 <sched>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
  pushcli();
80103d85:	e8 26 0c 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80103d8a:	e8 d1 f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103d8f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d95:	e8 56 0c 00 00       	call   801049f0 <popcli>
  if(mycpu()->ncli != 1)
80103d9a:	e8 c1 f9 ff ff       	call   80103760 <mycpu>
80103d9f:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103da6:	75 43                	jne    80103deb <sched+0x6b>
  if(p->state == RUNNING)
80103da8:	8b 43 0c             	mov    0xc(%ebx),%eax
80103dab:	83 f8 04             	cmp    $0x4,%eax
80103dae:	74 55                	je     80103e05 <sched+0x85>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103db0:	9c                   	pushf  
80103db1:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103db2:	f6 c4 02             	test   $0x2,%ah
80103db5:	75 41                	jne    80103df8 <sched+0x78>
  intena = mycpu()->intena;
80103db7:	e8 a4 f9 ff ff       	call   80103760 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dbc:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dbf:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dc5:	e8 96 f9 ff ff       	call   80103760 <mycpu>
80103dca:	83 ec 08             	sub    $0x8,%esp
80103dcd:	ff 70 04             	pushl  0x4(%eax)
80103dd0:	53                   	push   %ebx
80103dd1:	e8 f5 0f 00 00       	call   80104dcb <swtch>
  mycpu()->intena = intena;
80103dd6:	e8 85 f9 ff ff       	call   80103760 <mycpu>
}
80103ddb:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103dde:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103de4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103de7:	5b                   	pop    %ebx
80103de8:	5e                   	pop    %esi
80103de9:	5d                   	pop    %ebp
80103dea:	c3                   	ret    
    panic("sched locks");
80103deb:	83 ec 0c             	sub    $0xc,%esp
80103dee:	68 a2 7c 10 80       	push   $0x80107ca2
80103df3:	e8 98 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	68 bc 7c 10 80       	push   $0x80107cbc
80103e00:	e8 8b c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e05:	83 ec 0c             	sub    $0xc,%esp
80103e08:	68 ae 7c 10 80       	push   $0x80107cae
80103e0d:	e8 7e c5 ff ff       	call   80100390 <panic>
80103e12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <exit>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e29:	e8 82 0b 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80103e2e:	e8 2d f9 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103e33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e39:	e8 b2 0b 00 00       	call   801049f0 <popcli>
  if(curproc == initproc)
80103e3e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103e44:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103e47:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103e4a:	0f 84 d7 00 00 00    	je     80103f27 <exit+0x107>
    if(curproc->ofile[fd]){
80103e50:	8b 03                	mov    (%ebx),%eax
80103e52:	85 c0                	test   %eax,%eax
80103e54:	74 12                	je     80103e68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	50                   	push   %eax
80103e5a:	e8 11 d0 ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
80103e5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e65:	83 c4 10             	add    $0x10,%esp
80103e68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e6b:	39 df                	cmp    %ebx,%edi
80103e6d:	75 e1                	jne    80103e50 <exit+0x30>
  begin_op();
80103e6f:	e8 6c ed ff ff       	call   80102be0 <begin_op>
  iput(curproc->cwd);
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	ff 76 6c             	pushl  0x6c(%esi)
  if(!cas(&curproc->state,RUNNING,-ZOMBIE)){
80103e7a:	8d 5e 0c             	lea    0xc(%esi),%ebx
  iput(curproc->cwd);
80103e7d:	e8 5e d9 ff ff       	call   801017e0 <iput>
  end_op();
80103e82:	e8 c9 ed ff ff       	call   80102c50 <end_op>
  curproc->cwd = 0;
80103e87:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  pushcli();
80103e8e:	e8 1d 0b 00 00       	call   801049b0 <pushcli>
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103e93:	b8 04 00 00 00       	mov    $0x4,%eax
80103e98:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
80103e9d:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103ea1:	9c                   	pushf  
80103ea2:	8f 45 e4             	popl   -0x1c(%ebp)
  if(!cas(&curproc->state,RUNNING,-ZOMBIE)){
80103ea5:	83 c4 10             	add    $0x10,%esp
80103ea8:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103eac:	74 64                	je     80103f12 <exit+0xf2>
   wakeup1(curproc->parent);
80103eae:	8b 46 14             	mov    0x14(%esi),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb1:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
   wakeup1(curproc->parent);
80103eb6:	e8 85 f7 ff ff       	call   80103640 <wakeup1>
80103ebb:	eb 11                	jmp    80103ece <exit+0xae>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec0:	81 c3 90 01 00 00    	add    $0x190,%ebx
80103ec6:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
80103ecc:	73 32                	jae    80103f00 <exit+0xe0>
    if(p->parent == curproc){
80103ece:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ed1:	75 ed                	jne    80103ec0 <exit+0xa0>
      while(p->state < 0){cprintf("neg_somthing %d  ", p->state);}
80103ed3:	8b 53 0c             	mov    0xc(%ebx),%edx
      if(p->state == ZOMBIE)
80103ed6:	8b 53 0c             	mov    0xc(%ebx),%edx
      p->parent = initproc;
80103ed9:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
      if(p->state == ZOMBIE)
80103ede:	83 fa 05             	cmp    $0x5,%edx
      p->parent = initproc;
80103ee1:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103ee4:	75 da                	jne    80103ec0 <exit+0xa0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee6:	81 c3 90 01 00 00    	add    $0x190,%ebx
        wakeup1(initproc);
80103eec:	e8 4f f7 ff ff       	call   80103640 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ef1:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
80103ef7:	72 d5                	jb     80103ece <exit+0xae>
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sched();
80103f00:	e8 7b fe ff ff       	call   80103d80 <sched>
  panic("zombie exit");
80103f05:	83 ec 0c             	sub    $0xc,%esp
80103f08:	68 ee 7c 10 80       	push   $0x80107cee
80103f0d:	e8 7e c4 ff ff       	call   80100390 <panic>
    cprintf("exit cas err %d\n",curproc->state);
80103f12:	8b 46 0c             	mov    0xc(%esi),%eax
80103f15:	52                   	push   %edx
80103f16:	52                   	push   %edx
80103f17:	50                   	push   %eax
80103f18:	68 dd 7c 10 80       	push   $0x80107cdd
80103f1d:	e8 3e c7 ff ff       	call   80100660 <cprintf>
80103f22:	83 c4 10             	add    $0x10,%esp
80103f25:	eb 87                	jmp    80103eae <exit+0x8e>
    panic("init exiting");
80103f27:	83 ec 0c             	sub    $0xc,%esp
80103f2a:	68 d0 7c 10 80       	push   $0x80107cd0
80103f2f:	e8 5c c4 ff ff       	call   80100390 <panic>
80103f34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f40 <wait>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	57                   	push   %edi
80103f44:	56                   	push   %esi
80103f45:	53                   	push   %ebx
80103f46:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103f49:	e8 62 0a 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80103f4e:	e8 0d f8 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80103f53:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103f59:	e8 92 0a 00 00       	call   801049f0 <popcli>
  pushcli();
80103f5e:	e8 4d 0a 00 00       	call   801049b0 <pushcli>
80103f63:	8d 47 0c             	lea    0xc(%edi),%eax
80103f66:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103f69:	b8 04 00 00 00       	mov    $0x4,%eax
80103f6e:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
80103f73:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103f76:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103f7a:	9c                   	pushf  
80103f7b:	8f 45 e4             	popl   -0x1c(%ebp)
    if(!cas(&curproc->state,RUNNING,-SLEEPING)){
80103f7e:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103f82:	0f 84 88 00 00 00    	je     80104010 <wait+0xd0>
{
80103f88:	31 c0                	xor    %eax,%eax
80103f8a:	be 54 3d 11 80       	mov    $0x80113d54,%esi
80103f8f:	b9 06 00 00 00       	mov    $0x6,%ecx
80103f94:	eb 18                	jmp    80103fae <wait+0x6e>
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa0:	81 c6 90 01 00 00    	add    $0x190,%esi
80103fa6:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
80103fac:	73 3d                	jae    80103feb <wait+0xab>
      if(p->parent != curproc)
80103fae:	39 7e 14             	cmp    %edi,0x14(%esi)
80103fb1:	75 ed                	jne    80103fa0 <wait+0x60>
80103fb3:	90                   	nop
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(p->state == -ZOMBIE);
80103fb8:	8b 46 0c             	mov    0xc(%esi),%eax
80103fbb:	83 f8 fb             	cmp    $0xfffffffb,%eax
80103fbe:	74 f8                	je     80103fb8 <wait+0x78>
80103fc0:	8d 56 0c             	lea    0xc(%esi),%edx
80103fc3:	b8 05 00 00 00       	mov    $0x5,%eax
80103fc8:	89 d3                	mov    %edx,%ebx
80103fca:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103fce:	9c                   	pushf  
80103fcf:	8f 45 e4             	popl   -0x1c(%ebp)
      if(cas(&p->state ,ZOMBIE, WAITING)){
80103fd2:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103fd6:	75 50                	jne    80104028 <wait+0xe8>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd8:	81 c6 90 01 00 00    	add    $0x190,%esi
      havekids = 1;
80103fde:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe3:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
80103fe9:	72 c3                	jb     80103fae <wait+0x6e>
    if(!havekids || curproc->killed){
80103feb:	85 c0                	test   %eax,%eax
80103fed:	0f 84 cc 00 00 00    	je     801040bf <wait+0x17f>
80103ff3:	8b 47 24             	mov    0x24(%edi),%eax
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	0f 85 c1 00 00 00    	jne    801040bf <wait+0x17f>
    curproc->chan = curproc;
80103ffe:	89 7f 20             	mov    %edi,0x20(%edi)
    sched();
80104001:	e8 7a fd ff ff       	call   80103d80 <sched>
    if(!cas(&curproc->state,RUNNING,-SLEEPING)){
80104006:	e9 5e ff ff ff       	jmp    80103f69 <wait+0x29>
8010400b:	90                   	nop
8010400c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("wait cas err1\n");
80104010:	83 ec 0c             	sub    $0xc,%esp
80104013:	68 fa 7c 10 80       	push   $0x80107cfa
80104018:	e8 43 c6 ff ff       	call   80100660 <cprintf>
8010401d:	83 c4 10             	add    $0x10,%esp
80104020:	e9 63 ff ff ff       	jmp    80103f88 <wait+0x48>
80104025:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	ff 76 08             	pushl  0x8(%esi)
8010402e:	89 55 d0             	mov    %edx,-0x30(%ebp)
        pid = p->pid;
80104031:	8b 7e 10             	mov    0x10(%esi),%edi
        kfree(p->kstack);
80104034:	e8 17 e3 ff ff       	call   80102350 <kfree>
        freevm(p->pgdir);
80104039:	5a                   	pop    %edx
8010403a:	ff 76 04             	pushl  0x4(%esi)
        p->kstack = 0;
8010403d:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80104044:	e8 77 33 00 00       	call   801073c0 <freevm>
        p->pid = 0;
80104049:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
80104050:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
80104057:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
        p->name[0] = 0;
8010405c:	c6 46 70 00          	movb   $0x0,0x70(%esi)
        p->killed = 0;
80104060:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
80104067:	b9 04 00 00 00       	mov    $0x4,%ecx
8010406c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
8010406f:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104073:	9c                   	pushf  
80104074:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&curproc->state,-SLEEPING,RUNNING)){
80104077:	83 c4 10             	add    $0x10,%esp
8010407a:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
8010407e:	8b 55 d0             	mov    -0x30(%ebp),%edx
80104081:	74 6b                	je     801040ee <wait+0x1ae>
80104083:	b8 06 00 00 00       	mov    $0x6,%eax
80104088:	31 c9                	xor    %ecx,%ecx
8010408a:	89 d3                	mov    %edx,%ebx
8010408c:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104090:	9c                   	pushf  
80104091:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&p->state,WAITING,UNUSED)){
80104094:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80104098:	74 0f                	je     801040a9 <wait+0x169>
        popcli();
8010409a:	e8 51 09 00 00       	call   801049f0 <popcli>
}
8010409f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040a2:	89 f8                	mov    %edi,%eax
801040a4:	5b                   	pop    %ebx
801040a5:	5e                   	pop    %esi
801040a6:	5f                   	pop    %edi
801040a7:	5d                   	pop    %ebp
801040a8:	c3                   	ret    
          cprintf("wait casa err 2 &d\n",p->state);
801040a9:	8b 46 0c             	mov    0xc(%esi),%eax
801040ac:	83 ec 08             	sub    $0x8,%esp
801040af:	50                   	push   %eax
801040b0:	68 1d 7d 10 80       	push   $0x80107d1d
801040b5:	e8 a6 c5 ff ff       	call   80100660 <cprintf>
801040ba:	83 c4 10             	add    $0x10,%esp
801040bd:	eb db                	jmp    8010409a <wait+0x15a>
801040bf:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801040c4:	ba 04 00 00 00       	mov    $0x4,%edx
801040c9:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801040cc:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801040d0:	9c                   	pushf  
801040d1:	8f 45 e4             	popl   -0x1c(%ebp)
      if(!cas(&curproc->state,-SLEEPING,RUNNING)){
801040d4:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801040d8:	74 33                	je     8010410d <wait+0x1cd>
      popcli();
801040da:	e8 11 09 00 00       	call   801049f0 <popcli>
}
801040df:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801040e2:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801040e7:	89 f8                	mov    %edi,%eax
801040e9:	5b                   	pop    %ebx
801040ea:	5e                   	pop    %esi
801040eb:	5f                   	pop    %edi
801040ec:	5d                   	pop    %ebp
801040ed:	c3                   	ret    
          cprintf("wait casa err 1 &d\n",p->state);
801040ee:	8b 46 0c             	mov    0xc(%esi),%eax
801040f1:	83 ec 08             	sub    $0x8,%esp
801040f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801040f7:	50                   	push   %eax
801040f8:	68 09 7d 10 80       	push   $0x80107d09
801040fd:	e8 5e c5 ff ff       	call   80100660 <cprintf>
80104102:	83 c4 10             	add    $0x10,%esp
80104105:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104108:	e9 76 ff ff ff       	jmp    80104083 <wait+0x143>
        cprintf("wait cas err2 %d\n",curproc->state);
8010410d:	8b 47 0c             	mov    0xc(%edi),%eax
80104110:	83 ec 08             	sub    $0x8,%esp
80104113:	50                   	push   %eax
80104114:	68 31 7d 10 80       	push   $0x80107d31
80104119:	e8 42 c5 ff ff       	call   80100660 <cprintf>
8010411e:	83 c4 10             	add    $0x10,%esp
80104121:	eb b7                	jmp    801040da <wait+0x19a>
80104123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80104137:	e8 74 08 00 00       	call   801049b0 <pushcli>
  pushcli();
8010413c:	e8 6f 08 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80104141:	e8 1a f6 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104146:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010414c:	e8 9f 08 00 00       	call   801049f0 <popcli>
80104151:	b8 04 00 00 00       	mov    $0x4,%eax
80104156:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  if(!cas(&myproc()->state,RUNNING, -RUNNABLE)){
8010415b:	83 c3 0c             	add    $0xc,%ebx
8010415e:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104162:	9c                   	pushf  
80104163:	8f 45 f4             	popl   -0xc(%ebp)
80104166:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
8010416a:	75 10                	jne    8010417c <yield+0x4c>
    cprintf("yeild cas err");
8010416c:	83 ec 0c             	sub    $0xc,%esp
8010416f:	68 43 7d 10 80       	push   $0x80107d43
80104174:	e8 e7 c4 ff ff       	call   80100660 <cprintf>
80104179:	83 c4 10             	add    $0x10,%esp
  sched();
8010417c:	e8 ff fb ff ff       	call   80103d80 <sched>
  popcli();
80104181:	e8 6a 08 00 00       	call   801049f0 <popcli>
}
80104186:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104189:	c9                   	leave  
8010418a:	c3                   	ret    
8010418b:	90                   	nop
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <sleep>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 1c             	sub    $0x1c,%esp
80104199:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pushcli();
8010419c:	e8 0f 08 00 00       	call   801049b0 <pushcli>
  c = mycpu();
801041a1:	e8 ba f5 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801041a6:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041ac:	e8 3f 08 00 00       	call   801049f0 <popcli>
  if(p == 0)
801041b1:	85 f6                	test   %esi,%esi
801041b3:	0f 84 86 00 00 00    	je     8010423f <sleep+0xaf>
  if(lk == 0)
801041b9:	85 ff                	test   %edi,%edi
801041bb:	74 75                	je     80104232 <sleep+0xa2>
  if(!cas(&p->state,RUNNING,-SLEEPING)){
801041bd:	8d 5e 0c             	lea    0xc(%esi),%ebx
801041c0:	b8 04 00 00 00       	mov    $0x4,%eax
801041c5:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
801041ca:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801041ce:	9c                   	pushf  
801041cf:	8f 45 e4             	popl   -0x1c(%ebp)
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d2:	81 ff 20 3d 11 80    	cmp    $0x80113d20,%edi
801041d8:	74 3e                	je     80104218 <sleep+0x88>
    pushcli();
801041da:	e8 d1 07 00 00       	call   801049b0 <pushcli>
    release(lk);
801041df:	83 ec 0c             	sub    $0xc,%esp
801041e2:	57                   	push   %edi
801041e3:	e8 58 09 00 00       	call   80104b40 <release>
  p->chan = chan;
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	89 46 20             	mov    %eax,0x20(%esi)
  sched();
801041ee:	e8 8d fb ff ff       	call   80103d80 <sched>
  p->chan = 0;
801041f3:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
    popcli();
801041fa:	e8 f1 07 00 00       	call   801049f0 <popcli>
    acquire(lk);
801041ff:	89 3c 24             	mov    %edi,(%esp)
80104202:	e8 79 08 00 00       	call   80104a80 <acquire>
80104207:	83 c4 10             	add    $0x10,%esp
}
8010420a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010420d:	5b                   	pop    %ebx
8010420e:	5e                   	pop    %esi
8010420f:	5f                   	pop    %edi
80104210:	5d                   	pop    %ebp
80104211:	c3                   	ret    
80104212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  p->chan = chan;
80104218:	8b 45 08             	mov    0x8(%ebp),%eax
8010421b:	89 46 20             	mov    %eax,0x20(%esi)
  sched();
8010421e:	e8 5d fb ff ff       	call   80103d80 <sched>
  p->chan = 0;
80104223:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
}
8010422a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010422d:	5b                   	pop    %ebx
8010422e:	5e                   	pop    %esi
8010422f:	5f                   	pop    %edi
80104230:	5d                   	pop    %ebp
80104231:	c3                   	ret    
    panic("sleep without lk");
80104232:	83 ec 0c             	sub    $0xc,%esp
80104235:	68 57 7d 10 80       	push   $0x80107d57
8010423a:	e8 51 c1 ff ff       	call   80100390 <panic>
    panic("sleep");
8010423f:	83 ec 0c             	sub    $0xc,%esp
80104242:	68 51 7d 10 80       	push   $0x80107d51
80104247:	e8 44 c1 ff ff       	call   80100390 <panic>
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104250 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 04             	sub    $0x4,%esp
80104257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010425a:	e8 51 07 00 00       	call   801049b0 <pushcli>
  wakeup1(chan);
8010425f:	89 d8                	mov    %ebx,%eax
80104261:	e8 da f3 ff ff       	call   80103640 <wakeup1>
  popcli();
}
80104266:	83 c4 04             	add    $0x4,%esp
80104269:	5b                   	pop    %ebx
8010426a:	5d                   	pop    %ebp
  popcli();
8010426b:	e9 80 07 00 00       	jmp    801049f0 <popcli>

80104270 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	57                   	push   %edi
80104274:	56                   	push   %esi
80104275:	53                   	push   %ebx
80104276:	83 ec 1c             	sub    $0x1c,%esp
80104279:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010427c:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *p;

  if(signum<0||signum>=32){
8010427f:	83 fb 1f             	cmp    $0x1f,%ebx
80104282:	0f 87 f2 00 00 00    	ja     8010437a <kill+0x10a>
    return -1;
  }

  // updating proc for new signal
  //acquire(&ptable.lock);
  pushcli();
80104288:	e8 23 07 00 00       	call   801049b0 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428d:	be 54 3d 11 80       	mov    $0x80113d54,%esi
80104292:	eb 16                	jmp    801042aa <kill+0x3a>
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	81 c6 90 01 00 00    	add    $0x190,%esi
8010429e:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
801042a4:	0f 83 be 00 00 00    	jae    80104368 <kill+0xf8>
    if(p->pid == pid && p->state !=UNUSED){
801042aa:	39 7e 10             	cmp    %edi,0x10(%esi)
801042ad:	75 e9                	jne    80104298 <kill+0x28>
801042af:	8b 46 0c             	mov    0xc(%esi),%eax
801042b2:	85 c0                	test   %eax,%eax
801042b4:	74 e2                	je     80104298 <kill+0x28>
      //p->killed = 1; TODO : add this to SIGKILL
      // Wake process from sleep if necessary.
      if(p->signalHandler[signum]==(void*)SIG_IGN){
801042b6:	8b 84 9e 0c 01 00 00 	mov    0x10c(%esi,%ebx,4),%eax
801042bd:	83 f8 01             	cmp    $0x1,%eax
801042c0:	74 28                	je     801042ea <kill+0x7a>
        popcli();
        return 0;
      }
      p->pendingSignals |= (1 << signum);
801042c2:	bf 01 00 00 00       	mov    $0x1,%edi
801042c7:	89 d9                	mov    %ebx,%ecx
801042c9:	d3 e7                	shl    %cl,%edi
801042cb:	09 be 80 00 00 00    	or     %edi,0x80(%esi)
      //check for unblockable sigs
      if(((signum==SIGKILL) || ((p->signalHandler == (void*)SIGKILL) && ((p->pendingSignals & (1 << signum)) != 0)))
801042d1:	83 fb 09             	cmp    $0x9,%ebx
801042d4:	74 23                	je     801042f9 <kill+0x89>
      &&((p->state == SLEEPING) || (p->state == -SLEEPING))){
        while(p->state == -SLEEPING){cprintf("neg sleeping in kill  ");}
        cas(&p->state, SLEEPING, RUNNABLE);
      }
        
      if(((signum==SIGCONT)&&p->signalHandler[signum]==(void*)SIG_DFL)||(p->signalHandler[signum]==(void*)SIGCONT)){
801042d6:	83 fb 13             	cmp    $0x13,%ebx
801042d9:	75 0a                	jne    801042e5 <kill+0x75>
801042db:	8b 96 58 01 00 00    	mov    0x158(%esi),%edx
801042e1:	85 d2                	test   %edx,%edx
801042e3:	74 6b                	je     80104350 <kill+0xe0>
801042e5:	83 f8 13             	cmp    $0x13,%eax
801042e8:	74 66                	je     80104350 <kill+0xe0>
        popcli();
801042ea:	e8 01 07 00 00       	call   801049f0 <popcli>
        return 0;
801042ef:	31 c0                	xor    %eax,%eax
    }
  }
  //release(&ptable.lock);
  popcli();
  return -1;
}
801042f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f4:	5b                   	pop    %ebx
801042f5:	5e                   	pop    %esi
801042f6:	5f                   	pop    %edi
801042f7:	5d                   	pop    %ebp
801042f8:	c3                   	ret    
      &&((p->state == SLEEPING) || (p->state == -SLEEPING))){
801042f9:	8b 56 0c             	mov    0xc(%esi),%edx
801042fc:	83 fa 02             	cmp    $0x2,%edx
801042ff:	74 08                	je     80104309 <kill+0x99>
80104301:	8b 56 0c             	mov    0xc(%esi),%edx
80104304:	83 fa fe             	cmp    $0xfffffffe,%edx
80104307:	75 dc                	jne    801042e5 <kill+0x75>
        while(p->state == -SLEEPING){cprintf("neg sleeping in kill  ");}
80104309:	8b 46 0c             	mov    0xc(%esi),%eax
8010430c:	83 f8 fe             	cmp    $0xfffffffe,%eax
8010430f:	75 1f                	jne    80104330 <kill+0xc0>
80104311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 68 7d 10 80       	push   $0x80107d68
80104320:	e8 3b c3 ff ff       	call   80100660 <cprintf>
80104325:	8b 46 0c             	mov    0xc(%esi),%eax
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	83 f8 fe             	cmp    $0xfffffffe,%eax
8010432e:	74 e8                	je     80104318 <kill+0xa8>
        cas(&p->state, SLEEPING, RUNNABLE);
80104330:	8d 5e 0c             	lea    0xc(%esi),%ebx
80104333:	b8 02 00 00 00       	mov    $0x2,%eax
80104338:	ba 03 00 00 00       	mov    $0x3,%edx
8010433d:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104341:	9c                   	pushf  
80104342:	8f 45 e4             	popl   -0x1c(%ebp)
80104345:	8b 86 30 01 00 00    	mov    0x130(%esi),%eax
      if(((signum==SIGCONT)&&p->signalHandler[signum]==(void*)SIG_DFL)||(p->signalHandler[signum]==(void*)SIGCONT)){
8010434b:	83 f8 13             	cmp    $0x13,%eax
8010434e:	75 9a                	jne    801042ea <kill+0x7a>
        if((p->signalMask & (1 << signum)) == 0){
80104350:	85 be 84 00 00 00    	test   %edi,0x84(%esi)
80104356:	75 92                	jne    801042ea <kill+0x7a>
          p->frozen=0;
80104358:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
8010435f:	eb 89                	jmp    801042ea <kill+0x7a>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  popcli();
80104368:	e8 83 06 00 00       	call   801049f0 <popcli>
}
8010436d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104375:	5b                   	pop    %ebx
80104376:	5e                   	pop    %esi
80104377:	5f                   	pop    %edi
80104378:	5d                   	pop    %ebp
80104379:	c3                   	ret    
    return -1;
8010437a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010437f:	e9 6d ff ff ff       	jmp    801042f1 <kill+0x81>
80104384:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010438a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104390 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	56                   	push   %esi
80104395:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104396:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010439b:	83 ec 3c             	sub    $0x3c,%esp
8010439e:	eb 22                	jmp    801043c2 <procdump+0x32>
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 03 81 10 80       	push   $0x80108103
801043a8:	e8 b3 c2 ff ff       	call   80100660 <cprintf>
801043ad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b0:	81 c3 90 01 00 00    	add    $0x190,%ebx
801043b6:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
801043bc:	0f 83 9e 00 00 00    	jae    80104460 <procdump+0xd0>
    if(p->state == UNUSED)
801043c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801043c5:	85 c0                	test   %eax,%eax
801043c7:	74 e7                	je     801043b0 <procdump+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043c9:	8b 43 0c             	mov    0xc(%ebx),%eax
801043cc:	8b 53 0c             	mov    0xc(%ebx),%edx
      state = "???";
801043cf:	b8 7f 7d 10 80       	mov    $0x80107d7f,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043d4:	83 fa 05             	cmp    $0x5,%edx
801043d7:	77 18                	ja     801043f1 <procdump+0x61>
801043d9:	8b 53 0c             	mov    0xc(%ebx),%edx
801043dc:	8b 14 95 e0 7d 10 80 	mov    -0x7fef8220(,%edx,4),%edx
801043e3:	85 d2                	test   %edx,%edx
801043e5:	74 0a                	je     801043f1 <procdump+0x61>
      state = states[p->state];
801043e7:	8b 43 0c             	mov    0xc(%ebx),%eax
801043ea:	8b 04 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801043f1:	8d 53 70             	lea    0x70(%ebx),%edx
801043f4:	52                   	push   %edx
801043f5:	50                   	push   %eax
801043f6:	ff 73 10             	pushl  0x10(%ebx)
801043f9:	68 83 7d 10 80       	push   $0x80107d83
801043fe:	e8 5d c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104403:	8b 43 0c             	mov    0xc(%ebx),%eax
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	83 f8 02             	cmp    $0x2,%eax
8010440c:	75 92                	jne    801043a0 <procdump+0x10>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010440e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104411:	83 ec 08             	sub    $0x8,%esp
80104414:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104417:	8d 7d e8             	lea    -0x18(%ebp),%edi
8010441a:	50                   	push   %eax
8010441b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010441e:	8b 40 0c             	mov    0xc(%eax),%eax
80104421:	83 c0 08             	add    $0x8,%eax
80104424:	50                   	push   %eax
80104425:	e8 36 05 00 00       	call   80104960 <getcallerpcs>
8010442a:	83 c4 10             	add    $0x10,%esp
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104430:	8b 16                	mov    (%esi),%edx
80104432:	85 d2                	test   %edx,%edx
80104434:	0f 84 66 ff ff ff    	je     801043a0 <procdump+0x10>
        cprintf(" %p", pc[i]);
8010443a:	83 ec 08             	sub    $0x8,%esp
8010443d:	83 c6 04             	add    $0x4,%esi
80104440:	52                   	push   %edx
80104441:	68 21 77 10 80       	push   $0x80107721
80104446:	e8 15 c2 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010444b:	83 c4 10             	add    $0x10,%esp
8010444e:	39 f7                	cmp    %esi,%edi
80104450:	75 de                	jne    80104430 <procdump+0xa0>
80104452:	e9 49 ff ff ff       	jmp    801043a0 <procdump+0x10>
80104457:	89 f6                	mov    %esi,%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
80104460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104463:	5b                   	pop    %ebx
80104464:	5e                   	pop    %esi
80104465:	5f                   	pop    %edi
80104466:	5d                   	pop    %ebp
80104467:	c3                   	ret    
80104468:	90                   	nop
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104470 <sigprocmask>:

uint 
sigprocmask(uint sigmask){
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
  pushcli();
80104475:	e8 36 05 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010447a:	e8 e1 f2 ff ff       	call   80103760 <mycpu>
  p = c->proc;
8010447f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104485:	e8 66 05 00 00       	call   801049f0 <popcli>
  uint oldMask = myproc()->signalMask;
8010448a:	8b 9b 84 00 00 00    	mov    0x84(%ebx),%ebx
  pushcli();
80104490:	e8 1b 05 00 00       	call   801049b0 <pushcli>
  c = mycpu();
80104495:	e8 c6 f2 ff ff       	call   80103760 <mycpu>
  p = c->proc;
8010449a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044a0:	e8 4b 05 00 00       	call   801049f0 <popcli>
  myproc()->signalMask = sigmask;
801044a5:	8b 45 08             	mov    0x8(%ebp),%eax
801044a8:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
  return oldMask;
}
801044ae:	89 d8                	mov    %ebx,%eax
801044b0:	5b                   	pop    %ebx
801044b1:	5e                   	pop    %esi
801044b2:	5d                   	pop    %ebp
801044b3:	c3                   	ret    
801044b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801044c0 <sigaction>:

int
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	53                   	push   %ebx
801044c6:	83 ec 0c             	sub    $0xc,%esp
801044c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
801044cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044cf:	e8 dc 04 00 00       	call   801049b0 <pushcli>
  c = mycpu();
801044d4:	e8 87 f2 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801044d9:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801044df:	e8 0c 05 00 00       	call   801049f0 <popcli>
  struct proc *p;
  p=myproc();
  if(oldact!=null){ // TODO change to NULL
801044e4:	85 db                	test   %ebx,%ebx
801044e6:	74 17                	je     801044ff <sigaction+0x3f>
801044e8:	8b 45 08             	mov    0x8(%ebp),%eax
801044eb:	8d 14 87             	lea    (%edi,%eax,4),%edx
    oldact->sa_handler = p->signalHandler[signum];
801044ee:	8b 8a 0c 01 00 00    	mov    0x10c(%edx),%ecx
801044f4:	89 0b                	mov    %ecx,(%ebx)
    oldact->sigmask = p->signalHandlerMasks[signum];
801044f6:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801044fc:	89 53 04             	mov    %edx,0x4(%ebx)
801044ff:	8b 45 08             	mov    0x8(%ebp),%eax
  } 

  p->signalHandler[signum] = act->sa_handler;
80104502:	8b 16                	mov    (%esi),%edx
80104504:	8d 04 87             	lea    (%edi,%eax,4),%eax
80104507:	89 90 0c 01 00 00    	mov    %edx,0x10c(%eax)
  p->signalHandlerMasks[signum] = act->sigmask;
8010450d:	8b 56 04             	mov    0x4(%esi),%edx
80104510:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

  return 0;
}
80104516:	83 c4 0c             	add    $0xc,%esp
80104519:	31 c0                	xor    %eax,%eax
8010451b:	5b                   	pop    %ebx
8010451c:	5e                   	pop    %esi
8010451d:	5f                   	pop    %edi
8010451e:	5d                   	pop    %ebp
8010451f:	c3                   	ret    

80104520 <sh_sigkill>:

/************************* SIGNAL HANDLERS *************************/
void 
sh_sigkill(){
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	53                   	push   %ebx
80104524:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104527:	e8 84 04 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010452c:	e8 2f f2 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104531:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104537:	e8 b4 04 00 00       	call   801049f0 <popcli>
  myproc()->killed = 1;
8010453c:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
80104543:	83 c4 04             	add    $0x4,%esp
80104546:	5b                   	pop    %ebx
80104547:	5d                   	pop    %ebp
80104548:	c3                   	ret    
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104550 <sh_sigstop>:

void
sh_sigstop(){
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104557:	e8 54 04 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010455c:	e8 ff f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104561:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104567:	e8 84 04 00 00       	call   801049f0 <popcli>
  myproc()->frozen = 1;
8010456c:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  yield();
}
80104573:	83 c4 04             	add    $0x4,%esp
80104576:	5b                   	pop    %ebx
80104577:	5d                   	pop    %ebp
  yield();
80104578:	e9 b3 fb ff ff       	jmp    80104130 <yield>
8010457d:	8d 76 00             	lea    0x0(%esi),%esi

80104580 <sh_sigcont>:

void
sh_sigcont(){
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104587:	e8 24 04 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010458c:	e8 cf f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104591:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104597:	e8 54 04 00 00       	call   801049f0 <popcli>
  myproc()->frozen = 0;
8010459c:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
801045a3:	83 c4 04             	add    $0x4,%esp
801045a6:	5b                   	pop    %ebx
801045a7:	5d                   	pop    %ebp
801045a8:	c3                   	ret    
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045b0 <sigret>:

void 
sigret(){
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
  pushcli();
801045b5:	e8 f6 03 00 00       	call   801049b0 <pushcli>
  c = mycpu();
801045ba:	e8 a1 f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801045bf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045c5:	e8 26 04 00 00       	call   801049f0 <popcli>
  pushcli();
801045ca:	e8 e1 03 00 00       	call   801049b0 <pushcli>
  c = mycpu();
801045cf:	e8 8c f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801045d4:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045da:	e8 11 04 00 00       	call   801049f0 <popcli>
  myproc()->signalMask=myproc()->signalMaskBU;
801045df:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
801045e5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  pushcli();
801045eb:	e8 c0 03 00 00       	call   801049b0 <pushcli>
  c = mycpu();
801045f0:	e8 6b f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
801045f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045fb:	e8 f0 03 00 00       	call   801049f0 <popcli>
  //memmove(&myproc()->signalMask, &myproc()->signalMaskBU, 4);
  memmove(myproc()->tf, myproc()->uTrapFrameBU, sizeof(struct trapframe));
80104600:	8b b3 8c 01 00 00    	mov    0x18c(%ebx),%esi
  pushcli();
80104606:	e8 a5 03 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010460b:	e8 50 f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104610:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104616:	e8 d5 03 00 00       	call   801049f0 <popcli>
  memmove(myproc()->tf, myproc()->uTrapFrameBU, sizeof(struct trapframe));
8010461b:	83 ec 04             	sub    $0x4,%esp
8010461e:	6a 4c                	push   $0x4c
80104620:	56                   	push   %esi
80104621:	ff 73 18             	pushl  0x18(%ebx)
80104624:	e8 17 06 00 00       	call   80104c40 <memmove>
}
80104629:	83 c4 10             	add    $0x10,%esp
8010462c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462f:	5b                   	pop    %ebx
80104630:	5e                   	pop    %esi
80104631:	5d                   	pop    %ebp
80104632:	c3                   	ret    
80104633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104640 <handle_signals>:

void
handle_signals(struct trapframe *tf){
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	57                   	push   %edi
80104644:	56                   	push   %esi
80104645:	53                   	push   %ebx
80104646:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104649:	e8 62 03 00 00       	call   801049b0 <pushcli>
  c = mycpu();
8010464e:	e8 0d f1 ff ff       	call   80103760 <mycpu>
  p = c->proc;
80104653:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104659:	e8 92 03 00 00       	call   801049f0 <popcli>
    struct proc* p = myproc();
    
    if(p == 0 || p == null){
8010465e:	85 f6                	test   %esi,%esi
80104660:	74 10                	je     80104672 <handle_signals+0x32>
      return;
    }
    if((tf->cs &3) != DPL_USER)
80104662:	8b 45 08             	mov    0x8(%ebp),%eax
80104665:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80104669:	83 e0 03             	and    $0x3,%eax
8010466c:	66 83 f8 03          	cmp    $0x3,%ax
80104670:	74 0e                	je     80104680 <handle_signals+0x40>
          return;

        }
      }
    }
80104672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104675:	5b                   	pop    %ebx
80104676:	5e                   	pop    %esi
80104677:	5f                   	pop    %edi
80104678:	5d                   	pop    %ebp
80104679:	c3                   	ret    
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->killed){
80104680:	8b 5e 24             	mov    0x24(%esi),%ebx
80104683:	85 db                	test   %ebx,%ebx
80104685:	75 eb                	jne    80104672 <handle_signals+0x32>
    for(int i = 0 ; (p->pendingSignals != 0) && i < 32 ; i++){   
80104687:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010468d:	85 c0                	test   %eax,%eax
8010468f:	75 67                	jne    801046f8 <handle_signals+0xb8>
80104691:	eb df                	jmp    80104672 <handle_signals+0x32>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->pendingSignals &= ~(1 << i);
80104698:	f7 d2                	not    %edx
8010469a:	21 c2                	and    %eax,%edx
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
8010469c:	83 ff 11             	cmp    $0x11,%edi
        p->pendingSignals &= ~(1 << i);
8010469f:	89 96 80 00 00 00    	mov    %edx,0x80(%esi)
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
801046a5:	0f 84 45 01 00 00    	je     801047f0 <handle_signals+0x1b0>
801046ab:	83 fb 11             	cmp    $0x11,%ebx
801046ae:	0f 84 3c 01 00 00    	je     801047f0 <handle_signals+0x1b0>
        }else if(p->signalHandler[i] == (void*)SIGCONT || (i == SIGCONT && p->signalHandler[i] == (void*)SIG_DFL)){
801046b4:	83 ff 13             	cmp    $0x13,%edi
801046b7:	0f 84 43 01 00 00    	je     80104800 <handle_signals+0x1c0>
801046bd:	85 ff                	test   %edi,%edi
801046bf:	0f 94 c0             	sete   %al
801046c2:	83 fb 13             	cmp    $0x13,%ebx
801046c5:	75 08                	jne    801046cf <handle_signals+0x8f>
801046c7:	84 c0                	test   %al,%al
801046c9:	0f 85 31 01 00 00    	jne    80104800 <handle_signals+0x1c0>
        }else if(p->signalHandler[i] == (void*)SIGKILL || p->signalHandler[i] == (void*)SIG_DFL){
801046cf:	83 ff 09             	cmp    $0x9,%edi
801046d2:	74 04                	je     801046d8 <handle_signals+0x98>
801046d4:	84 c0                	test   %al,%al
801046d6:	74 77                	je     8010474f <handle_signals+0x10f>
          sh_sigkill();
801046d8:	e8 43 fe ff ff       	call   80104520 <sh_sigkill>
801046dd:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
801046e3:	90                   	nop
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0 ; (p->pendingSignals != 0) && i < 32 ; i++){   
801046e8:	83 c3 01             	add    $0x1,%ebx
801046eb:	85 c0                	test   %eax,%eax
801046ed:	74 83                	je     80104672 <handle_signals+0x32>
801046ef:	83 fb 20             	cmp    $0x20,%ebx
801046f2:	0f 84 7a ff ff ff    	je     80104672 <handle_signals+0x32>
      if((p->pendingSignals & (1 << i)) != 0){
801046f8:	ba 01 00 00 00       	mov    $0x1,%edx
801046fd:	89 d9                	mov    %ebx,%ecx
801046ff:	d3 e2                	shl    %cl,%edx
80104701:	85 c2                	test   %eax,%edx
80104703:	74 e3                	je     801046e8 <handle_signals+0xa8>
        if(((p->signalMask & (1 << i)) != 0) && unblockable){
80104705:	8b be 84 00 00 00    	mov    0x84(%esi),%edi
      int unblockable = (i != SIGKILL) && (i != SIGSTOP);
8010470b:	8d 4b f7             	lea    -0x9(%ebx),%ecx
8010470e:	83 e1 f7             	and    $0xfffffff7,%ecx
        if(((p->signalMask & (1 << i)) != 0) && unblockable){
80104711:	85 d7                	test   %edx,%edi
80104713:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80104716:	74 04                	je     8010471c <handle_signals+0xdc>
80104718:	85 c9                	test   %ecx,%ecx
8010471a:	75 cc                	jne    801046e8 <handle_signals+0xa8>
      uint espbu = p->tf->esp;
8010471c:	8b 7e 18             	mov    0x18(%esi),%edi
8010471f:	89 7d e0             	mov    %edi,-0x20(%ebp)
80104722:	8b 7f 44             	mov    0x44(%edi),%edi
80104725:	89 7d dc             	mov    %edi,-0x24(%ebp)
        if(p->signalHandler[i]==(void*)SIG_IGN && unblockable){
80104728:	8b bc 9e 0c 01 00 00 	mov    0x10c(%esi,%ebx,4),%edi
8010472f:	83 ff 01             	cmp    $0x1,%edi
80104732:	0f 85 60 ff ff ff    	jne    80104698 <handle_signals+0x58>
80104738:	85 c9                	test   %ecx,%ecx
8010473a:	75 ac                	jne    801046e8 <handle_signals+0xa8>
        p->pendingSignals &= ~(1 << i);
8010473c:	f7 d2                	not    %edx
8010473e:	21 c2                	and    %eax,%edx
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
80104740:	83 fb 11             	cmp    $0x11,%ebx
        p->pendingSignals &= ~(1 << i);
80104743:	89 96 80 00 00 00    	mov    %edx,0x80(%esi)
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
80104749:	0f 84 a1 00 00 00    	je     801047f0 <handle_signals+0x1b0>
          p->signalMaskBU=p->signalMask;
8010474f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104752:	8d 3c 9e             	lea    (%esi,%ebx,4),%edi
          memmove(p->uTrapFrameBU, p->tf, sizeof(struct trapframe));
80104755:	83 ec 04             	sub    $0x4,%esp
          p->signalMaskBU=p->signalMask;
80104758:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
          p->signalMask = p->signalHandlerMasks[i];
8010475e:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
80104764:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
          p->tf->esp -= sizeof (struct trapframe);
8010476a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010476d:	83 68 44 4c          	subl   $0x4c,0x44(%eax)
          p->uTrapFrameBU = (void*) (p->tf->esp);
80104771:	8b 56 18             	mov    0x18(%esi),%edx
80104774:	8b 42 44             	mov    0x44(%edx),%eax
80104777:	89 86 8c 01 00 00    	mov    %eax,0x18c(%esi)
          memmove(p->uTrapFrameBU, p->tf, sizeof(struct trapframe));
8010477d:	6a 4c                	push   $0x4c
8010477f:	52                   	push   %edx
80104780:	50                   	push   %eax
80104781:	e8 ba 04 00 00       	call   80104c40 <memmove>
          p->uTrapFrameBU->esp=espbu;
80104786:	8b 86 8c 01 00 00    	mov    0x18c(%esi),%eax
8010478c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
          memmove((void*)p->tf->esp,sigret_start, (uint)&sigret_end - (uint)&sigret_start);
8010478f:	83 c4 0c             	add    $0xc,%esp
          p->uTrapFrameBU->esp=espbu;
80104792:	89 48 44             	mov    %ecx,0x44(%eax)
          p->tf->esp -= (uint)&sigret_end - (uint)&sigret_start;
80104795:	8b 56 18             	mov    0x18(%esi),%edx
80104798:	b8 4e 22 10 80       	mov    $0x8010224e,%eax
8010479d:	2d 55 22 10 80       	sub    $0x80102255,%eax
801047a2:	01 42 44             	add    %eax,0x44(%edx)
          memmove((void*)p->tf->esp,sigret_start, (uint)&sigret_end - (uint)&sigret_start);
801047a5:	b8 55 22 10 80       	mov    $0x80102255,%eax
801047aa:	2d 4e 22 10 80       	sub    $0x8010224e,%eax
801047af:	50                   	push   %eax
801047b0:	68 4e 22 10 80       	push   $0x8010224e
801047b5:	8b 46 18             	mov    0x18(%esi),%eax
801047b8:	ff 70 44             	pushl  0x44(%eax)
801047bb:	e8 80 04 00 00       	call   80104c40 <memmove>
          *((int*)(p->tf->esp-4)) = i;
801047c0:	8b 46 18             	mov    0x18(%esi),%eax
          return;
801047c3:	83 c4 10             	add    $0x10,%esp
          *((int*)(p->tf->esp-4)) = i;
801047c6:	8b 40 44             	mov    0x44(%eax),%eax
801047c9:	89 58 fc             	mov    %ebx,-0x4(%eax)
          *((int*)(p->tf->esp-8)) = p->tf->esp;
801047cc:	8b 46 18             	mov    0x18(%esi),%eax
801047cf:	8b 40 44             	mov    0x44(%eax),%eax
801047d2:	89 40 f8             	mov    %eax,-0x8(%eax)
          p->tf->esp -= 8;
801047d5:	8b 46 18             	mov    0x18(%esi),%eax
801047d8:	83 68 44 08          	subl   $0x8,0x44(%eax)
          p->tf->eip = (uint)p->signalHandler[i];
801047dc:	8b 46 18             	mov    0x18(%esi),%eax
801047df:	8b 97 0c 01 00 00    	mov    0x10c(%edi),%edx
801047e5:	89 50 38             	mov    %edx,0x38(%eax)
          return;
801047e8:	e9 85 fe ff ff       	jmp    80104672 <handle_signals+0x32>
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
          sh_sigstop();
801047f0:	e8 5b fd ff ff       	call   80104550 <sh_sigstop>
801047f5:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
801047fb:	e9 e8 fe ff ff       	jmp    801046e8 <handle_signals+0xa8>
          sh_sigcont();
80104800:	e8 7b fd ff ff       	call   80104580 <sh_sigcont>
80104805:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010480b:	e9 d8 fe ff ff       	jmp    801046e8 <handle_signals+0xa8>

80104810 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 0c             	sub    $0xc,%esp
80104817:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010481a:	68 f8 7d 10 80       	push   $0x80107df8
8010481f:	8d 43 04             	lea    0x4(%ebx),%eax
80104822:	50                   	push   %eax
80104823:	e8 18 01 00 00       	call   80104940 <initlock>
  lk->name = name;
80104828:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010482b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104831:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104834:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010483b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	c9                   	leave  
80104842:	c3                   	ret    
80104843:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104858:	83 ec 0c             	sub    $0xc,%esp
8010485b:	8d 73 04             	lea    0x4(%ebx),%esi
8010485e:	56                   	push   %esi
8010485f:	e8 1c 02 00 00       	call   80104a80 <acquire>
  while (lk->locked) {
80104864:	8b 13                	mov    (%ebx),%edx
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 d2                	test   %edx,%edx
8010486b:	74 16                	je     80104883 <acquiresleep+0x33>
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104870:	83 ec 08             	sub    $0x8,%esp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	e8 16 f9 ff ff       	call   80104190 <sleep>
  while (lk->locked) {
8010487a:	8b 03                	mov    (%ebx),%eax
8010487c:	83 c4 10             	add    $0x10,%esp
8010487f:	85 c0                	test   %eax,%eax
80104881:	75 ed                	jne    80104870 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104883:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104889:	e8 72 ef ff ff       	call   80103800 <myproc>
8010488e:	8b 40 10             	mov    0x10(%eax),%eax
80104891:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104894:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104897:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010489a:	5b                   	pop    %ebx
8010489b:	5e                   	pop    %esi
8010489c:	5d                   	pop    %ebp
  release(&lk->lk);
8010489d:	e9 9e 02 00 00       	jmp    80104b40 <release>
801048a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	8d 73 04             	lea    0x4(%ebx),%esi
801048be:	56                   	push   %esi
801048bf:	e8 bc 01 00 00       	call   80104a80 <acquire>
  lk->locked = 0;
801048c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048d1:	89 1c 24             	mov    %ebx,(%esp)
801048d4:	e8 77 f9 ff ff       	call   80104250 <wakeup>
  release(&lk->lk);
801048d9:	89 75 08             	mov    %esi,0x8(%ebp)
801048dc:	83 c4 10             	add    $0x10,%esp
}
801048df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e2:	5b                   	pop    %ebx
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
  release(&lk->lk);
801048e5:	e9 56 02 00 00       	jmp    80104b40 <release>
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	31 ff                	xor    %edi,%edi
801048f8:	83 ec 18             	sub    $0x18,%esp
801048fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104901:	56                   	push   %esi
80104902:	e8 79 01 00 00       	call   80104a80 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104907:	8b 03                	mov    (%ebx),%eax
80104909:	83 c4 10             	add    $0x10,%esp
8010490c:	85 c0                	test   %eax,%eax
8010490e:	74 13                	je     80104923 <holdingsleep+0x33>
80104910:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104913:	e8 e8 ee ff ff       	call   80103800 <myproc>
80104918:	39 58 10             	cmp    %ebx,0x10(%eax)
8010491b:	0f 94 c0             	sete   %al
8010491e:	0f b6 c0             	movzbl %al,%eax
80104921:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104923:	83 ec 0c             	sub    $0xc,%esp
80104926:	56                   	push   %esi
80104927:	e8 14 02 00 00       	call   80104b40 <release>
  return r;
}
8010492c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010492f:	89 f8                	mov    %edi,%eax
80104931:	5b                   	pop    %ebx
80104932:	5e                   	pop    %esi
80104933:	5f                   	pop    %edi
80104934:	5d                   	pop    %ebp
80104935:	c3                   	ret    
80104936:	66 90                	xchg   %ax,%ax
80104938:	66 90                	xchg   %ax,%ax
8010493a:	66 90                	xchg   %ax,%ax
8010493c:	66 90                	xchg   %ax,%ax
8010493e:	66 90                	xchg   %ax,%ax

80104940 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104946:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010494f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104959:	5d                   	pop    %ebp
8010495a:	c3                   	ret    
8010495b:	90                   	nop
8010495c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104960 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104960:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104961:	31 d2                	xor    %edx,%edx
{
80104963:	89 e5                	mov    %esp,%ebp
80104965:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104966:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010496c:	83 e8 08             	sub    $0x8,%eax
8010496f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104970:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104976:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010497c:	77 1a                	ja     80104998 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010497e:	8b 58 04             	mov    0x4(%eax),%ebx
80104981:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104984:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104987:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104989:	83 fa 0a             	cmp    $0xa,%edx
8010498c:	75 e2                	jne    80104970 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010498e:	5b                   	pop    %ebx
8010498f:	5d                   	pop    %ebp
80104990:	c3                   	ret    
80104991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104998:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010499b:	83 c1 28             	add    $0x28,%ecx
8010499e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049a9:	39 c1                	cmp    %eax,%ecx
801049ab:	75 f3                	jne    801049a0 <getcallerpcs+0x40>
}
801049ad:	5b                   	pop    %ebx
801049ae:	5d                   	pop    %ebp
801049af:	c3                   	ret    

801049b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049b7:	9c                   	pushf  
801049b8:	5b                   	pop    %ebx
  asm volatile("cli");
801049b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ba:	e8 a1 ed ff ff       	call   80103760 <mycpu>
801049bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049c5:	85 c0                	test   %eax,%eax
801049c7:	75 11                	jne    801049da <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801049c9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801049cf:	e8 8c ed ff ff       	call   80103760 <mycpu>
801049d4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049da:	e8 81 ed ff ff       	call   80103760 <mycpu>
801049df:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049e6:	83 c4 04             	add    $0x4,%esp
801049e9:	5b                   	pop    %ebx
801049ea:	5d                   	pop    %ebp
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <popcli>:

void
popcli(void)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049f6:	9c                   	pushf  
801049f7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049f8:	f6 c4 02             	test   $0x2,%ah
801049fb:	75 35                	jne    80104a32 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049fd:	e8 5e ed ff ff       	call   80103760 <mycpu>
80104a02:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a09:	78 34                	js     80104a3f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a0b:	e8 50 ed ff ff       	call   80103760 <mycpu>
80104a10:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a16:	85 d2                	test   %edx,%edx
80104a18:	74 06                	je     80104a20 <popcli+0x30>
    sti();
}
80104a1a:	c9                   	leave  
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a20:	e8 3b ed ff ff       	call   80103760 <mycpu>
80104a25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a2b:	85 c0                	test   %eax,%eax
80104a2d:	74 eb                	je     80104a1a <popcli+0x2a>
  asm volatile("sti");
80104a2f:	fb                   	sti    
}
80104a30:	c9                   	leave  
80104a31:	c3                   	ret    
    panic("popcli - interruptible");
80104a32:	83 ec 0c             	sub    $0xc,%esp
80104a35:	68 03 7e 10 80       	push   $0x80107e03
80104a3a:	e8 51 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a3f:	83 ec 0c             	sub    $0xc,%esp
80104a42:	68 1a 7e 10 80       	push   $0x80107e1a
80104a47:	e8 44 b9 ff ff       	call   80100390 <panic>
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <holding>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 75 08             	mov    0x8(%ebp),%esi
80104a58:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a5a:	e8 51 ff ff ff       	call   801049b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a5f:	8b 06                	mov    (%esi),%eax
80104a61:	85 c0                	test   %eax,%eax
80104a63:	74 10                	je     80104a75 <holding+0x25>
80104a65:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a68:	e8 f3 ec ff ff       	call   80103760 <mycpu>
80104a6d:	39 c3                	cmp    %eax,%ebx
80104a6f:	0f 94 c3             	sete   %bl
80104a72:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a75:	e8 76 ff ff ff       	call   801049f0 <popcli>
}
80104a7a:	89 d8                	mov    %ebx,%eax
80104a7c:	5b                   	pop    %ebx
80104a7d:	5e                   	pop    %esi
80104a7e:	5d                   	pop    %ebp
80104a7f:	c3                   	ret    

80104a80 <acquire>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a85:	e8 26 ff ff ff       	call   801049b0 <pushcli>
  if(holding(lk))
80104a8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a8d:	83 ec 0c             	sub    $0xc,%esp
80104a90:	53                   	push   %ebx
80104a91:	e8 ba ff ff ff       	call   80104a50 <holding>
80104a96:	83 c4 10             	add    $0x10,%esp
80104a99:	85 c0                	test   %eax,%eax
80104a9b:	0f 85 83 00 00 00    	jne    80104b24 <acquire+0xa4>
80104aa1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104aa3:	ba 01 00 00 00       	mov    $0x1,%edx
80104aa8:	eb 09                	jmp    80104ab3 <acquire+0x33>
80104aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ab0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ab3:	89 d0                	mov    %edx,%eax
80104ab5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ab8:	85 c0                	test   %eax,%eax
80104aba:	75 f4                	jne    80104ab0 <acquire+0x30>
  __sync_synchronize();
80104abc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ac4:	e8 97 ec ff ff       	call   80103760 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104ac9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104acc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104acf:	89 e8                	mov    %ebp,%eax
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ad8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104ade:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ae4:	77 1a                	ja     80104b00 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ae6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ae9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104aec:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104aef:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104af1:	83 fe 0a             	cmp    $0xa,%esi
80104af4:	75 e2                	jne    80104ad8 <acquire+0x58>
}
80104af6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af9:	5b                   	pop    %ebx
80104afa:	5e                   	pop    %esi
80104afb:	5d                   	pop    %ebp
80104afc:	c3                   	ret    
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
80104b00:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104b03:	83 c2 28             	add    $0x28,%edx
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104b10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b16:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b19:	39 d0                	cmp    %edx,%eax
80104b1b:	75 f3                	jne    80104b10 <acquire+0x90>
}
80104b1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b20:	5b                   	pop    %ebx
80104b21:	5e                   	pop    %esi
80104b22:	5d                   	pop    %ebp
80104b23:	c3                   	ret    
    panic("acquire");
80104b24:	83 ec 0c             	sub    $0xc,%esp
80104b27:	68 21 7e 10 80       	push   $0x80107e21
80104b2c:	e8 5f b8 ff ff       	call   80100390 <panic>
80104b31:	eb 0d                	jmp    80104b40 <release>
80104b33:	90                   	nop
80104b34:	90                   	nop
80104b35:	90                   	nop
80104b36:	90                   	nop
80104b37:	90                   	nop
80104b38:	90                   	nop
80104b39:	90                   	nop
80104b3a:	90                   	nop
80104b3b:	90                   	nop
80104b3c:	90                   	nop
80104b3d:	90                   	nop
80104b3e:	90                   	nop
80104b3f:	90                   	nop

80104b40 <release>:
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	53                   	push   %ebx
80104b44:	83 ec 10             	sub    $0x10,%esp
80104b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b4a:	53                   	push   %ebx
80104b4b:	e8 00 ff ff ff       	call   80104a50 <holding>
80104b50:	83 c4 10             	add    $0x10,%esp
80104b53:	85 c0                	test   %eax,%eax
80104b55:	74 22                	je     80104b79 <release+0x39>
  lk->pcs[0] = 0;
80104b57:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b5e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b65:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b6a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b73:	c9                   	leave  
  popcli();
80104b74:	e9 77 fe ff ff       	jmp    801049f0 <popcli>
    panic("release");
80104b79:	83 ec 0c             	sub    $0xc,%esp
80104b7c:	68 29 7e 10 80       	push   $0x80107e29
80104b81:	e8 0a b8 ff ff       	call   80100390 <panic>
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	53                   	push   %ebx
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
80104b98:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b9b:	f6 c2 03             	test   $0x3,%dl
80104b9e:	75 05                	jne    80104ba5 <memset+0x15>
80104ba0:	f6 c1 03             	test   $0x3,%cl
80104ba3:	74 13                	je     80104bb8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ba5:	89 d7                	mov    %edx,%edi
80104ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104baa:	fc                   	cld    
80104bab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104bad:	5b                   	pop    %ebx
80104bae:	89 d0                	mov    %edx,%eax
80104bb0:	5f                   	pop    %edi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	90                   	nop
80104bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104bb8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104bbc:	c1 e9 02             	shr    $0x2,%ecx
80104bbf:	89 f8                	mov    %edi,%eax
80104bc1:	89 fb                	mov    %edi,%ebx
80104bc3:	c1 e0 18             	shl    $0x18,%eax
80104bc6:	c1 e3 10             	shl    $0x10,%ebx
80104bc9:	09 d8                	or     %ebx,%eax
80104bcb:	09 f8                	or     %edi,%eax
80104bcd:	c1 e7 08             	shl    $0x8,%edi
80104bd0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104bd2:	89 d7                	mov    %edx,%edi
80104bd4:	fc                   	cld    
80104bd5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104bd7:	5b                   	pop    %ebx
80104bd8:	89 d0                	mov    %edx,%eax
80104bda:	5f                   	pop    %edi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret    
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi

80104be0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
80104be5:	53                   	push   %ebx
80104be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104be9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bef:	85 db                	test   %ebx,%ebx
80104bf1:	74 29                	je     80104c1c <memcmp+0x3c>
    if(*s1 != *s2)
80104bf3:	0f b6 16             	movzbl (%esi),%edx
80104bf6:	0f b6 0f             	movzbl (%edi),%ecx
80104bf9:	38 d1                	cmp    %dl,%cl
80104bfb:	75 2b                	jne    80104c28 <memcmp+0x48>
80104bfd:	b8 01 00 00 00       	mov    $0x1,%eax
80104c02:	eb 14                	jmp    80104c18 <memcmp+0x38>
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c08:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104c0c:	83 c0 01             	add    $0x1,%eax
80104c0f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104c14:	38 ca                	cmp    %cl,%dl
80104c16:	75 10                	jne    80104c28 <memcmp+0x48>
  while(n-- > 0){
80104c18:	39 d8                	cmp    %ebx,%eax
80104c1a:	75 ec                	jne    80104c08 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104c1c:	5b                   	pop    %ebx
  return 0;
80104c1d:	31 c0                	xor    %eax,%eax
}
80104c1f:	5e                   	pop    %esi
80104c20:	5f                   	pop    %edi
80104c21:	5d                   	pop    %ebp
80104c22:	c3                   	ret    
80104c23:	90                   	nop
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104c28:	0f b6 c2             	movzbl %dl,%eax
}
80104c2b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104c2c:	29 c8                	sub    %ecx,%eax
}
80104c2e:	5e                   	pop    %esi
80104c2f:	5f                   	pop    %edi
80104c30:	5d                   	pop    %ebp
80104c31:	c3                   	ret    
80104c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 45 08             	mov    0x8(%ebp),%eax
80104c48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c4b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c4e:	39 c3                	cmp    %eax,%ebx
80104c50:	73 26                	jae    80104c78 <memmove+0x38>
80104c52:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c55:	39 c8                	cmp    %ecx,%eax
80104c57:	73 1f                	jae    80104c78 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c59:	85 f6                	test   %esi,%esi
80104c5b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c5e:	74 0f                	je     80104c6f <memmove+0x2f>
      *--d = *--s;
80104c60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104c67:	83 ea 01             	sub    $0x1,%edx
80104c6a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c6d:	75 f1                	jne    80104c60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	90                   	nop
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104c78:	31 d2                	xor    %edx,%edx
80104c7a:	85 f6                	test   %esi,%esi
80104c7c:	74 f1                	je     80104c6f <memmove+0x2f>
80104c7e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104c80:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c84:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c87:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104c8a:	39 d6                	cmp    %edx,%esi
80104c8c:	75 f2                	jne    80104c80 <memmove+0x40>
}
80104c8e:	5b                   	pop    %ebx
80104c8f:	5e                   	pop    %esi
80104c90:	5d                   	pop    %ebp
80104c91:	c3                   	ret    
80104c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104ca3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104ca4:	eb 9a                	jmp    80104c40 <memmove>
80104ca6:	8d 76 00             	lea    0x0(%esi),%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
80104cb5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104cb8:	53                   	push   %ebx
80104cb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104cbf:	85 ff                	test   %edi,%edi
80104cc1:	74 2f                	je     80104cf2 <strncmp+0x42>
80104cc3:	0f b6 01             	movzbl (%ecx),%eax
80104cc6:	0f b6 1e             	movzbl (%esi),%ebx
80104cc9:	84 c0                	test   %al,%al
80104ccb:	74 37                	je     80104d04 <strncmp+0x54>
80104ccd:	38 c3                	cmp    %al,%bl
80104ccf:	75 33                	jne    80104d04 <strncmp+0x54>
80104cd1:	01 f7                	add    %esi,%edi
80104cd3:	eb 13                	jmp    80104ce8 <strncmp+0x38>
80104cd5:	8d 76 00             	lea    0x0(%esi),%esi
80104cd8:	0f b6 01             	movzbl (%ecx),%eax
80104cdb:	84 c0                	test   %al,%al
80104cdd:	74 21                	je     80104d00 <strncmp+0x50>
80104cdf:	0f b6 1a             	movzbl (%edx),%ebx
80104ce2:	89 d6                	mov    %edx,%esi
80104ce4:	38 d8                	cmp    %bl,%al
80104ce6:	75 1c                	jne    80104d04 <strncmp+0x54>
    n--, p++, q++;
80104ce8:	8d 56 01             	lea    0x1(%esi),%edx
80104ceb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cee:	39 fa                	cmp    %edi,%edx
80104cf0:	75 e6                	jne    80104cd8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cf2:	5b                   	pop    %ebx
    return 0;
80104cf3:	31 c0                	xor    %eax,%eax
}
80104cf5:	5e                   	pop    %esi
80104cf6:	5f                   	pop    %edi
80104cf7:	5d                   	pop    %ebp
80104cf8:	c3                   	ret    
80104cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d00:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104d04:	29 d8                	sub    %ebx,%eax
}
80104d06:	5b                   	pop    %ebx
80104d07:	5e                   	pop    %esi
80104d08:	5f                   	pop    %edi
80104d09:	5d                   	pop    %ebp
80104d0a:	c3                   	ret    
80104d0b:	90                   	nop
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	56                   	push   %esi
80104d14:	53                   	push   %ebx
80104d15:	8b 45 08             	mov    0x8(%ebp),%eax
80104d18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d1e:	89 c2                	mov    %eax,%edx
80104d20:	eb 19                	jmp    80104d3b <strncpy+0x2b>
80104d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d28:	83 c3 01             	add    $0x1,%ebx
80104d2b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104d2f:	83 c2 01             	add    $0x1,%edx
80104d32:	84 c9                	test   %cl,%cl
80104d34:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d37:	74 09                	je     80104d42 <strncpy+0x32>
80104d39:	89 f1                	mov    %esi,%ecx
80104d3b:	85 c9                	test   %ecx,%ecx
80104d3d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d40:	7f e6                	jg     80104d28 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d42:	31 c9                	xor    %ecx,%ecx
80104d44:	85 f6                	test   %esi,%esi
80104d46:	7e 17                	jle    80104d5f <strncpy+0x4f>
80104d48:	90                   	nop
80104d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d50:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d54:	89 f3                	mov    %esi,%ebx
80104d56:	83 c1 01             	add    $0x1,%ecx
80104d59:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104d5b:	85 db                	test   %ebx,%ebx
80104d5d:	7f f1                	jg     80104d50 <strncpy+0x40>
  return os;
}
80104d5f:	5b                   	pop    %ebx
80104d60:	5e                   	pop    %esi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d78:	8b 45 08             	mov    0x8(%ebp),%eax
80104d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d7e:	85 c9                	test   %ecx,%ecx
80104d80:	7e 26                	jle    80104da8 <safestrcpy+0x38>
80104d82:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d86:	89 c1                	mov    %eax,%ecx
80104d88:	eb 17                	jmp    80104da1 <safestrcpy+0x31>
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d90:	83 c2 01             	add    $0x1,%edx
80104d93:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d97:	83 c1 01             	add    $0x1,%ecx
80104d9a:	84 db                	test   %bl,%bl
80104d9c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d9f:	74 04                	je     80104da5 <safestrcpy+0x35>
80104da1:	39 f2                	cmp    %esi,%edx
80104da3:	75 eb                	jne    80104d90 <safestrcpy+0x20>
    ;
  *s = 0;
80104da5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104da8:	5b                   	pop    %ebx
80104da9:	5e                   	pop    %esi
80104daa:	5d                   	pop    %ebp
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104db0 <strlen>:

int
strlen(const char *s)
{
80104db0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104db8:	80 3a 00             	cmpb   $0x0,(%edx)
80104dbb:	74 0c                	je     80104dc9 <strlen+0x19>
80104dbd:	8d 76 00             	lea    0x0(%esi),%esi
80104dc0:	83 c0 01             	add    $0x1,%eax
80104dc3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104dc7:	75 f7                	jne    80104dc0 <strlen+0x10>
    ;
  return n;
}
80104dc9:	5d                   	pop    %ebp
80104dca:	c3                   	ret    

80104dcb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104dcb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104dcf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104dd3:	55                   	push   %ebp
  pushl %ebx
80104dd4:	53                   	push   %ebx
  pushl %esi
80104dd5:	56                   	push   %esi
  pushl %edi
80104dd6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104dd7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104dd9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104ddb:	5f                   	pop    %edi
  popl %esi
80104ddc:	5e                   	pop    %esi
  popl %ebx
80104ddd:	5b                   	pop    %ebx
  popl %ebp
80104dde:	5d                   	pop    %ebp
  ret
80104ddf:	c3                   	ret    

80104de0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
80104de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dea:	e8 11 ea ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104def:	8b 00                	mov    (%eax),%eax
80104df1:	39 d8                	cmp    %ebx,%eax
80104df3:	76 1b                	jbe    80104e10 <fetchint+0x30>
80104df5:	8d 53 04             	lea    0x4(%ebx),%edx
80104df8:	39 d0                	cmp    %edx,%eax
80104dfa:	72 14                	jb     80104e10 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dff:	8b 13                	mov    (%ebx),%edx
80104e01:	89 10                	mov    %edx,(%eax)
  return 0;
80104e03:	31 c0                	xor    %eax,%eax
}
80104e05:	83 c4 04             	add    $0x4,%esp
80104e08:	5b                   	pop    %ebx
80104e09:	5d                   	pop    %ebp
80104e0a:	c3                   	ret    
80104e0b:	90                   	nop
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e15:	eb ee                	jmp    80104e05 <fetchint+0x25>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
80104e24:	83 ec 04             	sub    $0x4,%esp
80104e27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e2a:	e8 d1 e9 ff ff       	call   80103800 <myproc>

  if(addr >= curproc->sz)
80104e2f:	39 18                	cmp    %ebx,(%eax)
80104e31:	76 29                	jbe    80104e5c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e36:	89 da                	mov    %ebx,%edx
80104e38:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e3a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e3c:	39 c3                	cmp    %eax,%ebx
80104e3e:	73 1c                	jae    80104e5c <fetchstr+0x3c>
    if(*s == 0)
80104e40:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e43:	75 10                	jne    80104e55 <fetchstr+0x35>
80104e45:	eb 39                	jmp    80104e80 <fetchstr+0x60>
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e50:	80 3a 00             	cmpb   $0x0,(%edx)
80104e53:	74 1b                	je     80104e70 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104e55:	83 c2 01             	add    $0x1,%edx
80104e58:	39 d0                	cmp    %edx,%eax
80104e5a:	77 f4                	ja     80104e50 <fetchstr+0x30>
    return -1;
80104e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104e61:	83 c4 04             	add    $0x4,%esp
80104e64:	5b                   	pop    %ebx
80104e65:	5d                   	pop    %ebp
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e70:	83 c4 04             	add    $0x4,%esp
80104e73:	89 d0                	mov    %edx,%eax
80104e75:	29 d8                	sub    %ebx,%eax
80104e77:	5b                   	pop    %ebx
80104e78:	5d                   	pop    %ebp
80104e79:	c3                   	ret    
80104e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104e80:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104e82:	eb dd                	jmp    80104e61 <fetchstr+0x41>
80104e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	56                   	push   %esi
80104e94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e95:	e8 66 e9 ff ff       	call   80103800 <myproc>
80104e9a:	8b 40 18             	mov    0x18(%eax),%eax
80104e9d:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea0:	8b 40 44             	mov    0x44(%eax),%eax
80104ea3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ea6:	e8 55 e9 ff ff       	call   80103800 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eab:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ead:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eb0:	39 c6                	cmp    %eax,%esi
80104eb2:	73 1c                	jae    80104ed0 <argint+0x40>
80104eb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104eb7:	39 d0                	cmp    %edx,%eax
80104eb9:	72 15                	jb     80104ed0 <argint+0x40>
  *ip = *(int*)(addr);
80104ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebe:	8b 53 04             	mov    0x4(%ebx),%edx
80104ec1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	5b                   	pop    %ebx
80104ec6:	5e                   	pop    %esi
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    
80104ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ed5:	eb ee                	jmp    80104ec5 <argint+0x35>
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	83 ec 10             	sub    $0x10,%esp
80104ee8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104eeb:	e8 10 e9 ff ff       	call   80103800 <myproc>
80104ef0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ef2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef5:	83 ec 08             	sub    $0x8,%esp
80104ef8:	50                   	push   %eax
80104ef9:	ff 75 08             	pushl  0x8(%ebp)
80104efc:	e8 8f ff ff ff       	call   80104e90 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	85 c0                	test   %eax,%eax
80104f06:	78 28                	js     80104f30 <argptr+0x50>
80104f08:	85 db                	test   %ebx,%ebx
80104f0a:	78 24                	js     80104f30 <argptr+0x50>
80104f0c:	8b 16                	mov    (%esi),%edx
80104f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f11:	39 c2                	cmp    %eax,%edx
80104f13:	76 1b                	jbe    80104f30 <argptr+0x50>
80104f15:	01 c3                	add    %eax,%ebx
80104f17:	39 da                	cmp    %ebx,%edx
80104f19:	72 15                	jb     80104f30 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f1e:	89 02                	mov    %eax,(%edx)
  return 0;
80104f20:	31 c0                	xor    %eax,%eax
}
80104f22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f25:	5b                   	pop    %ebx
80104f26:	5e                   	pop    %esi
80104f27:	5d                   	pop    %ebp
80104f28:	c3                   	ret    
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f35:	eb eb                	jmp    80104f22 <argptr+0x42>
80104f37:	89 f6                	mov    %esi,%esi
80104f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f49:	50                   	push   %eax
80104f4a:	ff 75 08             	pushl  0x8(%ebp)
80104f4d:	e8 3e ff ff ff       	call   80104e90 <argint>
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	85 c0                	test   %eax,%eax
80104f57:	78 17                	js     80104f70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f59:	83 ec 08             	sub    $0x8,%esp
80104f5c:	ff 75 0c             	pushl  0xc(%ebp)
80104f5f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f62:	e8 b9 fe ff ff       	call   80104e20 <fetchstr>
80104f67:	83 c4 10             	add    $0x10,%esp
}
80104f6a:	c9                   	leave  
80104f6b:	c3                   	ret    
80104f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f80 <syscall>:
[SYS_sigret] sys_sigret,
};

void
syscall(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	53                   	push   %ebx
80104f84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f87:	e8 74 e8 ff ff       	call   80103800 <myproc>
80104f8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f8e:	8b 40 18             	mov    0x18(%eax),%eax
80104f91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f97:	83 fa 17             	cmp    $0x17,%edx
80104f9a:	77 1c                	ja     80104fb8 <syscall+0x38>
80104f9c:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
80104fa3:	85 d2                	test   %edx,%edx
80104fa5:	74 11                	je     80104fb8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104fa7:	ff d2                	call   *%edx
80104fa9:	8b 53 18             	mov    0x18(%ebx),%edx
80104fac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104faf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb2:	c9                   	leave  
80104fb3:	c3                   	ret    
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104fb8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104fb9:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104fbc:	50                   	push   %eax
80104fbd:	ff 73 10             	pushl  0x10(%ebx)
80104fc0:	68 31 7e 10 80       	push   $0x80107e31
80104fc5:	e8 96 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104fca:	8b 43 18             	mov    0x18(%ebx),%eax
80104fcd:	83 c4 10             	add    $0x10,%esp
80104fd0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fda:	c9                   	leave  
80104fdb:	c3                   	ret    
80104fdc:	66 90                	xchg   %ax,%ax
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
80104fe5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fe6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104fe9:	83 ec 34             	sub    $0x34,%esp
80104fec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ff2:	56                   	push   %esi
80104ff3:	50                   	push   %eax
{
80104ff4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ff7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104ffa:	e8 31 cf ff ff       	call   80101f30 <nameiparent>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	0f 84 46 01 00 00    	je     80105150 <create+0x170>
    return 0;
  ilock(dp);
8010500a:	83 ec 0c             	sub    $0xc,%esp
8010500d:	89 c3                	mov    %eax,%ebx
8010500f:	50                   	push   %eax
80105010:	e8 9b c6 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105015:	83 c4 0c             	add    $0xc,%esp
80105018:	6a 00                	push   $0x0
8010501a:	56                   	push   %esi
8010501b:	53                   	push   %ebx
8010501c:	e8 bf cb ff ff       	call   80101be0 <dirlookup>
80105021:	83 c4 10             	add    $0x10,%esp
80105024:	85 c0                	test   %eax,%eax
80105026:	89 c7                	mov    %eax,%edi
80105028:	74 36                	je     80105060 <create+0x80>
    iunlockput(dp);
8010502a:	83 ec 0c             	sub    $0xc,%esp
8010502d:	53                   	push   %ebx
8010502e:	e8 0d c9 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80105033:	89 3c 24             	mov    %edi,(%esp)
80105036:	e8 75 c6 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010503b:	83 c4 10             	add    $0x10,%esp
8010503e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105043:	0f 85 97 00 00 00    	jne    801050e0 <create+0x100>
80105049:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010504e:	0f 85 8c 00 00 00    	jne    801050e0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105054:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105057:	89 f8                	mov    %edi,%eax
80105059:	5b                   	pop    %ebx
8010505a:	5e                   	pop    %esi
8010505b:	5f                   	pop    %edi
8010505c:	5d                   	pop    %ebp
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105060:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105064:	83 ec 08             	sub    $0x8,%esp
80105067:	50                   	push   %eax
80105068:	ff 33                	pushl  (%ebx)
8010506a:	e8 d1 c4 ff ff       	call   80101540 <ialloc>
8010506f:	83 c4 10             	add    $0x10,%esp
80105072:	85 c0                	test   %eax,%eax
80105074:	89 c7                	mov    %eax,%edi
80105076:	0f 84 e8 00 00 00    	je     80105164 <create+0x184>
  ilock(ip);
8010507c:	83 ec 0c             	sub    $0xc,%esp
8010507f:	50                   	push   %eax
80105080:	e8 2b c6 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105085:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105089:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010508d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105091:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105095:	b8 01 00 00 00       	mov    $0x1,%eax
8010509a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010509e:	89 3c 24             	mov    %edi,(%esp)
801050a1:	e8 5a c5 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801050a6:	83 c4 10             	add    $0x10,%esp
801050a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801050ae:	74 50                	je     80105100 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801050b0:	83 ec 04             	sub    $0x4,%esp
801050b3:	ff 77 04             	pushl  0x4(%edi)
801050b6:	56                   	push   %esi
801050b7:	53                   	push   %ebx
801050b8:	e8 93 cd ff ff       	call   80101e50 <dirlink>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	0f 88 8f 00 00 00    	js     80105157 <create+0x177>
  iunlockput(dp);
801050c8:	83 ec 0c             	sub    $0xc,%esp
801050cb:	53                   	push   %ebx
801050cc:	e8 6f c8 ff ff       	call   80101940 <iunlockput>
  return ip;
801050d1:	83 c4 10             	add    $0x10,%esp
}
801050d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050d7:	89 f8                	mov    %edi,%eax
801050d9:	5b                   	pop    %ebx
801050da:	5e                   	pop    %esi
801050db:	5f                   	pop    %edi
801050dc:	5d                   	pop    %ebp
801050dd:	c3                   	ret    
801050de:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	57                   	push   %edi
    return 0;
801050e4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801050e6:	e8 55 c8 ff ff       	call   80101940 <iunlockput>
    return 0;
801050eb:	83 c4 10             	add    $0x10,%esp
}
801050ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050f1:	89 f8                	mov    %edi,%eax
801050f3:	5b                   	pop    %ebx
801050f4:	5e                   	pop    %esi
801050f5:	5f                   	pop    %edi
801050f6:	5d                   	pop    %ebp
801050f7:	c3                   	ret    
801050f8:	90                   	nop
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105100:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	53                   	push   %ebx
80105109:	e8 f2 c4 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010510e:	83 c4 0c             	add    $0xc,%esp
80105111:	ff 77 04             	pushl  0x4(%edi)
80105114:	68 e0 7e 10 80       	push   $0x80107ee0
80105119:	57                   	push   %edi
8010511a:	e8 31 cd ff ff       	call   80101e50 <dirlink>
8010511f:	83 c4 10             	add    $0x10,%esp
80105122:	85 c0                	test   %eax,%eax
80105124:	78 1c                	js     80105142 <create+0x162>
80105126:	83 ec 04             	sub    $0x4,%esp
80105129:	ff 73 04             	pushl  0x4(%ebx)
8010512c:	68 df 7e 10 80       	push   $0x80107edf
80105131:	57                   	push   %edi
80105132:	e8 19 cd ff ff       	call   80101e50 <dirlink>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	85 c0                	test   %eax,%eax
8010513c:	0f 89 6e ff ff ff    	jns    801050b0 <create+0xd0>
      panic("create dots");
80105142:	83 ec 0c             	sub    $0xc,%esp
80105145:	68 d3 7e 10 80       	push   $0x80107ed3
8010514a:	e8 41 b2 ff ff       	call   80100390 <panic>
8010514f:	90                   	nop
    return 0;
80105150:	31 ff                	xor    %edi,%edi
80105152:	e9 fd fe ff ff       	jmp    80105054 <create+0x74>
    panic("create: dirlink");
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	68 e2 7e 10 80       	push   $0x80107ee2
8010515f:	e8 2c b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	68 c4 7e 10 80       	push   $0x80107ec4
8010516c:	e8 1f b2 ff ff       	call   80100390 <panic>
80105171:	eb 0d                	jmp    80105180 <argfd.constprop.0>
80105173:	90                   	nop
80105174:	90                   	nop
80105175:	90                   	nop
80105176:	90                   	nop
80105177:	90                   	nop
80105178:	90                   	nop
80105179:	90                   	nop
8010517a:	90                   	nop
8010517b:	90                   	nop
8010517c:	90                   	nop
8010517d:	90                   	nop
8010517e:	90                   	nop
8010517f:	90                   	nop

80105180 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
80105185:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105187:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010518a:	89 d6                	mov    %edx,%esi
8010518c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010518f:	50                   	push   %eax
80105190:	6a 00                	push   $0x0
80105192:	e8 f9 fc ff ff       	call   80104e90 <argint>
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	78 2a                	js     801051c8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010519e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051a2:	77 24                	ja     801051c8 <argfd.constprop.0+0x48>
801051a4:	e8 57 e6 ff ff       	call   80103800 <myproc>
801051a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051ac:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
801051b0:	85 c0                	test   %eax,%eax
801051b2:	74 14                	je     801051c8 <argfd.constprop.0+0x48>
  if(pfd)
801051b4:	85 db                	test   %ebx,%ebx
801051b6:	74 02                	je     801051ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801051b8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
801051ba:	89 06                	mov    %eax,(%esi)
  return 0;
801051bc:	31 c0                	xor    %eax,%eax
}
801051be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051c1:	5b                   	pop    %ebx
801051c2:	5e                   	pop    %esi
801051c3:	5d                   	pop    %ebp
801051c4:	c3                   	ret    
801051c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cd:	eb ef                	jmp    801051be <argfd.constprop.0+0x3e>
801051cf:	90                   	nop

801051d0 <sys_dup>:
{
801051d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	56                   	push   %esi
801051d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801051d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801051da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801051dd:	e8 9e ff ff ff       	call   80105180 <argfd.constprop.0>
801051e2:	85 c0                	test   %eax,%eax
801051e4:	78 42                	js     80105228 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801051e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801051eb:	e8 10 e6 ff ff       	call   80103800 <myproc>
801051f0:	eb 0e                	jmp    80105200 <sys_dup+0x30>
801051f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051f8:	83 c3 01             	add    $0x1,%ebx
801051fb:	83 fb 10             	cmp    $0x10,%ebx
801051fe:	74 28                	je     80105228 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105200:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105204:	85 d2                	test   %edx,%edx
80105206:	75 f0                	jne    801051f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105208:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	ff 75 f4             	pushl  -0xc(%ebp)
80105212:	e8 09 bc ff ff       	call   80100e20 <filedup>
  return fd;
80105217:	83 c4 10             	add    $0x10,%esp
}
8010521a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010521d:	89 d8                	mov    %ebx,%eax
8010521f:	5b                   	pop    %ebx
80105220:	5e                   	pop    %esi
80105221:	5d                   	pop    %ebp
80105222:	c3                   	ret    
80105223:	90                   	nop
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105228:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010522b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105230:	89 d8                	mov    %ebx,%eax
80105232:	5b                   	pop    %ebx
80105233:	5e                   	pop    %esi
80105234:	5d                   	pop    %ebp
80105235:	c3                   	ret    
80105236:	8d 76 00             	lea    0x0(%esi),%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_read>:
{
80105240:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105241:	31 c0                	xor    %eax,%eax
{
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105248:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010524b:	e8 30 ff ff ff       	call   80105180 <argfd.constprop.0>
80105250:	85 c0                	test   %eax,%eax
80105252:	78 4c                	js     801052a0 <sys_read+0x60>
80105254:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105257:	83 ec 08             	sub    $0x8,%esp
8010525a:	50                   	push   %eax
8010525b:	6a 02                	push   $0x2
8010525d:	e8 2e fc ff ff       	call   80104e90 <argint>
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	85 c0                	test   %eax,%eax
80105267:	78 37                	js     801052a0 <sys_read+0x60>
80105269:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526c:	83 ec 04             	sub    $0x4,%esp
8010526f:	ff 75 f0             	pushl  -0x10(%ebp)
80105272:	50                   	push   %eax
80105273:	6a 01                	push   $0x1
80105275:	e8 66 fc ff ff       	call   80104ee0 <argptr>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	78 1f                	js     801052a0 <sys_read+0x60>
  return fileread(f, p, n);
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	ff 75 f0             	pushl  -0x10(%ebp)
80105287:	ff 75 f4             	pushl  -0xc(%ebp)
8010528a:	ff 75 ec             	pushl  -0x14(%ebp)
8010528d:	e8 fe bc ff ff       	call   80100f90 <fileread>
80105292:	83 c4 10             	add    $0x10,%esp
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_write>:
{
801052b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052b1:	31 c0                	xor    %eax,%eax
{
801052b3:	89 e5                	mov    %esp,%ebp
801052b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052bb:	e8 c0 fe ff ff       	call   80105180 <argfd.constprop.0>
801052c0:	85 c0                	test   %eax,%eax
801052c2:	78 4c                	js     80105310 <sys_write+0x60>
801052c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052c7:	83 ec 08             	sub    $0x8,%esp
801052ca:	50                   	push   %eax
801052cb:	6a 02                	push   $0x2
801052cd:	e8 be fb ff ff       	call   80104e90 <argint>
801052d2:	83 c4 10             	add    $0x10,%esp
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 37                	js     80105310 <sys_write+0x60>
801052d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052dc:	83 ec 04             	sub    $0x4,%esp
801052df:	ff 75 f0             	pushl  -0x10(%ebp)
801052e2:	50                   	push   %eax
801052e3:	6a 01                	push   $0x1
801052e5:	e8 f6 fb ff ff       	call   80104ee0 <argptr>
801052ea:	83 c4 10             	add    $0x10,%esp
801052ed:	85 c0                	test   %eax,%eax
801052ef:	78 1f                	js     80105310 <sys_write+0x60>
  return filewrite(f, p, n);
801052f1:	83 ec 04             	sub    $0x4,%esp
801052f4:	ff 75 f0             	pushl  -0x10(%ebp)
801052f7:	ff 75 f4             	pushl  -0xc(%ebp)
801052fa:	ff 75 ec             	pushl  -0x14(%ebp)
801052fd:	e8 1e bd ff ff       	call   80101020 <filewrite>
80105302:	83 c4 10             	add    $0x10,%esp
}
80105305:	c9                   	leave  
80105306:	c3                   	ret    
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105315:	c9                   	leave  
80105316:	c3                   	ret    
80105317:	89 f6                	mov    %esi,%esi
80105319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105320 <sys_close>:
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105326:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105329:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010532c:	e8 4f fe ff ff       	call   80105180 <argfd.constprop.0>
80105331:	85 c0                	test   %eax,%eax
80105333:	78 2b                	js     80105360 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105335:	e8 c6 e4 ff ff       	call   80103800 <myproc>
8010533a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010533d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105340:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80105347:	00 
  fileclose(f);
80105348:	ff 75 f4             	pushl  -0xc(%ebp)
8010534b:	e8 20 bb ff ff       	call   80100e70 <fileclose>
  return 0;
80105350:	83 c4 10             	add    $0x10,%esp
80105353:	31 c0                	xor    %eax,%eax
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105365:	c9                   	leave  
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <sys_fstat>:
{
80105370:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105371:	31 c0                	xor    %eax,%eax
{
80105373:	89 e5                	mov    %esp,%ebp
80105375:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105378:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010537b:	e8 00 fe ff ff       	call   80105180 <argfd.constprop.0>
80105380:	85 c0                	test   %eax,%eax
80105382:	78 2c                	js     801053b0 <sys_fstat+0x40>
80105384:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105387:	83 ec 04             	sub    $0x4,%esp
8010538a:	6a 14                	push   $0x14
8010538c:	50                   	push   %eax
8010538d:	6a 01                	push   $0x1
8010538f:	e8 4c fb ff ff       	call   80104ee0 <argptr>
80105394:	83 c4 10             	add    $0x10,%esp
80105397:	85 c0                	test   %eax,%eax
80105399:	78 15                	js     801053b0 <sys_fstat+0x40>
  return filestat(f, st);
8010539b:	83 ec 08             	sub    $0x8,%esp
8010539e:	ff 75 f4             	pushl  -0xc(%ebp)
801053a1:	ff 75 f0             	pushl  -0x10(%ebp)
801053a4:	e8 97 bb ff ff       	call   80100f40 <filestat>
801053a9:	83 c4 10             	add    $0x10,%esp
}
801053ac:	c9                   	leave  
801053ad:	c3                   	ret    
801053ae:	66 90                	xchg   %ax,%ax
    return -1;
801053b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b5:	c9                   	leave  
801053b6:	c3                   	ret    
801053b7:	89 f6                	mov    %esi,%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <sys_link>:
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801053c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 6c fb ff ff       	call   80104f40 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 fb 00 00 00    	js     801054da <sys_link+0x11a>
801053df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053e2:	83 ec 08             	sub    $0x8,%esp
801053e5:	50                   	push   %eax
801053e6:	6a 01                	push   $0x1
801053e8:	e8 53 fb ff ff       	call   80104f40 <argstr>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	0f 88 e2 00 00 00    	js     801054da <sys_link+0x11a>
  begin_op();
801053f8:	e8 e3 d7 ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
801053fd:	83 ec 0c             	sub    $0xc,%esp
80105400:	ff 75 d4             	pushl  -0x2c(%ebp)
80105403:	e8 08 cb ff ff       	call   80101f10 <namei>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	89 c3                	mov    %eax,%ebx
8010540f:	0f 84 ea 00 00 00    	je     801054ff <sys_link+0x13f>
  ilock(ip);
80105415:	83 ec 0c             	sub    $0xc,%esp
80105418:	50                   	push   %eax
80105419:	e8 92 c2 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105426:	0f 84 bb 00 00 00    	je     801054e7 <sys_link+0x127>
  ip->nlink++;
8010542c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105431:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105434:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105437:	53                   	push   %ebx
80105438:	e8 c3 c1 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
8010543d:	89 1c 24             	mov    %ebx,(%esp)
80105440:	e8 4b c3 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105445:	58                   	pop    %eax
80105446:	5a                   	pop    %edx
80105447:	57                   	push   %edi
80105448:	ff 75 d0             	pushl  -0x30(%ebp)
8010544b:	e8 e0 ca ff ff       	call   80101f30 <nameiparent>
80105450:	83 c4 10             	add    $0x10,%esp
80105453:	85 c0                	test   %eax,%eax
80105455:	89 c6                	mov    %eax,%esi
80105457:	74 5b                	je     801054b4 <sys_link+0xf4>
  ilock(dp);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	50                   	push   %eax
8010545d:	e8 4e c2 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	8b 03                	mov    (%ebx),%eax
80105467:	39 06                	cmp    %eax,(%esi)
80105469:	75 3d                	jne    801054a8 <sys_link+0xe8>
8010546b:	83 ec 04             	sub    $0x4,%esp
8010546e:	ff 73 04             	pushl  0x4(%ebx)
80105471:	57                   	push   %edi
80105472:	56                   	push   %esi
80105473:	e8 d8 c9 ff ff       	call   80101e50 <dirlink>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	78 29                	js     801054a8 <sys_link+0xe8>
  iunlockput(dp);
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	56                   	push   %esi
80105483:	e8 b8 c4 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105488:	89 1c 24             	mov    %ebx,(%esp)
8010548b:	e8 50 c3 ff ff       	call   801017e0 <iput>
  end_op();
80105490:	e8 bb d7 ff ff       	call   80102c50 <end_op>
  return 0;
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	31 c0                	xor    %eax,%eax
}
8010549a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010549d:	5b                   	pop    %ebx
8010549e:	5e                   	pop    %esi
8010549f:	5f                   	pop    %edi
801054a0:	5d                   	pop    %ebp
801054a1:	c3                   	ret    
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	56                   	push   %esi
801054ac:	e8 8f c4 ff ff       	call   80101940 <iunlockput>
    goto bad;
801054b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801054b4:	83 ec 0c             	sub    $0xc,%esp
801054b7:	53                   	push   %ebx
801054b8:	e8 f3 c1 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
801054bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054c2:	89 1c 24             	mov    %ebx,(%esp)
801054c5:	e8 36 c1 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801054ca:	89 1c 24             	mov    %ebx,(%esp)
801054cd:	e8 6e c4 ff ff       	call   80101940 <iunlockput>
  end_op();
801054d2:	e8 79 d7 ff ff       	call   80102c50 <end_op>
  return -1;
801054d7:	83 c4 10             	add    $0x10,%esp
}
801054da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801054dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e2:	5b                   	pop    %ebx
801054e3:	5e                   	pop    %esi
801054e4:	5f                   	pop    %edi
801054e5:	5d                   	pop    %ebp
801054e6:	c3                   	ret    
    iunlockput(ip);
801054e7:	83 ec 0c             	sub    $0xc,%esp
801054ea:	53                   	push   %ebx
801054eb:	e8 50 c4 ff ff       	call   80101940 <iunlockput>
    end_op();
801054f0:	e8 5b d7 ff ff       	call   80102c50 <end_op>
    return -1;
801054f5:	83 c4 10             	add    $0x10,%esp
801054f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fd:	eb 9b                	jmp    8010549a <sys_link+0xda>
    end_op();
801054ff:	e8 4c d7 ff ff       	call   80102c50 <end_op>
    return -1;
80105504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105509:	eb 8f                	jmp    8010549a <sys_link+0xda>
8010550b:	90                   	nop
8010550c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105510 <sys_unlink>:
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105516:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105519:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 1c fa ff ff       	call   80104f40 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 77 01 00 00    	js     801056a6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010552f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105532:	e8 a9 d6 ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105537:	83 ec 08             	sub    $0x8,%esp
8010553a:	53                   	push   %ebx
8010553b:	ff 75 c0             	pushl  -0x40(%ebp)
8010553e:	e8 ed c9 ff ff       	call   80101f30 <nameiparent>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	89 c6                	mov    %eax,%esi
8010554a:	0f 84 60 01 00 00    	je     801056b0 <sys_unlink+0x1a0>
  ilock(dp);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	50                   	push   %eax
80105554:	e8 57 c1 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105559:	58                   	pop    %eax
8010555a:	5a                   	pop    %edx
8010555b:	68 e0 7e 10 80       	push   $0x80107ee0
80105560:	53                   	push   %ebx
80105561:	e8 5a c6 ff ff       	call   80101bc0 <namecmp>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	0f 84 03 01 00 00    	je     80105674 <sys_unlink+0x164>
80105571:	83 ec 08             	sub    $0x8,%esp
80105574:	68 df 7e 10 80       	push   $0x80107edf
80105579:	53                   	push   %ebx
8010557a:	e8 41 c6 ff ff       	call   80101bc0 <namecmp>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	0f 84 ea 00 00 00    	je     80105674 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010558a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010558d:	83 ec 04             	sub    $0x4,%esp
80105590:	50                   	push   %eax
80105591:	53                   	push   %ebx
80105592:	56                   	push   %esi
80105593:	e8 48 c6 ff ff       	call   80101be0 <dirlookup>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	89 c3                	mov    %eax,%ebx
8010559f:	0f 84 cf 00 00 00    	je     80105674 <sys_unlink+0x164>
  ilock(ip);
801055a5:	83 ec 0c             	sub    $0xc,%esp
801055a8:	50                   	push   %eax
801055a9:	e8 02 c1 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055b6:	0f 8e 10 01 00 00    	jle    801056cc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801055bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c1:	74 6d                	je     80105630 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801055c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055c6:	83 ec 04             	sub    $0x4,%esp
801055c9:	6a 10                	push   $0x10
801055cb:	6a 00                	push   $0x0
801055cd:	50                   	push   %eax
801055ce:	e8 bd f5 ff ff       	call   80104b90 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055d6:	6a 10                	push   $0x10
801055d8:	ff 75 c4             	pushl  -0x3c(%ebp)
801055db:	50                   	push   %eax
801055dc:	56                   	push   %esi
801055dd:	e8 ae c4 ff ff       	call   80101a90 <writei>
801055e2:	83 c4 20             	add    $0x20,%esp
801055e5:	83 f8 10             	cmp    $0x10,%eax
801055e8:	0f 85 eb 00 00 00    	jne    801056d9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801055ee:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f3:	0f 84 97 00 00 00    	je     80105690 <sys_unlink+0x180>
  iunlockput(dp);
801055f9:	83 ec 0c             	sub    $0xc,%esp
801055fc:	56                   	push   %esi
801055fd:	e8 3e c3 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105602:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105607:	89 1c 24             	mov    %ebx,(%esp)
8010560a:	e8 f1 bf ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010560f:	89 1c 24             	mov    %ebx,(%esp)
80105612:	e8 29 c3 ff ff       	call   80101940 <iunlockput>
  end_op();
80105617:	e8 34 d6 ff ff       	call   80102c50 <end_op>
  return 0;
8010561c:	83 c4 10             	add    $0x10,%esp
8010561f:	31 c0                	xor    %eax,%eax
}
80105621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105624:	5b                   	pop    %ebx
80105625:	5e                   	pop    %esi
80105626:	5f                   	pop    %edi
80105627:	5d                   	pop    %ebp
80105628:	c3                   	ret    
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105630:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105634:	76 8d                	jbe    801055c3 <sys_unlink+0xb3>
80105636:	bf 20 00 00 00       	mov    $0x20,%edi
8010563b:	eb 0f                	jmp    8010564c <sys_unlink+0x13c>
8010563d:	8d 76 00             	lea    0x0(%esi),%esi
80105640:	83 c7 10             	add    $0x10,%edi
80105643:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105646:	0f 83 77 ff ff ff    	jae    801055c3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010564c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010564f:	6a 10                	push   $0x10
80105651:	57                   	push   %edi
80105652:	50                   	push   %eax
80105653:	53                   	push   %ebx
80105654:	e8 37 c3 ff ff       	call   80101990 <readi>
80105659:	83 c4 10             	add    $0x10,%esp
8010565c:	83 f8 10             	cmp    $0x10,%eax
8010565f:	75 5e                	jne    801056bf <sys_unlink+0x1af>
    if(de.inum != 0)
80105661:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105666:	74 d8                	je     80105640 <sys_unlink+0x130>
    iunlockput(ip);
80105668:	83 ec 0c             	sub    $0xc,%esp
8010566b:	53                   	push   %ebx
8010566c:	e8 cf c2 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105671:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105674:	83 ec 0c             	sub    $0xc,%esp
80105677:	56                   	push   %esi
80105678:	e8 c3 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
8010567d:	e8 ce d5 ff ff       	call   80102c50 <end_op>
  return -1;
80105682:	83 c4 10             	add    $0x10,%esp
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568a:	eb 95                	jmp    80105621 <sys_unlink+0x111>
8010568c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105690:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	56                   	push   %esi
80105699:	e8 62 bf ff ff       	call   80101600 <iupdate>
8010569e:	83 c4 10             	add    $0x10,%esp
801056a1:	e9 53 ff ff ff       	jmp    801055f9 <sys_unlink+0xe9>
    return -1;
801056a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ab:	e9 71 ff ff ff       	jmp    80105621 <sys_unlink+0x111>
    end_op();
801056b0:	e8 9b d5 ff ff       	call   80102c50 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ba:	e9 62 ff ff ff       	jmp    80105621 <sys_unlink+0x111>
      panic("isdirempty: readi");
801056bf:	83 ec 0c             	sub    $0xc,%esp
801056c2:	68 04 7f 10 80       	push   $0x80107f04
801056c7:	e8 c4 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	68 f2 7e 10 80       	push   $0x80107ef2
801056d4:	e8 b7 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	68 16 7f 10 80       	push   $0x80107f16
801056e1:	e8 aa ac ff ff       	call   80100390 <panic>
801056e6:	8d 76 00             	lea    0x0(%esi),%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056f0 <sys_open>:

int
sys_open(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056fc:	50                   	push   %eax
801056fd:	6a 00                	push   $0x0
801056ff:	e8 3c f8 ff ff       	call   80104f40 <argstr>
80105704:	83 c4 10             	add    $0x10,%esp
80105707:	85 c0                	test   %eax,%eax
80105709:	0f 88 1d 01 00 00    	js     8010582c <sys_open+0x13c>
8010570f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105712:	83 ec 08             	sub    $0x8,%esp
80105715:	50                   	push   %eax
80105716:	6a 01                	push   $0x1
80105718:	e8 73 f7 ff ff       	call   80104e90 <argint>
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	85 c0                	test   %eax,%eax
80105722:	0f 88 04 01 00 00    	js     8010582c <sys_open+0x13c>
    return -1;

  begin_op();
80105728:	e8 b3 d4 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
8010572d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105731:	0f 85 a9 00 00 00    	jne    801057e0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105737:	83 ec 0c             	sub    $0xc,%esp
8010573a:	ff 75 e0             	pushl  -0x20(%ebp)
8010573d:	e8 ce c7 ff ff       	call   80101f10 <namei>
80105742:	83 c4 10             	add    $0x10,%esp
80105745:	85 c0                	test   %eax,%eax
80105747:	89 c6                	mov    %eax,%esi
80105749:	0f 84 b2 00 00 00    	je     80105801 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	50                   	push   %eax
80105753:	e8 58 bf ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105760:	0f 84 aa 00 00 00    	je     80105810 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105766:	e8 45 b6 ff ff       	call   80100db0 <filealloc>
8010576b:	85 c0                	test   %eax,%eax
8010576d:	89 c7                	mov    %eax,%edi
8010576f:	0f 84 a6 00 00 00    	je     8010581b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105775:	e8 86 e0 ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010577a:	31 db                	xor    %ebx,%ebx
8010577c:	eb 0e                	jmp    8010578c <sys_open+0x9c>
8010577e:	66 90                	xchg   %ax,%ax
80105780:	83 c3 01             	add    $0x1,%ebx
80105783:	83 fb 10             	cmp    $0x10,%ebx
80105786:	0f 84 ac 00 00 00    	je     80105838 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010578c:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105790:	85 d2                	test   %edx,%edx
80105792:	75 ec                	jne    80105780 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105794:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105797:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010579b:	56                   	push   %esi
8010579c:	e8 ef bf ff ff       	call   80101790 <iunlock>
  end_op();
801057a1:	e8 aa d4 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
801057a6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801057ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057af:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801057b2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801057b5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801057bc:	89 d0                	mov    %edx,%eax
801057be:	f7 d0                	not    %eax
801057c0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057c3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801057c6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801057c9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801057cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d0:	89 d8                	mov    %ebx,%eax
801057d2:	5b                   	pop    %ebx
801057d3:	5e                   	pop    %esi
801057d4:	5f                   	pop    %edi
801057d5:	5d                   	pop    %ebp
801057d6:	c3                   	ret    
801057d7:	89 f6                	mov    %esi,%esi
801057d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057e6:	31 c9                	xor    %ecx,%ecx
801057e8:	6a 00                	push   $0x0
801057ea:	ba 02 00 00 00       	mov    $0x2,%edx
801057ef:	e8 ec f7 ff ff       	call   80104fe0 <create>
    if(ip == 0){
801057f4:	83 c4 10             	add    $0x10,%esp
801057f7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801057f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057fb:	0f 85 65 ff ff ff    	jne    80105766 <sys_open+0x76>
      end_op();
80105801:	e8 4a d4 ff ff       	call   80102c50 <end_op>
      return -1;
80105806:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010580b:	eb c0                	jmp    801057cd <sys_open+0xdd>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105810:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105813:	85 c9                	test   %ecx,%ecx
80105815:	0f 84 4b ff ff ff    	je     80105766 <sys_open+0x76>
    iunlockput(ip);
8010581b:	83 ec 0c             	sub    $0xc,%esp
8010581e:	56                   	push   %esi
8010581f:	e8 1c c1 ff ff       	call   80101940 <iunlockput>
    end_op();
80105824:	e8 27 d4 ff ff       	call   80102c50 <end_op>
    return -1;
80105829:	83 c4 10             	add    $0x10,%esp
8010582c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105831:	eb 9a                	jmp    801057cd <sys_open+0xdd>
80105833:	90                   	nop
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105838:	83 ec 0c             	sub    $0xc,%esp
8010583b:	57                   	push   %edi
8010583c:	e8 2f b6 ff ff       	call   80100e70 <fileclose>
80105841:	83 c4 10             	add    $0x10,%esp
80105844:	eb d5                	jmp    8010581b <sys_open+0x12b>
80105846:	8d 76 00             	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_mkdir>:

int
sys_mkdir(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105856:	e8 85 d3 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010585b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010585e:	83 ec 08             	sub    $0x8,%esp
80105861:	50                   	push   %eax
80105862:	6a 00                	push   $0x0
80105864:	e8 d7 f6 ff ff       	call   80104f40 <argstr>
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	85 c0                	test   %eax,%eax
8010586e:	78 30                	js     801058a0 <sys_mkdir+0x50>
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105876:	31 c9                	xor    %ecx,%ecx
80105878:	6a 00                	push   $0x0
8010587a:	ba 01 00 00 00       	mov    $0x1,%edx
8010587f:	e8 5c f7 ff ff       	call   80104fe0 <create>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	74 15                	je     801058a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010588b:	83 ec 0c             	sub    $0xc,%esp
8010588e:	50                   	push   %eax
8010588f:	e8 ac c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105894:	e8 b7 d3 ff ff       	call   80102c50 <end_op>
  return 0;
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	31 c0                	xor    %eax,%eax
}
8010589e:	c9                   	leave  
8010589f:	c3                   	ret    
    end_op();
801058a0:	e8 ab d3 ff ff       	call   80102c50 <end_op>
    return -1;
801058a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058aa:	c9                   	leave  
801058ab:	c3                   	ret    
801058ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058b0 <sys_mknod>:

int
sys_mknod(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801058b6:	e8 25 d3 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801058bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058be:	83 ec 08             	sub    $0x8,%esp
801058c1:	50                   	push   %eax
801058c2:	6a 00                	push   $0x0
801058c4:	e8 77 f6 ff ff       	call   80104f40 <argstr>
801058c9:	83 c4 10             	add    $0x10,%esp
801058cc:	85 c0                	test   %eax,%eax
801058ce:	78 60                	js     80105930 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d3:	83 ec 08             	sub    $0x8,%esp
801058d6:	50                   	push   %eax
801058d7:	6a 01                	push   $0x1
801058d9:	e8 b2 f5 ff ff       	call   80104e90 <argint>
  if((argstr(0, &path)) < 0 ||
801058de:	83 c4 10             	add    $0x10,%esp
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 4b                	js     80105930 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e8:	83 ec 08             	sub    $0x8,%esp
801058eb:	50                   	push   %eax
801058ec:	6a 02                	push   $0x2
801058ee:	e8 9d f5 ff ff       	call   80104e90 <argint>
     argint(1, &major) < 0 ||
801058f3:	83 c4 10             	add    $0x10,%esp
801058f6:	85 c0                	test   %eax,%eax
801058f8:	78 36                	js     80105930 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801058fe:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105901:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105905:	ba 03 00 00 00       	mov    $0x3,%edx
8010590a:	50                   	push   %eax
8010590b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010590e:	e8 cd f6 ff ff       	call   80104fe0 <create>
80105913:	83 c4 10             	add    $0x10,%esp
80105916:	85 c0                	test   %eax,%eax
80105918:	74 16                	je     80105930 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010591a:	83 ec 0c             	sub    $0xc,%esp
8010591d:	50                   	push   %eax
8010591e:	e8 1d c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105923:	e8 28 d3 ff ff       	call   80102c50 <end_op>
  return 0;
80105928:	83 c4 10             	add    $0x10,%esp
8010592b:	31 c0                	xor    %eax,%eax
}
8010592d:	c9                   	leave  
8010592e:	c3                   	ret    
8010592f:	90                   	nop
    end_op();
80105930:	e8 1b d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_chdir>:

int
sys_chdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	56                   	push   %esi
80105944:	53                   	push   %ebx
80105945:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105948:	e8 b3 de ff ff       	call   80103800 <myproc>
8010594d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010594f:	e8 8c d2 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 08             	sub    $0x8,%esp
8010595a:	50                   	push   %eax
8010595b:	6a 00                	push   $0x0
8010595d:	e8 de f5 ff ff       	call   80104f40 <argstr>
80105962:	83 c4 10             	add    $0x10,%esp
80105965:	85 c0                	test   %eax,%eax
80105967:	78 77                	js     801059e0 <sys_chdir+0xa0>
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	ff 75 f4             	pushl  -0xc(%ebp)
8010596f:	e8 9c c5 ff ff       	call   80101f10 <namei>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	89 c3                	mov    %eax,%ebx
8010597b:	74 63                	je     801059e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010597d:	83 ec 0c             	sub    $0xc,%esp
80105980:	50                   	push   %eax
80105981:	e8 2a bd ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010598e:	75 30                	jne    801059c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	53                   	push   %ebx
80105994:	e8 f7 bd ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105999:	58                   	pop    %eax
8010599a:	ff 76 6c             	pushl  0x6c(%esi)
8010599d:	e8 3e be ff ff       	call   801017e0 <iput>
  end_op();
801059a2:	e8 a9 d2 ff ff       	call   80102c50 <end_op>
  curproc->cwd = ip;
801059a7:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	31 c0                	xor    %eax,%eax
}
801059af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059b2:	5b                   	pop    %ebx
801059b3:	5e                   	pop    %esi
801059b4:	5d                   	pop    %ebp
801059b5:	c3                   	ret    
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801059c0:	83 ec 0c             	sub    $0xc,%esp
801059c3:	53                   	push   %ebx
801059c4:	e8 77 bf ff ff       	call   80101940 <iunlockput>
    end_op();
801059c9:	e8 82 d2 ff ff       	call   80102c50 <end_op>
    return -1;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059d6:	eb d7                	jmp    801059af <sys_chdir+0x6f>
801059d8:	90                   	nop
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059e0:	e8 6b d2 ff ff       	call   80102c50 <end_op>
    return -1;
801059e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ea:	eb c3                	jmp    801059af <sys_chdir+0x6f>
801059ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_exec>:

int
sys_exec(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a02:	50                   	push   %eax
80105a03:	6a 00                	push   $0x0
80105a05:	e8 36 f5 ff ff       	call   80104f40 <argstr>
80105a0a:	83 c4 10             	add    $0x10,%esp
80105a0d:	85 c0                	test   %eax,%eax
80105a0f:	0f 88 87 00 00 00    	js     80105a9c <sys_exec+0xac>
80105a15:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a1b:	83 ec 08             	sub    $0x8,%esp
80105a1e:	50                   	push   %eax
80105a1f:	6a 01                	push   $0x1
80105a21:	e8 6a f4 ff ff       	call   80104e90 <argint>
80105a26:	83 c4 10             	add    $0x10,%esp
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	78 6f                	js     80105a9c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105a2d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a33:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105a36:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a38:	68 80 00 00 00       	push   $0x80
80105a3d:	6a 00                	push   $0x0
80105a3f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a45:	50                   	push   %eax
80105a46:	e8 45 f1 ff ff       	call   80104b90 <memset>
80105a4b:	83 c4 10             	add    $0x10,%esp
80105a4e:	eb 2c                	jmp    80105a7c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105a50:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a56:	85 c0                	test   %eax,%eax
80105a58:	74 56                	je     80105ab0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a5a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a66:	52                   	push   %edx
80105a67:	50                   	push   %eax
80105a68:	e8 b3 f3 ff ff       	call   80104e20 <fetchstr>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	78 28                	js     80105a9c <sys_exec+0xac>
  for(i=0;; i++){
80105a74:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a77:	83 fb 20             	cmp    $0x20,%ebx
80105a7a:	74 20                	je     80105a9c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a7c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a82:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	57                   	push   %edi
80105a8d:	01 f0                	add    %esi,%eax
80105a8f:	50                   	push   %eax
80105a90:	e8 4b f3 ff ff       	call   80104de0 <fetchint>
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	79 b4                	jns    80105a50 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aa4:	5b                   	pop    %ebx
80105aa5:	5e                   	pop    %esi
80105aa6:	5f                   	pop    %edi
80105aa7:	5d                   	pop    %ebp
80105aa8:	c3                   	ret    
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ab0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ab6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ab9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ac0:	00 00 00 00 
  return exec(path, argv);
80105ac4:	50                   	push   %eax
80105ac5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105acb:	e8 40 af ff ff       	call   80100a10 <exec>
80105ad0:	83 c4 10             	add    $0x10,%esp
}
80105ad3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad6:	5b                   	pop    %ebx
80105ad7:	5e                   	pop    %esi
80105ad8:	5f                   	pop    %edi
80105ad9:	5d                   	pop    %ebp
80105ada:	c3                   	ret    
80105adb:	90                   	nop
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_pipe>:

int
sys_pipe(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
80105ae5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ae6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ae9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105aec:	6a 08                	push   $0x8
80105aee:	50                   	push   %eax
80105aef:	6a 00                	push   $0x0
80105af1:	e8 ea f3 ff ff       	call   80104ee0 <argptr>
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	85 c0                	test   %eax,%eax
80105afb:	0f 88 ae 00 00 00    	js     80105baf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b04:	83 ec 08             	sub    $0x8,%esp
80105b07:	50                   	push   %eax
80105b08:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b0b:	50                   	push   %eax
80105b0c:	e8 6f d7 ff ff       	call   80103280 <pipealloc>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	0f 88 93 00 00 00    	js     80105baf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b1c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b1f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b21:	e8 da dc ff ff       	call   80103800 <myproc>
80105b26:	eb 10                	jmp    80105b38 <sys_pipe+0x58>
80105b28:	90                   	nop
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b30:	83 c3 01             	add    $0x1,%ebx
80105b33:	83 fb 10             	cmp    $0x10,%ebx
80105b36:	74 60                	je     80105b98 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105b38:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105b3c:	85 f6                	test   %esi,%esi
80105b3e:	75 f0                	jne    80105b30 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b40:	8d 73 08             	lea    0x8(%ebx),%esi
80105b43:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b4a:	e8 b1 dc ff ff       	call   80103800 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b4f:	31 d2                	xor    %edx,%edx
80105b51:	eb 0d                	jmp    80105b60 <sys_pipe+0x80>
80105b53:	90                   	nop
80105b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b58:	83 c2 01             	add    $0x1,%edx
80105b5b:	83 fa 10             	cmp    $0x10,%edx
80105b5e:	74 28                	je     80105b88 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105b60:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105b64:	85 c9                	test   %ecx,%ecx
80105b66:	75 f0                	jne    80105b58 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105b68:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b6f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b74:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b77:	31 c0                	xor    %eax,%eax
}
80105b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b7c:	5b                   	pop    %ebx
80105b7d:	5e                   	pop    %esi
80105b7e:	5f                   	pop    %edi
80105b7f:	5d                   	pop    %ebp
80105b80:	c3                   	ret    
80105b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105b88:	e8 73 dc ff ff       	call   80103800 <myproc>
80105b8d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105b94:	00 
80105b95:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b9e:	e8 cd b2 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105ba3:	58                   	pop    %eax
80105ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ba7:	e8 c4 b2 ff ff       	call   80100e70 <fileclose>
    return -1;
80105bac:	83 c4 10             	add    $0x10,%esp
80105baf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb4:	eb c3                	jmp    80105b79 <sys_pipe+0x99>
80105bb6:	66 90                	xchg   %ax,%ax
80105bb8:	66 90                	xchg   %ax,%ax
80105bba:	66 90                	xchg   %ax,%ax
80105bbc:	66 90                	xchg   %ax,%ax
80105bbe:	66 90                	xchg   %ax,%ax

80105bc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105bc3:	5d                   	pop    %ebp
  return fork();
80105bc4:	e9 27 df ff ff       	jmp    80103af0 <fork>
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_exit>:

int
sys_exit(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105bd6:	e8 45 e2 ff ff       	call   80103e20 <exit>
  return 0;  // not reached
}
80105bdb:	31 c0                	xor    %eax,%eax
80105bdd:	c9                   	leave  
80105bde:	c3                   	ret    
80105bdf:	90                   	nop

80105be0 <sys_wait>:

int
sys_wait(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105be3:	5d                   	pop    %ebp
  return wait();
80105be4:	e9 57 e3 ff ff       	jmp    80103f40 <wait>
80105be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_kill>:

int
sys_kill(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
80105bf6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf9:	50                   	push   %eax
80105bfa:	6a 00                	push   $0x0
80105bfc:	e8 8f f2 ff ff       	call   80104e90 <argint>
80105c01:	83 c4 10             	add    $0x10,%esp
80105c04:	85 c0                	test   %eax,%eax
80105c06:	78 28                	js     80105c30 <sys_kill+0x40>
    return -1;
  if(argint(1, &signum) < 0)
80105c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0b:	83 ec 08             	sub    $0x8,%esp
80105c0e:	50                   	push   %eax
80105c0f:	6a 01                	push   $0x1
80105c11:	e8 7a f2 ff ff       	call   80104e90 <argint>
80105c16:	83 c4 10             	add    $0x10,%esp
80105c19:	85 c0                	test   %eax,%eax
80105c1b:	78 13                	js     80105c30 <sys_kill+0x40>
    return -1;
  return kill(pid,signum);
80105c1d:	83 ec 08             	sub    $0x8,%esp
80105c20:	ff 75 f4             	pushl  -0xc(%ebp)
80105c23:	ff 75 f0             	pushl  -0x10(%ebp)
80105c26:	e8 45 e6 ff ff       	call   80104270 <kill>
80105c2b:	83 c4 10             	add    $0x10,%esp
}
80105c2e:	c9                   	leave  
80105c2f:	c3                   	ret    
    return -1;
80105c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c40 <sys_getpid>:

int
sys_getpid(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c46:	e8 b5 db ff ff       	call   80103800 <myproc>
80105c4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c4e:	c9                   	leave  
80105c4f:	c3                   	ret    

80105c50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c5a:	50                   	push   %eax
80105c5b:	6a 00                	push   $0x0
80105c5d:	e8 2e f2 ff ff       	call   80104e90 <argint>
80105c62:	83 c4 10             	add    $0x10,%esp
80105c65:	85 c0                	test   %eax,%eax
80105c67:	78 27                	js     80105c90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c69:	e8 92 db ff ff       	call   80103800 <myproc>
  if(growproc(n) < 0)
80105c6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c73:	ff 75 f4             	pushl  -0xc(%ebp)
80105c76:	e8 f5 dd ff ff       	call   80103a70 <growproc>
80105c7b:	83 c4 10             	add    $0x10,%esp
80105c7e:	85 c0                	test   %eax,%eax
80105c80:	78 0e                	js     80105c90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c82:	89 d8                	mov    %ebx,%eax
80105c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c87:	c9                   	leave  
80105c88:	c3                   	ret    
80105c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c95:	eb eb                	jmp    80105c82 <sys_sbrk+0x32>
80105c97:	89 f6                	mov    %esi,%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ca0 <sys_sleep>:

int
sys_sleep(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105ca4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ca7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105caa:	50                   	push   %eax
80105cab:	6a 00                	push   $0x0
80105cad:	e8 de f1 ff ff       	call   80104e90 <argint>
80105cb2:	83 c4 10             	add    $0x10,%esp
80105cb5:	85 c0                	test   %eax,%eax
80105cb7:	0f 88 8a 00 00 00    	js     80105d47 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	68 60 a1 11 80       	push   $0x8011a160
80105cc5:	e8 b6 ed ff ff       	call   80104a80 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ccd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105cd0:	8b 1d a0 a9 11 80    	mov    0x8011a9a0,%ebx
  while(ticks - ticks0 < n){
80105cd6:	85 d2                	test   %edx,%edx
80105cd8:	75 27                	jne    80105d01 <sys_sleep+0x61>
80105cda:	eb 54                	jmp    80105d30 <sys_sleep+0x90>
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105ce0:	83 ec 08             	sub    $0x8,%esp
80105ce3:	68 60 a1 11 80       	push   $0x8011a160
80105ce8:	68 a0 a9 11 80       	push   $0x8011a9a0
80105ced:	e8 9e e4 ff ff       	call   80104190 <sleep>
  while(ticks - ticks0 < n){
80105cf2:	a1 a0 a9 11 80       	mov    0x8011a9a0,%eax
80105cf7:	83 c4 10             	add    $0x10,%esp
80105cfa:	29 d8                	sub    %ebx,%eax
80105cfc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105cff:	73 2f                	jae    80105d30 <sys_sleep+0x90>
    if(myproc()->killed){
80105d01:	e8 fa da ff ff       	call   80103800 <myproc>
80105d06:	8b 40 24             	mov    0x24(%eax),%eax
80105d09:	85 c0                	test   %eax,%eax
80105d0b:	74 d3                	je     80105ce0 <sys_sleep+0x40>
      release(&tickslock);
80105d0d:	83 ec 0c             	sub    $0xc,%esp
80105d10:	68 60 a1 11 80       	push   $0x8011a160
80105d15:	e8 26 ee ff ff       	call   80104b40 <release>
      return -1;
80105d1a:	83 c4 10             	add    $0x10,%esp
80105d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105d22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d25:	c9                   	leave  
80105d26:	c3                   	ret    
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	68 60 a1 11 80       	push   $0x8011a160
80105d38:	e8 03 ee ff ff       	call   80104b40 <release>
  return 0;
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	31 c0                	xor    %eax,%eax
}
80105d42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d45:	c9                   	leave  
80105d46:	c3                   	ret    
    return -1;
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d4c:	eb f4                	jmp    80105d42 <sys_sleep+0xa2>
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	53                   	push   %ebx
80105d54:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d57:	68 60 a1 11 80       	push   $0x8011a160
80105d5c:	e8 1f ed ff ff       	call   80104a80 <acquire>
  xticks = ticks;
80105d61:	8b 1d a0 a9 11 80    	mov    0x8011a9a0,%ebx
  release(&tickslock);
80105d67:	c7 04 24 60 a1 11 80 	movl   $0x8011a160,(%esp)
80105d6e:	e8 cd ed ff ff       	call   80104b40 <release>
  return xticks;
}
80105d73:	89 d8                	mov    %ebx,%eax
80105d75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d78:	c9                   	leave  
80105d79:	c3                   	ret    
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d80 <sys_sigprocmask>:

int
sys_sigprocmask(void){
80105d80:	55                   	push   %ebp
80105d81:	89 e5                	mov    %esp,%ebp
80105d83:	83 ec 20             	sub    $0x20,%esp
  int sigmask;
  if(argint(0, &sigmask) < 0)
80105d86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d89:	50                   	push   %eax
80105d8a:	6a 00                	push   $0x0
80105d8c:	e8 ff f0 ff ff       	call   80104e90 <argint>
80105d91:	83 c4 10             	add    $0x10,%esp
80105d94:	85 c0                	test   %eax,%eax
80105d96:	78 18                	js     80105db0 <sys_sigprocmask+0x30>
    return -1;
  return sigprocmask((uint)sigmask);
80105d98:	83 ec 0c             	sub    $0xc,%esp
80105d9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d9e:	e8 cd e6 ff ff       	call   80104470 <sigprocmask>
80105da3:	83 c4 10             	add    $0x10,%esp
}
80105da6:	c9                   	leave  
80105da7:	c3                   	ret    
80105da8:	90                   	nop
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dc0 <sys_sigaction>:

int
sys_sigaction(void){
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	83 ec 20             	sub    $0x20,%esp
  int signum;
  struct sigaction* act;
  struct sigaction* oldact;

  if(argint(0, &signum) < 0)
80105dc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dc9:	50                   	push   %eax
80105dca:	6a 00                	push   $0x0
80105dcc:	e8 bf f0 ff ff       	call   80104e90 <argint>
80105dd1:	83 c4 10             	add    $0x10,%esp
80105dd4:	85 c0                	test   %eax,%eax
80105dd6:	78 58                	js     80105e30 <sys_sigaction+0x70>
    return -1;
    
  if(signum==SIGKILL||signum==SIGSTOP||signum<0||signum>=SIGNAL_HANDLERS_SIZE)
80105dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ddb:	8d 50 f7             	lea    -0x9(%eax),%edx
80105dde:	83 e2 f7             	and    $0xfffffff7,%edx
80105de1:	74 4d                	je     80105e30 <sys_sigaction+0x70>
80105de3:	83 f8 1f             	cmp    $0x1f,%eax
80105de6:	77 48                	ja     80105e30 <sys_sigaction+0x70>
    return -1;

  if(argptr(1 , (void*)&act ,sizeof(*sigaction)) < 0){
80105de8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105deb:	83 ec 04             	sub    $0x4,%esp
80105dee:	6a 01                	push   $0x1
80105df0:	50                   	push   %eax
80105df1:	6a 01                	push   $0x1
80105df3:	e8 e8 f0 ff ff       	call   80104ee0 <argptr>
80105df8:	83 c4 10             	add    $0x10,%esp
80105dfb:	85 c0                	test   %eax,%eax
80105dfd:	78 31                	js     80105e30 <sys_sigaction+0x70>
    return -1;
  }
  if(argptr(2 , (void*)&oldact ,sizeof(*sigaction)) < 0){
80105dff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e02:	83 ec 04             	sub    $0x4,%esp
80105e05:	6a 01                	push   $0x1
80105e07:	50                   	push   %eax
80105e08:	6a 02                	push   $0x2
80105e0a:	e8 d1 f0 ff ff       	call   80104ee0 <argptr>
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	85 c0                	test   %eax,%eax
80105e14:	78 1a                	js     80105e30 <sys_sigaction+0x70>
    return -1;
  }

  return sigaction(signum, act, oldact);
80105e16:	83 ec 04             	sub    $0x4,%esp
80105e19:	ff 75 f4             	pushl  -0xc(%ebp)
80105e1c:	ff 75 f0             	pushl  -0x10(%ebp)
80105e1f:	ff 75 ec             	pushl  -0x14(%ebp)
80105e22:	e8 99 e6 ff ff       	call   801044c0 <sigaction>
80105e27:	83 c4 10             	add    $0x10,%esp
}
80105e2a:	c9                   	leave  
80105e2b:	c3                   	ret    
80105e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e35:	c9                   	leave  
80105e36:	c3                   	ret    
80105e37:	89 f6                	mov    %esi,%esi
80105e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e40 <sys_sigret>:

int 
sys_sigret(void){
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 08             	sub    $0x8,%esp
  sigret();
80105e46:	e8 65 e7 ff ff       	call   801045b0 <sigret>
  return 0;
80105e4b:	31 c0                	xor    %eax,%eax
80105e4d:	c9                   	leave  
80105e4e:	c3                   	ret    

80105e4f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e4f:	1e                   	push   %ds
  pushl %es
80105e50:	06                   	push   %es
  pushl %fs
80105e51:	0f a0                	push   %fs
  pushl %gs
80105e53:	0f a8                	push   %gs
  pushal
80105e55:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e56:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e5a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e5c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e5e:	54                   	push   %esp
  call trap
80105e5f:	e8 cc 00 00 00       	call   80105f30 <trap>
  addl $4, %esp
80105e64:	83 c4 04             	add    $0x4,%esp

80105e67 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  pushl %esp
80105e67:	54                   	push   %esp
  call handle_signals
80105e68:	e8 d3 e7 ff ff       	call   80104640 <handle_signals>
  addl $4, %esp
80105e6d:	83 c4 04             	add    $0x4,%esp
  popal
80105e70:	61                   	popa   
  popl %gs
80105e71:	0f a9                	pop    %gs
  popl %fs
80105e73:	0f a1                	pop    %fs
  popl %es
80105e75:	07                   	pop    %es
  popl %ds
80105e76:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e77:	83 c4 08             	add    $0x8,%esp
  iret
80105e7a:	cf                   	iret   
80105e7b:	66 90                	xchg   %ax,%ax
80105e7d:	66 90                	xchg   %ax,%ax
80105e7f:	90                   	nop

80105e80 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e80:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e81:	31 c0                	xor    %eax,%eax
{
80105e83:	89 e5                	mov    %esp,%ebp
80105e85:	83 ec 08             	sub    $0x8,%esp
80105e88:	90                   	nop
80105e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e90:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e97:	c7 04 c5 a2 a1 11 80 	movl   $0x8e000008,-0x7fee5e5e(,%eax,8)
80105e9e:	08 00 00 8e 
80105ea2:	66 89 14 c5 a0 a1 11 	mov    %dx,-0x7fee5e60(,%eax,8)
80105ea9:	80 
80105eaa:	c1 ea 10             	shr    $0x10,%edx
80105ead:	66 89 14 c5 a6 a1 11 	mov    %dx,-0x7fee5e5a(,%eax,8)
80105eb4:	80 
  for(i = 0; i < 256; i++)
80105eb5:	83 c0 01             	add    $0x1,%eax
80105eb8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ebd:	75 d1                	jne    80105e90 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ebf:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ec4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ec7:	c7 05 a2 a3 11 80 08 	movl   $0xef000008,0x8011a3a2
80105ece:	00 00 ef 
  initlock(&tickslock, "time");
80105ed1:	68 25 7f 10 80       	push   $0x80107f25
80105ed6:	68 60 a1 11 80       	push   $0x8011a160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105edb:	66 a3 a0 a3 11 80    	mov    %ax,0x8011a3a0
80105ee1:	c1 e8 10             	shr    $0x10,%eax
80105ee4:	66 a3 a6 a3 11 80    	mov    %ax,0x8011a3a6
  initlock(&tickslock, "time");
80105eea:	e8 51 ea ff ff       	call   80104940 <initlock>
}
80105eef:	83 c4 10             	add    $0x10,%esp
80105ef2:	c9                   	leave  
80105ef3:	c3                   	ret    
80105ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f00 <idtinit>:

void
idtinit(void)
{
80105f00:	55                   	push   %ebp
  pd[0] = size-1;
80105f01:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f06:	89 e5                	mov    %esp,%ebp
80105f08:	83 ec 10             	sub    $0x10,%esp
80105f0b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f0f:	b8 a0 a1 11 80       	mov    $0x8011a1a0,%eax
80105f14:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f18:	c1 e8 10             	shr    $0x10,%eax
80105f1b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f1f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f22:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f25:	c9                   	leave  
80105f26:	c3                   	ret    
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f30 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f30:	55                   	push   %ebp
80105f31:	89 e5                	mov    %esp,%ebp
80105f33:	57                   	push   %edi
80105f34:	56                   	push   %esi
80105f35:	53                   	push   %ebx
80105f36:	83 ec 1c             	sub    $0x1c,%esp
80105f39:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105f3c:	8b 47 30             	mov    0x30(%edi),%eax
80105f3f:	83 f8 40             	cmp    $0x40,%eax
80105f42:	0f 84 f0 00 00 00    	je     80106038 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f48:	83 e8 20             	sub    $0x20,%eax
80105f4b:	83 f8 1f             	cmp    $0x1f,%eax
80105f4e:	77 10                	ja     80105f60 <trap+0x30>
80105f50:	ff 24 85 cc 7f 10 80 	jmp    *-0x7fef8034(,%eax,4)
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f60:	e8 9b d8 ff ff       	call   80103800 <myproc>
80105f65:	85 c0                	test   %eax,%eax
80105f67:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f6a:	0f 84 14 02 00 00    	je     80106184 <trap+0x254>
80105f70:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f74:	0f 84 0a 02 00 00    	je     80106184 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f7a:	0f 20 d1             	mov    %cr2,%ecx
80105f7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f80:	e8 5b d8 ff ff       	call   801037e0 <cpuid>
80105f85:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f88:	8b 47 34             	mov    0x34(%edi),%eax
80105f8b:	8b 77 30             	mov    0x30(%edi),%esi
80105f8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f91:	e8 6a d8 ff ff       	call   80103800 <myproc>
80105f96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f99:	e8 62 d8 ff ff       	call   80103800 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fa1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fa4:	51                   	push   %ecx
80105fa5:	53                   	push   %ebx
80105fa6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105fa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105faa:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fad:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fae:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fb1:	52                   	push   %edx
80105fb2:	ff 70 10             	pushl  0x10(%eax)
80105fb5:	68 88 7f 10 80       	push   $0x80107f88
80105fba:	e8 a1 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105fbf:	83 c4 20             	add    $0x20,%esp
80105fc2:	e8 39 d8 ff ff       	call   80103800 <myproc>
80105fc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fce:	e8 2d d8 ff ff       	call   80103800 <myproc>
80105fd3:	85 c0                	test   %eax,%eax
80105fd5:	74 1d                	je     80105ff4 <trap+0xc4>
80105fd7:	e8 24 d8 ff ff       	call   80103800 <myproc>
80105fdc:	8b 50 24             	mov    0x24(%eax),%edx
80105fdf:	85 d2                	test   %edx,%edx
80105fe1:	74 11                	je     80105ff4 <trap+0xc4>
80105fe3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fe7:	83 e0 03             	and    $0x3,%eax
80105fea:	66 83 f8 03          	cmp    $0x3,%ax
80105fee:	0f 84 4c 01 00 00    	je     80106140 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ff4:	e8 07 d8 ff ff       	call   80103800 <myproc>
80105ff9:	85 c0                	test   %eax,%eax
80105ffb:	74 0d                	je     8010600a <trap+0xda>
80105ffd:	e8 fe d7 ff ff       	call   80103800 <myproc>
80106002:	8b 40 0c             	mov    0xc(%eax),%eax
80106005:	83 f8 04             	cmp    $0x4,%eax
80106008:	74 66                	je     80106070 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010600a:	e8 f1 d7 ff ff       	call   80103800 <myproc>
8010600f:	85 c0                	test   %eax,%eax
80106011:	74 19                	je     8010602c <trap+0xfc>
80106013:	e8 e8 d7 ff ff       	call   80103800 <myproc>
80106018:	8b 40 24             	mov    0x24(%eax),%eax
8010601b:	85 c0                	test   %eax,%eax
8010601d:	74 0d                	je     8010602c <trap+0xfc>
8010601f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106023:	83 e0 03             	and    $0x3,%eax
80106026:	66 83 f8 03          	cmp    $0x3,%ax
8010602a:	74 35                	je     80106061 <trap+0x131>
    exit();
}
8010602c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010602f:	5b                   	pop    %ebx
80106030:	5e                   	pop    %esi
80106031:	5f                   	pop    %edi
80106032:	5d                   	pop    %ebp
80106033:	c3                   	ret    
80106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106038:	e8 c3 d7 ff ff       	call   80103800 <myproc>
8010603d:	8b 58 24             	mov    0x24(%eax),%ebx
80106040:	85 db                	test   %ebx,%ebx
80106042:	0f 85 e8 00 00 00    	jne    80106130 <trap+0x200>
    myproc()->tf = tf;
80106048:	e8 b3 d7 ff ff       	call   80103800 <myproc>
8010604d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106050:	e8 2b ef ff ff       	call   80104f80 <syscall>
    if(myproc()->killed)
80106055:	e8 a6 d7 ff ff       	call   80103800 <myproc>
8010605a:	8b 48 24             	mov    0x24(%eax),%ecx
8010605d:	85 c9                	test   %ecx,%ecx
8010605f:	74 cb                	je     8010602c <trap+0xfc>
}
80106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
      exit();
80106068:	e9 b3 dd ff ff       	jmp    80103e20 <exit>
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106070:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106074:	75 94                	jne    8010600a <trap+0xda>
    yield();
80106076:	e8 b5 e0 ff ff       	call   80104130 <yield>
8010607b:	eb 8d                	jmp    8010600a <trap+0xda>
8010607d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106080:	e8 5b d7 ff ff       	call   801037e0 <cpuid>
80106085:	85 c0                	test   %eax,%eax
80106087:	0f 84 c3 00 00 00    	je     80106150 <trap+0x220>
    lapiceoi();
8010608d:	e8 fe c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106092:	e8 69 d7 ff ff       	call   80103800 <myproc>
80106097:	85 c0                	test   %eax,%eax
80106099:	0f 85 38 ff ff ff    	jne    80105fd7 <trap+0xa7>
8010609f:	e9 50 ff ff ff       	jmp    80105ff4 <trap+0xc4>
801060a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801060a8:	e8 a3 c5 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
801060ad:	e8 de c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060b2:	e8 49 d7 ff ff       	call   80103800 <myproc>
801060b7:	85 c0                	test   %eax,%eax
801060b9:	0f 85 18 ff ff ff    	jne    80105fd7 <trap+0xa7>
801060bf:	e9 30 ff ff ff       	jmp    80105ff4 <trap+0xc4>
801060c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801060c8:	e8 53 02 00 00       	call   80106320 <uartintr>
    lapiceoi();
801060cd:	e8 be c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d2:	e8 29 d7 ff ff       	call   80103800 <myproc>
801060d7:	85 c0                	test   %eax,%eax
801060d9:	0f 85 f8 fe ff ff    	jne    80105fd7 <trap+0xa7>
801060df:	e9 10 ff ff ff       	jmp    80105ff4 <trap+0xc4>
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060e8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060ec:	8b 77 38             	mov    0x38(%edi),%esi
801060ef:	e8 ec d6 ff ff       	call   801037e0 <cpuid>
801060f4:	56                   	push   %esi
801060f5:	53                   	push   %ebx
801060f6:	50                   	push   %eax
801060f7:	68 30 7f 10 80       	push   $0x80107f30
801060fc:	e8 5f a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106101:	e8 8a c6 ff ff       	call   80102790 <lapiceoi>
    break;
80106106:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106109:	e8 f2 d6 ff ff       	call   80103800 <myproc>
8010610e:	85 c0                	test   %eax,%eax
80106110:	0f 85 c1 fe ff ff    	jne    80105fd7 <trap+0xa7>
80106116:	e9 d9 fe ff ff       	jmp    80105ff4 <trap+0xc4>
8010611b:	90                   	nop
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106120:	e8 8b bf ff ff       	call   801020b0 <ideintr>
80106125:	e9 63 ff ff ff       	jmp    8010608d <trap+0x15d>
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106130:	e8 eb dc ff ff       	call   80103e20 <exit>
80106135:	e9 0e ff ff ff       	jmp    80106048 <trap+0x118>
8010613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106140:	e8 db dc ff ff       	call   80103e20 <exit>
80106145:	e9 aa fe ff ff       	jmp    80105ff4 <trap+0xc4>
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 60 a1 11 80       	push   $0x8011a160
80106158:	e8 23 e9 ff ff       	call   80104a80 <acquire>
      wakeup(&ticks);
8010615d:	c7 04 24 a0 a9 11 80 	movl   $0x8011a9a0,(%esp)
      ticks++;
80106164:	83 05 a0 a9 11 80 01 	addl   $0x1,0x8011a9a0
      wakeup(&ticks);
8010616b:	e8 e0 e0 ff ff       	call   80104250 <wakeup>
      release(&tickslock);
80106170:	c7 04 24 60 a1 11 80 	movl   $0x8011a160,(%esp)
80106177:	e8 c4 e9 ff ff       	call   80104b40 <release>
8010617c:	83 c4 10             	add    $0x10,%esp
8010617f:	e9 09 ff ff ff       	jmp    8010608d <trap+0x15d>
80106184:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106187:	e8 54 d6 ff ff       	call   801037e0 <cpuid>
8010618c:	83 ec 0c             	sub    $0xc,%esp
8010618f:	56                   	push   %esi
80106190:	53                   	push   %ebx
80106191:	50                   	push   %eax
80106192:	ff 77 30             	pushl  0x30(%edi)
80106195:	68 54 7f 10 80       	push   $0x80107f54
8010619a:	e8 c1 a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010619f:	83 c4 14             	add    $0x14,%esp
801061a2:	68 2a 7f 10 80       	push   $0x80107f2a
801061a7:	e8 e4 a1 ff ff       	call   80100390 <panic>
801061ac:	66 90                	xchg   %ax,%ax
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801061b0:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
801061b5:	55                   	push   %ebp
801061b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061b8:	85 c0                	test   %eax,%eax
801061ba:	74 1c                	je     801061d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061c1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801061c2:	a8 01                	test   $0x1,%al
801061c4:	74 12                	je     801061d8 <uartgetc+0x28>
801061c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061cb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801061cc:	0f b6 c0             	movzbl %al,%eax
}
801061cf:	5d                   	pop    %ebp
801061d0:	c3                   	ret    
801061d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061dd:	5d                   	pop    %ebp
801061de:	c3                   	ret    
801061df:	90                   	nop

801061e0 <uartputc.part.0>:
uartputc(int c)
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
801061e6:	89 c7                	mov    %eax,%edi
801061e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801061f2:	83 ec 0c             	sub    $0xc,%esp
801061f5:	eb 1b                	jmp    80106212 <uartputc.part.0+0x32>
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106200:	83 ec 0c             	sub    $0xc,%esp
80106203:	6a 0a                	push   $0xa
80106205:	e8 a6 c5 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010620a:	83 c4 10             	add    $0x10,%esp
8010620d:	83 eb 01             	sub    $0x1,%ebx
80106210:	74 07                	je     80106219 <uartputc.part.0+0x39>
80106212:	89 f2                	mov    %esi,%edx
80106214:	ec                   	in     (%dx),%al
80106215:	a8 20                	test   $0x20,%al
80106217:	74 e7                	je     80106200 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106219:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010621e:	89 f8                	mov    %edi,%eax
80106220:	ee                   	out    %al,(%dx)
}
80106221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartinit>:
{
80106230:	55                   	push   %ebp
80106231:	31 c9                	xor    %ecx,%ecx
80106233:	89 c8                	mov    %ecx,%eax
80106235:	89 e5                	mov    %esp,%ebp
80106237:	57                   	push   %edi
80106238:	56                   	push   %esi
80106239:	53                   	push   %ebx
8010623a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010623f:	89 da                	mov    %ebx,%edx
80106241:	83 ec 0c             	sub    $0xc,%esp
80106244:	ee                   	out    %al,(%dx)
80106245:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010624a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010624f:	89 fa                	mov    %edi,%edx
80106251:	ee                   	out    %al,(%dx)
80106252:	b8 0c 00 00 00       	mov    $0xc,%eax
80106257:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010625c:	ee                   	out    %al,(%dx)
8010625d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106262:	89 c8                	mov    %ecx,%eax
80106264:	89 f2                	mov    %esi,%edx
80106266:	ee                   	out    %al,(%dx)
80106267:	b8 03 00 00 00       	mov    $0x3,%eax
8010626c:	89 fa                	mov    %edi,%edx
8010626e:	ee                   	out    %al,(%dx)
8010626f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106274:	89 c8                	mov    %ecx,%eax
80106276:	ee                   	out    %al,(%dx)
80106277:	b8 01 00 00 00       	mov    $0x1,%eax
8010627c:	89 f2                	mov    %esi,%edx
8010627e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010627f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106284:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106285:	3c ff                	cmp    $0xff,%al
80106287:	74 5a                	je     801062e3 <uartinit+0xb3>
  uart = 1;
80106289:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106290:	00 00 00 
80106293:	89 da                	mov    %ebx,%edx
80106295:	ec                   	in     (%dx),%al
80106296:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010629c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010629f:	bb 4c 80 10 80       	mov    $0x8010804c,%ebx
  ioapicenable(IRQ_COM1, 0);
801062a4:	6a 00                	push   $0x0
801062a6:	6a 04                	push   $0x4
801062a8:	e8 63 c0 ff ff       	call   80102310 <ioapicenable>
801062ad:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801062b0:	b8 78 00 00 00       	mov    $0x78,%eax
801062b5:	eb 13                	jmp    801062ca <uartinit+0x9a>
801062b7:	89 f6                	mov    %esi,%esi
801062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062c0:	83 c3 01             	add    $0x1,%ebx
801062c3:	0f be 03             	movsbl (%ebx),%eax
801062c6:	84 c0                	test   %al,%al
801062c8:	74 19                	je     801062e3 <uartinit+0xb3>
  if(!uart)
801062ca:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801062d0:	85 d2                	test   %edx,%edx
801062d2:	74 ec                	je     801062c0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801062d4:	83 c3 01             	add    $0x1,%ebx
801062d7:	e8 04 ff ff ff       	call   801061e0 <uartputc.part.0>
801062dc:	0f be 03             	movsbl (%ebx),%eax
801062df:	84 c0                	test   %al,%al
801062e1:	75 e7                	jne    801062ca <uartinit+0x9a>
}
801062e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e6:	5b                   	pop    %ebx
801062e7:	5e                   	pop    %esi
801062e8:	5f                   	pop    %edi
801062e9:	5d                   	pop    %ebp
801062ea:	c3                   	ret    
801062eb:	90                   	nop
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062f0 <uartputc>:
  if(!uart)
801062f0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801062f6:	55                   	push   %ebp
801062f7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062f9:	85 d2                	test   %edx,%edx
{
801062fb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801062fe:	74 10                	je     80106310 <uartputc+0x20>
}
80106300:	5d                   	pop    %ebp
80106301:	e9 da fe ff ff       	jmp    801061e0 <uartputc.part.0>
80106306:	8d 76 00             	lea    0x0(%esi),%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106310:	5d                   	pop    %ebp
80106311:	c3                   	ret    
80106312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106320 <uartintr>:

void
uartintr(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106326:	68 b0 61 10 80       	push   $0x801061b0
8010632b:	e8 e0 a4 ff ff       	call   80100810 <consoleintr>
}
80106330:	83 c4 10             	add    $0x10,%esp
80106333:	c9                   	leave  
80106334:	c3                   	ret    

80106335 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106335:	6a 00                	push   $0x0
  pushl $0
80106337:	6a 00                	push   $0x0
  jmp alltraps
80106339:	e9 11 fb ff ff       	jmp    80105e4f <alltraps>

8010633e <vector1>:
.globl vector1
vector1:
  pushl $0
8010633e:	6a 00                	push   $0x0
  pushl $1
80106340:	6a 01                	push   $0x1
  jmp alltraps
80106342:	e9 08 fb ff ff       	jmp    80105e4f <alltraps>

80106347 <vector2>:
.globl vector2
vector2:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $2
80106349:	6a 02                	push   $0x2
  jmp alltraps
8010634b:	e9 ff fa ff ff       	jmp    80105e4f <alltraps>

80106350 <vector3>:
.globl vector3
vector3:
  pushl $0
80106350:	6a 00                	push   $0x0
  pushl $3
80106352:	6a 03                	push   $0x3
  jmp alltraps
80106354:	e9 f6 fa ff ff       	jmp    80105e4f <alltraps>

80106359 <vector4>:
.globl vector4
vector4:
  pushl $0
80106359:	6a 00                	push   $0x0
  pushl $4
8010635b:	6a 04                	push   $0x4
  jmp alltraps
8010635d:	e9 ed fa ff ff       	jmp    80105e4f <alltraps>

80106362 <vector5>:
.globl vector5
vector5:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $5
80106364:	6a 05                	push   $0x5
  jmp alltraps
80106366:	e9 e4 fa ff ff       	jmp    80105e4f <alltraps>

8010636b <vector6>:
.globl vector6
vector6:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $6
8010636d:	6a 06                	push   $0x6
  jmp alltraps
8010636f:	e9 db fa ff ff       	jmp    80105e4f <alltraps>

80106374 <vector7>:
.globl vector7
vector7:
  pushl $0
80106374:	6a 00                	push   $0x0
  pushl $7
80106376:	6a 07                	push   $0x7
  jmp alltraps
80106378:	e9 d2 fa ff ff       	jmp    80105e4f <alltraps>

8010637d <vector8>:
.globl vector8
vector8:
  pushl $8
8010637d:	6a 08                	push   $0x8
  jmp alltraps
8010637f:	e9 cb fa ff ff       	jmp    80105e4f <alltraps>

80106384 <vector9>:
.globl vector9
vector9:
  pushl $0
80106384:	6a 00                	push   $0x0
  pushl $9
80106386:	6a 09                	push   $0x9
  jmp alltraps
80106388:	e9 c2 fa ff ff       	jmp    80105e4f <alltraps>

8010638d <vector10>:
.globl vector10
vector10:
  pushl $10
8010638d:	6a 0a                	push   $0xa
  jmp alltraps
8010638f:	e9 bb fa ff ff       	jmp    80105e4f <alltraps>

80106394 <vector11>:
.globl vector11
vector11:
  pushl $11
80106394:	6a 0b                	push   $0xb
  jmp alltraps
80106396:	e9 b4 fa ff ff       	jmp    80105e4f <alltraps>

8010639b <vector12>:
.globl vector12
vector12:
  pushl $12
8010639b:	6a 0c                	push   $0xc
  jmp alltraps
8010639d:	e9 ad fa ff ff       	jmp    80105e4f <alltraps>

801063a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801063a2:	6a 0d                	push   $0xd
  jmp alltraps
801063a4:	e9 a6 fa ff ff       	jmp    80105e4f <alltraps>

801063a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801063a9:	6a 0e                	push   $0xe
  jmp alltraps
801063ab:	e9 9f fa ff ff       	jmp    80105e4f <alltraps>

801063b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $15
801063b2:	6a 0f                	push   $0xf
  jmp alltraps
801063b4:	e9 96 fa ff ff       	jmp    80105e4f <alltraps>

801063b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $16
801063bb:	6a 10                	push   $0x10
  jmp alltraps
801063bd:	e9 8d fa ff ff       	jmp    80105e4f <alltraps>

801063c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801063c2:	6a 11                	push   $0x11
  jmp alltraps
801063c4:	e9 86 fa ff ff       	jmp    80105e4f <alltraps>

801063c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $18
801063cb:	6a 12                	push   $0x12
  jmp alltraps
801063cd:	e9 7d fa ff ff       	jmp    80105e4f <alltraps>

801063d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $19
801063d4:	6a 13                	push   $0x13
  jmp alltraps
801063d6:	e9 74 fa ff ff       	jmp    80105e4f <alltraps>

801063db <vector20>:
.globl vector20
vector20:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $20
801063dd:	6a 14                	push   $0x14
  jmp alltraps
801063df:	e9 6b fa ff ff       	jmp    80105e4f <alltraps>

801063e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $21
801063e6:	6a 15                	push   $0x15
  jmp alltraps
801063e8:	e9 62 fa ff ff       	jmp    80105e4f <alltraps>

801063ed <vector22>:
.globl vector22
vector22:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $22
801063ef:	6a 16                	push   $0x16
  jmp alltraps
801063f1:	e9 59 fa ff ff       	jmp    80105e4f <alltraps>

801063f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $23
801063f8:	6a 17                	push   $0x17
  jmp alltraps
801063fa:	e9 50 fa ff ff       	jmp    80105e4f <alltraps>

801063ff <vector24>:
.globl vector24
vector24:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $24
80106401:	6a 18                	push   $0x18
  jmp alltraps
80106403:	e9 47 fa ff ff       	jmp    80105e4f <alltraps>

80106408 <vector25>:
.globl vector25
vector25:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $25
8010640a:	6a 19                	push   $0x19
  jmp alltraps
8010640c:	e9 3e fa ff ff       	jmp    80105e4f <alltraps>

80106411 <vector26>:
.globl vector26
vector26:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $26
80106413:	6a 1a                	push   $0x1a
  jmp alltraps
80106415:	e9 35 fa ff ff       	jmp    80105e4f <alltraps>

8010641a <vector27>:
.globl vector27
vector27:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $27
8010641c:	6a 1b                	push   $0x1b
  jmp alltraps
8010641e:	e9 2c fa ff ff       	jmp    80105e4f <alltraps>

80106423 <vector28>:
.globl vector28
vector28:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $28
80106425:	6a 1c                	push   $0x1c
  jmp alltraps
80106427:	e9 23 fa ff ff       	jmp    80105e4f <alltraps>

8010642c <vector29>:
.globl vector29
vector29:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $29
8010642e:	6a 1d                	push   $0x1d
  jmp alltraps
80106430:	e9 1a fa ff ff       	jmp    80105e4f <alltraps>

80106435 <vector30>:
.globl vector30
vector30:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $30
80106437:	6a 1e                	push   $0x1e
  jmp alltraps
80106439:	e9 11 fa ff ff       	jmp    80105e4f <alltraps>

8010643e <vector31>:
.globl vector31
vector31:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $31
80106440:	6a 1f                	push   $0x1f
  jmp alltraps
80106442:	e9 08 fa ff ff       	jmp    80105e4f <alltraps>

80106447 <vector32>:
.globl vector32
vector32:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $32
80106449:	6a 20                	push   $0x20
  jmp alltraps
8010644b:	e9 ff f9 ff ff       	jmp    80105e4f <alltraps>

80106450 <vector33>:
.globl vector33
vector33:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $33
80106452:	6a 21                	push   $0x21
  jmp alltraps
80106454:	e9 f6 f9 ff ff       	jmp    80105e4f <alltraps>

80106459 <vector34>:
.globl vector34
vector34:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $34
8010645b:	6a 22                	push   $0x22
  jmp alltraps
8010645d:	e9 ed f9 ff ff       	jmp    80105e4f <alltraps>

80106462 <vector35>:
.globl vector35
vector35:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $35
80106464:	6a 23                	push   $0x23
  jmp alltraps
80106466:	e9 e4 f9 ff ff       	jmp    80105e4f <alltraps>

8010646b <vector36>:
.globl vector36
vector36:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $36
8010646d:	6a 24                	push   $0x24
  jmp alltraps
8010646f:	e9 db f9 ff ff       	jmp    80105e4f <alltraps>

80106474 <vector37>:
.globl vector37
vector37:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $37
80106476:	6a 25                	push   $0x25
  jmp alltraps
80106478:	e9 d2 f9 ff ff       	jmp    80105e4f <alltraps>

8010647d <vector38>:
.globl vector38
vector38:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $38
8010647f:	6a 26                	push   $0x26
  jmp alltraps
80106481:	e9 c9 f9 ff ff       	jmp    80105e4f <alltraps>

80106486 <vector39>:
.globl vector39
vector39:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $39
80106488:	6a 27                	push   $0x27
  jmp alltraps
8010648a:	e9 c0 f9 ff ff       	jmp    80105e4f <alltraps>

8010648f <vector40>:
.globl vector40
vector40:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $40
80106491:	6a 28                	push   $0x28
  jmp alltraps
80106493:	e9 b7 f9 ff ff       	jmp    80105e4f <alltraps>

80106498 <vector41>:
.globl vector41
vector41:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $41
8010649a:	6a 29                	push   $0x29
  jmp alltraps
8010649c:	e9 ae f9 ff ff       	jmp    80105e4f <alltraps>

801064a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $42
801064a3:	6a 2a                	push   $0x2a
  jmp alltraps
801064a5:	e9 a5 f9 ff ff       	jmp    80105e4f <alltraps>

801064aa <vector43>:
.globl vector43
vector43:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $43
801064ac:	6a 2b                	push   $0x2b
  jmp alltraps
801064ae:	e9 9c f9 ff ff       	jmp    80105e4f <alltraps>

801064b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $44
801064b5:	6a 2c                	push   $0x2c
  jmp alltraps
801064b7:	e9 93 f9 ff ff       	jmp    80105e4f <alltraps>

801064bc <vector45>:
.globl vector45
vector45:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $45
801064be:	6a 2d                	push   $0x2d
  jmp alltraps
801064c0:	e9 8a f9 ff ff       	jmp    80105e4f <alltraps>

801064c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $46
801064c7:	6a 2e                	push   $0x2e
  jmp alltraps
801064c9:	e9 81 f9 ff ff       	jmp    80105e4f <alltraps>

801064ce <vector47>:
.globl vector47
vector47:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $47
801064d0:	6a 2f                	push   $0x2f
  jmp alltraps
801064d2:	e9 78 f9 ff ff       	jmp    80105e4f <alltraps>

801064d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $48
801064d9:	6a 30                	push   $0x30
  jmp alltraps
801064db:	e9 6f f9 ff ff       	jmp    80105e4f <alltraps>

801064e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $49
801064e2:	6a 31                	push   $0x31
  jmp alltraps
801064e4:	e9 66 f9 ff ff       	jmp    80105e4f <alltraps>

801064e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $50
801064eb:	6a 32                	push   $0x32
  jmp alltraps
801064ed:	e9 5d f9 ff ff       	jmp    80105e4f <alltraps>

801064f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $51
801064f4:	6a 33                	push   $0x33
  jmp alltraps
801064f6:	e9 54 f9 ff ff       	jmp    80105e4f <alltraps>

801064fb <vector52>:
.globl vector52
vector52:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $52
801064fd:	6a 34                	push   $0x34
  jmp alltraps
801064ff:	e9 4b f9 ff ff       	jmp    80105e4f <alltraps>

80106504 <vector53>:
.globl vector53
vector53:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $53
80106506:	6a 35                	push   $0x35
  jmp alltraps
80106508:	e9 42 f9 ff ff       	jmp    80105e4f <alltraps>

8010650d <vector54>:
.globl vector54
vector54:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $54
8010650f:	6a 36                	push   $0x36
  jmp alltraps
80106511:	e9 39 f9 ff ff       	jmp    80105e4f <alltraps>

80106516 <vector55>:
.globl vector55
vector55:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $55
80106518:	6a 37                	push   $0x37
  jmp alltraps
8010651a:	e9 30 f9 ff ff       	jmp    80105e4f <alltraps>

8010651f <vector56>:
.globl vector56
vector56:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $56
80106521:	6a 38                	push   $0x38
  jmp alltraps
80106523:	e9 27 f9 ff ff       	jmp    80105e4f <alltraps>

80106528 <vector57>:
.globl vector57
vector57:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $57
8010652a:	6a 39                	push   $0x39
  jmp alltraps
8010652c:	e9 1e f9 ff ff       	jmp    80105e4f <alltraps>

80106531 <vector58>:
.globl vector58
vector58:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $58
80106533:	6a 3a                	push   $0x3a
  jmp alltraps
80106535:	e9 15 f9 ff ff       	jmp    80105e4f <alltraps>

8010653a <vector59>:
.globl vector59
vector59:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $59
8010653c:	6a 3b                	push   $0x3b
  jmp alltraps
8010653e:	e9 0c f9 ff ff       	jmp    80105e4f <alltraps>

80106543 <vector60>:
.globl vector60
vector60:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $60
80106545:	6a 3c                	push   $0x3c
  jmp alltraps
80106547:	e9 03 f9 ff ff       	jmp    80105e4f <alltraps>

8010654c <vector61>:
.globl vector61
vector61:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $61
8010654e:	6a 3d                	push   $0x3d
  jmp alltraps
80106550:	e9 fa f8 ff ff       	jmp    80105e4f <alltraps>

80106555 <vector62>:
.globl vector62
vector62:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $62
80106557:	6a 3e                	push   $0x3e
  jmp alltraps
80106559:	e9 f1 f8 ff ff       	jmp    80105e4f <alltraps>

8010655e <vector63>:
.globl vector63
vector63:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $63
80106560:	6a 3f                	push   $0x3f
  jmp alltraps
80106562:	e9 e8 f8 ff ff       	jmp    80105e4f <alltraps>

80106567 <vector64>:
.globl vector64
vector64:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $64
80106569:	6a 40                	push   $0x40
  jmp alltraps
8010656b:	e9 df f8 ff ff       	jmp    80105e4f <alltraps>

80106570 <vector65>:
.globl vector65
vector65:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $65
80106572:	6a 41                	push   $0x41
  jmp alltraps
80106574:	e9 d6 f8 ff ff       	jmp    80105e4f <alltraps>

80106579 <vector66>:
.globl vector66
vector66:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $66
8010657b:	6a 42                	push   $0x42
  jmp alltraps
8010657d:	e9 cd f8 ff ff       	jmp    80105e4f <alltraps>

80106582 <vector67>:
.globl vector67
vector67:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $67
80106584:	6a 43                	push   $0x43
  jmp alltraps
80106586:	e9 c4 f8 ff ff       	jmp    80105e4f <alltraps>

8010658b <vector68>:
.globl vector68
vector68:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $68
8010658d:	6a 44                	push   $0x44
  jmp alltraps
8010658f:	e9 bb f8 ff ff       	jmp    80105e4f <alltraps>

80106594 <vector69>:
.globl vector69
vector69:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $69
80106596:	6a 45                	push   $0x45
  jmp alltraps
80106598:	e9 b2 f8 ff ff       	jmp    80105e4f <alltraps>

8010659d <vector70>:
.globl vector70
vector70:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $70
8010659f:	6a 46                	push   $0x46
  jmp alltraps
801065a1:	e9 a9 f8 ff ff       	jmp    80105e4f <alltraps>

801065a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $71
801065a8:	6a 47                	push   $0x47
  jmp alltraps
801065aa:	e9 a0 f8 ff ff       	jmp    80105e4f <alltraps>

801065af <vector72>:
.globl vector72
vector72:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $72
801065b1:	6a 48                	push   $0x48
  jmp alltraps
801065b3:	e9 97 f8 ff ff       	jmp    80105e4f <alltraps>

801065b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $73
801065ba:	6a 49                	push   $0x49
  jmp alltraps
801065bc:	e9 8e f8 ff ff       	jmp    80105e4f <alltraps>

801065c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $74
801065c3:	6a 4a                	push   $0x4a
  jmp alltraps
801065c5:	e9 85 f8 ff ff       	jmp    80105e4f <alltraps>

801065ca <vector75>:
.globl vector75
vector75:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $75
801065cc:	6a 4b                	push   $0x4b
  jmp alltraps
801065ce:	e9 7c f8 ff ff       	jmp    80105e4f <alltraps>

801065d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $76
801065d5:	6a 4c                	push   $0x4c
  jmp alltraps
801065d7:	e9 73 f8 ff ff       	jmp    80105e4f <alltraps>

801065dc <vector77>:
.globl vector77
vector77:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $77
801065de:	6a 4d                	push   $0x4d
  jmp alltraps
801065e0:	e9 6a f8 ff ff       	jmp    80105e4f <alltraps>

801065e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $78
801065e7:	6a 4e                	push   $0x4e
  jmp alltraps
801065e9:	e9 61 f8 ff ff       	jmp    80105e4f <alltraps>

801065ee <vector79>:
.globl vector79
vector79:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $79
801065f0:	6a 4f                	push   $0x4f
  jmp alltraps
801065f2:	e9 58 f8 ff ff       	jmp    80105e4f <alltraps>

801065f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $80
801065f9:	6a 50                	push   $0x50
  jmp alltraps
801065fb:	e9 4f f8 ff ff       	jmp    80105e4f <alltraps>

80106600 <vector81>:
.globl vector81
vector81:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $81
80106602:	6a 51                	push   $0x51
  jmp alltraps
80106604:	e9 46 f8 ff ff       	jmp    80105e4f <alltraps>

80106609 <vector82>:
.globl vector82
vector82:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $82
8010660b:	6a 52                	push   $0x52
  jmp alltraps
8010660d:	e9 3d f8 ff ff       	jmp    80105e4f <alltraps>

80106612 <vector83>:
.globl vector83
vector83:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $83
80106614:	6a 53                	push   $0x53
  jmp alltraps
80106616:	e9 34 f8 ff ff       	jmp    80105e4f <alltraps>

8010661b <vector84>:
.globl vector84
vector84:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $84
8010661d:	6a 54                	push   $0x54
  jmp alltraps
8010661f:	e9 2b f8 ff ff       	jmp    80105e4f <alltraps>

80106624 <vector85>:
.globl vector85
vector85:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $85
80106626:	6a 55                	push   $0x55
  jmp alltraps
80106628:	e9 22 f8 ff ff       	jmp    80105e4f <alltraps>

8010662d <vector86>:
.globl vector86
vector86:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $86
8010662f:	6a 56                	push   $0x56
  jmp alltraps
80106631:	e9 19 f8 ff ff       	jmp    80105e4f <alltraps>

80106636 <vector87>:
.globl vector87
vector87:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $87
80106638:	6a 57                	push   $0x57
  jmp alltraps
8010663a:	e9 10 f8 ff ff       	jmp    80105e4f <alltraps>

8010663f <vector88>:
.globl vector88
vector88:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $88
80106641:	6a 58                	push   $0x58
  jmp alltraps
80106643:	e9 07 f8 ff ff       	jmp    80105e4f <alltraps>

80106648 <vector89>:
.globl vector89
vector89:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $89
8010664a:	6a 59                	push   $0x59
  jmp alltraps
8010664c:	e9 fe f7 ff ff       	jmp    80105e4f <alltraps>

80106651 <vector90>:
.globl vector90
vector90:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $90
80106653:	6a 5a                	push   $0x5a
  jmp alltraps
80106655:	e9 f5 f7 ff ff       	jmp    80105e4f <alltraps>

8010665a <vector91>:
.globl vector91
vector91:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $91
8010665c:	6a 5b                	push   $0x5b
  jmp alltraps
8010665e:	e9 ec f7 ff ff       	jmp    80105e4f <alltraps>

80106663 <vector92>:
.globl vector92
vector92:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $92
80106665:	6a 5c                	push   $0x5c
  jmp alltraps
80106667:	e9 e3 f7 ff ff       	jmp    80105e4f <alltraps>

8010666c <vector93>:
.globl vector93
vector93:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $93
8010666e:	6a 5d                	push   $0x5d
  jmp alltraps
80106670:	e9 da f7 ff ff       	jmp    80105e4f <alltraps>

80106675 <vector94>:
.globl vector94
vector94:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $94
80106677:	6a 5e                	push   $0x5e
  jmp alltraps
80106679:	e9 d1 f7 ff ff       	jmp    80105e4f <alltraps>

8010667e <vector95>:
.globl vector95
vector95:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $95
80106680:	6a 5f                	push   $0x5f
  jmp alltraps
80106682:	e9 c8 f7 ff ff       	jmp    80105e4f <alltraps>

80106687 <vector96>:
.globl vector96
vector96:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $96
80106689:	6a 60                	push   $0x60
  jmp alltraps
8010668b:	e9 bf f7 ff ff       	jmp    80105e4f <alltraps>

80106690 <vector97>:
.globl vector97
vector97:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $97
80106692:	6a 61                	push   $0x61
  jmp alltraps
80106694:	e9 b6 f7 ff ff       	jmp    80105e4f <alltraps>

80106699 <vector98>:
.globl vector98
vector98:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $98
8010669b:	6a 62                	push   $0x62
  jmp alltraps
8010669d:	e9 ad f7 ff ff       	jmp    80105e4f <alltraps>

801066a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $99
801066a4:	6a 63                	push   $0x63
  jmp alltraps
801066a6:	e9 a4 f7 ff ff       	jmp    80105e4f <alltraps>

801066ab <vector100>:
.globl vector100
vector100:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $100
801066ad:	6a 64                	push   $0x64
  jmp alltraps
801066af:	e9 9b f7 ff ff       	jmp    80105e4f <alltraps>

801066b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $101
801066b6:	6a 65                	push   $0x65
  jmp alltraps
801066b8:	e9 92 f7 ff ff       	jmp    80105e4f <alltraps>

801066bd <vector102>:
.globl vector102
vector102:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $102
801066bf:	6a 66                	push   $0x66
  jmp alltraps
801066c1:	e9 89 f7 ff ff       	jmp    80105e4f <alltraps>

801066c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $103
801066c8:	6a 67                	push   $0x67
  jmp alltraps
801066ca:	e9 80 f7 ff ff       	jmp    80105e4f <alltraps>

801066cf <vector104>:
.globl vector104
vector104:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $104
801066d1:	6a 68                	push   $0x68
  jmp alltraps
801066d3:	e9 77 f7 ff ff       	jmp    80105e4f <alltraps>

801066d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $105
801066da:	6a 69                	push   $0x69
  jmp alltraps
801066dc:	e9 6e f7 ff ff       	jmp    80105e4f <alltraps>

801066e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $106
801066e3:	6a 6a                	push   $0x6a
  jmp alltraps
801066e5:	e9 65 f7 ff ff       	jmp    80105e4f <alltraps>

801066ea <vector107>:
.globl vector107
vector107:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $107
801066ec:	6a 6b                	push   $0x6b
  jmp alltraps
801066ee:	e9 5c f7 ff ff       	jmp    80105e4f <alltraps>

801066f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $108
801066f5:	6a 6c                	push   $0x6c
  jmp alltraps
801066f7:	e9 53 f7 ff ff       	jmp    80105e4f <alltraps>

801066fc <vector109>:
.globl vector109
vector109:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $109
801066fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106700:	e9 4a f7 ff ff       	jmp    80105e4f <alltraps>

80106705 <vector110>:
.globl vector110
vector110:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $110
80106707:	6a 6e                	push   $0x6e
  jmp alltraps
80106709:	e9 41 f7 ff ff       	jmp    80105e4f <alltraps>

8010670e <vector111>:
.globl vector111
vector111:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $111
80106710:	6a 6f                	push   $0x6f
  jmp alltraps
80106712:	e9 38 f7 ff ff       	jmp    80105e4f <alltraps>

80106717 <vector112>:
.globl vector112
vector112:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $112
80106719:	6a 70                	push   $0x70
  jmp alltraps
8010671b:	e9 2f f7 ff ff       	jmp    80105e4f <alltraps>

80106720 <vector113>:
.globl vector113
vector113:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $113
80106722:	6a 71                	push   $0x71
  jmp alltraps
80106724:	e9 26 f7 ff ff       	jmp    80105e4f <alltraps>

80106729 <vector114>:
.globl vector114
vector114:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $114
8010672b:	6a 72                	push   $0x72
  jmp alltraps
8010672d:	e9 1d f7 ff ff       	jmp    80105e4f <alltraps>

80106732 <vector115>:
.globl vector115
vector115:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $115
80106734:	6a 73                	push   $0x73
  jmp alltraps
80106736:	e9 14 f7 ff ff       	jmp    80105e4f <alltraps>

8010673b <vector116>:
.globl vector116
vector116:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $116
8010673d:	6a 74                	push   $0x74
  jmp alltraps
8010673f:	e9 0b f7 ff ff       	jmp    80105e4f <alltraps>

80106744 <vector117>:
.globl vector117
vector117:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $117
80106746:	6a 75                	push   $0x75
  jmp alltraps
80106748:	e9 02 f7 ff ff       	jmp    80105e4f <alltraps>

8010674d <vector118>:
.globl vector118
vector118:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $118
8010674f:	6a 76                	push   $0x76
  jmp alltraps
80106751:	e9 f9 f6 ff ff       	jmp    80105e4f <alltraps>

80106756 <vector119>:
.globl vector119
vector119:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $119
80106758:	6a 77                	push   $0x77
  jmp alltraps
8010675a:	e9 f0 f6 ff ff       	jmp    80105e4f <alltraps>

8010675f <vector120>:
.globl vector120
vector120:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $120
80106761:	6a 78                	push   $0x78
  jmp alltraps
80106763:	e9 e7 f6 ff ff       	jmp    80105e4f <alltraps>

80106768 <vector121>:
.globl vector121
vector121:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $121
8010676a:	6a 79                	push   $0x79
  jmp alltraps
8010676c:	e9 de f6 ff ff       	jmp    80105e4f <alltraps>

80106771 <vector122>:
.globl vector122
vector122:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $122
80106773:	6a 7a                	push   $0x7a
  jmp alltraps
80106775:	e9 d5 f6 ff ff       	jmp    80105e4f <alltraps>

8010677a <vector123>:
.globl vector123
vector123:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $123
8010677c:	6a 7b                	push   $0x7b
  jmp alltraps
8010677e:	e9 cc f6 ff ff       	jmp    80105e4f <alltraps>

80106783 <vector124>:
.globl vector124
vector124:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $124
80106785:	6a 7c                	push   $0x7c
  jmp alltraps
80106787:	e9 c3 f6 ff ff       	jmp    80105e4f <alltraps>

8010678c <vector125>:
.globl vector125
vector125:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $125
8010678e:	6a 7d                	push   $0x7d
  jmp alltraps
80106790:	e9 ba f6 ff ff       	jmp    80105e4f <alltraps>

80106795 <vector126>:
.globl vector126
vector126:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $126
80106797:	6a 7e                	push   $0x7e
  jmp alltraps
80106799:	e9 b1 f6 ff ff       	jmp    80105e4f <alltraps>

8010679e <vector127>:
.globl vector127
vector127:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $127
801067a0:	6a 7f                	push   $0x7f
  jmp alltraps
801067a2:	e9 a8 f6 ff ff       	jmp    80105e4f <alltraps>

801067a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $128
801067a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067ae:	e9 9c f6 ff ff       	jmp    80105e4f <alltraps>

801067b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $129
801067b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801067ba:	e9 90 f6 ff ff       	jmp    80105e4f <alltraps>

801067bf <vector130>:
.globl vector130
vector130:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $130
801067c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801067c6:	e9 84 f6 ff ff       	jmp    80105e4f <alltraps>

801067cb <vector131>:
.globl vector131
vector131:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $131
801067cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067d2:	e9 78 f6 ff ff       	jmp    80105e4f <alltraps>

801067d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $132
801067d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067de:	e9 6c f6 ff ff       	jmp    80105e4f <alltraps>

801067e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $133
801067e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067ea:	e9 60 f6 ff ff       	jmp    80105e4f <alltraps>

801067ef <vector134>:
.globl vector134
vector134:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $134
801067f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067f6:	e9 54 f6 ff ff       	jmp    80105e4f <alltraps>

801067fb <vector135>:
.globl vector135
vector135:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $135
801067fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106802:	e9 48 f6 ff ff       	jmp    80105e4f <alltraps>

80106807 <vector136>:
.globl vector136
vector136:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $136
80106809:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010680e:	e9 3c f6 ff ff       	jmp    80105e4f <alltraps>

80106813 <vector137>:
.globl vector137
vector137:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $137
80106815:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010681a:	e9 30 f6 ff ff       	jmp    80105e4f <alltraps>

8010681f <vector138>:
.globl vector138
vector138:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $138
80106821:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106826:	e9 24 f6 ff ff       	jmp    80105e4f <alltraps>

8010682b <vector139>:
.globl vector139
vector139:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $139
8010682d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106832:	e9 18 f6 ff ff       	jmp    80105e4f <alltraps>

80106837 <vector140>:
.globl vector140
vector140:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $140
80106839:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010683e:	e9 0c f6 ff ff       	jmp    80105e4f <alltraps>

80106843 <vector141>:
.globl vector141
vector141:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $141
80106845:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010684a:	e9 00 f6 ff ff       	jmp    80105e4f <alltraps>

8010684f <vector142>:
.globl vector142
vector142:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $142
80106851:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106856:	e9 f4 f5 ff ff       	jmp    80105e4f <alltraps>

8010685b <vector143>:
.globl vector143
vector143:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $143
8010685d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106862:	e9 e8 f5 ff ff       	jmp    80105e4f <alltraps>

80106867 <vector144>:
.globl vector144
vector144:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $144
80106869:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010686e:	e9 dc f5 ff ff       	jmp    80105e4f <alltraps>

80106873 <vector145>:
.globl vector145
vector145:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $145
80106875:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010687a:	e9 d0 f5 ff ff       	jmp    80105e4f <alltraps>

8010687f <vector146>:
.globl vector146
vector146:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $146
80106881:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106886:	e9 c4 f5 ff ff       	jmp    80105e4f <alltraps>

8010688b <vector147>:
.globl vector147
vector147:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $147
8010688d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106892:	e9 b8 f5 ff ff       	jmp    80105e4f <alltraps>

80106897 <vector148>:
.globl vector148
vector148:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $148
80106899:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010689e:	e9 ac f5 ff ff       	jmp    80105e4f <alltraps>

801068a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $149
801068a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068aa:	e9 a0 f5 ff ff       	jmp    80105e4f <alltraps>

801068af <vector150>:
.globl vector150
vector150:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $150
801068b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801068b6:	e9 94 f5 ff ff       	jmp    80105e4f <alltraps>

801068bb <vector151>:
.globl vector151
vector151:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $151
801068bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801068c2:	e9 88 f5 ff ff       	jmp    80105e4f <alltraps>

801068c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $152
801068c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801068ce:	e9 7c f5 ff ff       	jmp    80105e4f <alltraps>

801068d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $153
801068d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068da:	e9 70 f5 ff ff       	jmp    80105e4f <alltraps>

801068df <vector154>:
.globl vector154
vector154:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $154
801068e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068e6:	e9 64 f5 ff ff       	jmp    80105e4f <alltraps>

801068eb <vector155>:
.globl vector155
vector155:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $155
801068ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068f2:	e9 58 f5 ff ff       	jmp    80105e4f <alltraps>

801068f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $156
801068f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801068fe:	e9 4c f5 ff ff       	jmp    80105e4f <alltraps>

80106903 <vector157>:
.globl vector157
vector157:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $157
80106905:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010690a:	e9 40 f5 ff ff       	jmp    80105e4f <alltraps>

8010690f <vector158>:
.globl vector158
vector158:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $158
80106911:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106916:	e9 34 f5 ff ff       	jmp    80105e4f <alltraps>

8010691b <vector159>:
.globl vector159
vector159:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $159
8010691d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106922:	e9 28 f5 ff ff       	jmp    80105e4f <alltraps>

80106927 <vector160>:
.globl vector160
vector160:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $160
80106929:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010692e:	e9 1c f5 ff ff       	jmp    80105e4f <alltraps>

80106933 <vector161>:
.globl vector161
vector161:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $161
80106935:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010693a:	e9 10 f5 ff ff       	jmp    80105e4f <alltraps>

8010693f <vector162>:
.globl vector162
vector162:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $162
80106941:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106946:	e9 04 f5 ff ff       	jmp    80105e4f <alltraps>

8010694b <vector163>:
.globl vector163
vector163:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $163
8010694d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106952:	e9 f8 f4 ff ff       	jmp    80105e4f <alltraps>

80106957 <vector164>:
.globl vector164
vector164:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $164
80106959:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010695e:	e9 ec f4 ff ff       	jmp    80105e4f <alltraps>

80106963 <vector165>:
.globl vector165
vector165:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $165
80106965:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010696a:	e9 e0 f4 ff ff       	jmp    80105e4f <alltraps>

8010696f <vector166>:
.globl vector166
vector166:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $166
80106971:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106976:	e9 d4 f4 ff ff       	jmp    80105e4f <alltraps>

8010697b <vector167>:
.globl vector167
vector167:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $167
8010697d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106982:	e9 c8 f4 ff ff       	jmp    80105e4f <alltraps>

80106987 <vector168>:
.globl vector168
vector168:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $168
80106989:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010698e:	e9 bc f4 ff ff       	jmp    80105e4f <alltraps>

80106993 <vector169>:
.globl vector169
vector169:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $169
80106995:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010699a:	e9 b0 f4 ff ff       	jmp    80105e4f <alltraps>

8010699f <vector170>:
.globl vector170
vector170:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $170
801069a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069a6:	e9 a4 f4 ff ff       	jmp    80105e4f <alltraps>

801069ab <vector171>:
.globl vector171
vector171:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $171
801069ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801069b2:	e9 98 f4 ff ff       	jmp    80105e4f <alltraps>

801069b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $172
801069b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801069be:	e9 8c f4 ff ff       	jmp    80105e4f <alltraps>

801069c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $173
801069c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801069ca:	e9 80 f4 ff ff       	jmp    80105e4f <alltraps>

801069cf <vector174>:
.globl vector174
vector174:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $174
801069d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069d6:	e9 74 f4 ff ff       	jmp    80105e4f <alltraps>

801069db <vector175>:
.globl vector175
vector175:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $175
801069dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069e2:	e9 68 f4 ff ff       	jmp    80105e4f <alltraps>

801069e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $176
801069e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069ee:	e9 5c f4 ff ff       	jmp    80105e4f <alltraps>

801069f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $177
801069f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069fa:	e9 50 f4 ff ff       	jmp    80105e4f <alltraps>

801069ff <vector178>:
.globl vector178
vector178:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $178
80106a01:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a06:	e9 44 f4 ff ff       	jmp    80105e4f <alltraps>

80106a0b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $179
80106a0d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a12:	e9 38 f4 ff ff       	jmp    80105e4f <alltraps>

80106a17 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $180
80106a19:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a1e:	e9 2c f4 ff ff       	jmp    80105e4f <alltraps>

80106a23 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $181
80106a25:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a2a:	e9 20 f4 ff ff       	jmp    80105e4f <alltraps>

80106a2f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $182
80106a31:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a36:	e9 14 f4 ff ff       	jmp    80105e4f <alltraps>

80106a3b <vector183>:
.globl vector183
vector183:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $183
80106a3d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a42:	e9 08 f4 ff ff       	jmp    80105e4f <alltraps>

80106a47 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $184
80106a49:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a4e:	e9 fc f3 ff ff       	jmp    80105e4f <alltraps>

80106a53 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $185
80106a55:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a5a:	e9 f0 f3 ff ff       	jmp    80105e4f <alltraps>

80106a5f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $186
80106a61:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a66:	e9 e4 f3 ff ff       	jmp    80105e4f <alltraps>

80106a6b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $187
80106a6d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a72:	e9 d8 f3 ff ff       	jmp    80105e4f <alltraps>

80106a77 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $188
80106a79:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a7e:	e9 cc f3 ff ff       	jmp    80105e4f <alltraps>

80106a83 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $189
80106a85:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a8a:	e9 c0 f3 ff ff       	jmp    80105e4f <alltraps>

80106a8f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $190
80106a91:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a96:	e9 b4 f3 ff ff       	jmp    80105e4f <alltraps>

80106a9b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $191
80106a9d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106aa2:	e9 a8 f3 ff ff       	jmp    80105e4f <alltraps>

80106aa7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $192
80106aa9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106aae:	e9 9c f3 ff ff       	jmp    80105e4f <alltraps>

80106ab3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $193
80106ab5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106aba:	e9 90 f3 ff ff       	jmp    80105e4f <alltraps>

80106abf <vector194>:
.globl vector194
vector194:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $194
80106ac1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ac6:	e9 84 f3 ff ff       	jmp    80105e4f <alltraps>

80106acb <vector195>:
.globl vector195
vector195:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $195
80106acd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ad2:	e9 78 f3 ff ff       	jmp    80105e4f <alltraps>

80106ad7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $196
80106ad9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ade:	e9 6c f3 ff ff       	jmp    80105e4f <alltraps>

80106ae3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $197
80106ae5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106aea:	e9 60 f3 ff ff       	jmp    80105e4f <alltraps>

80106aef <vector198>:
.globl vector198
vector198:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $198
80106af1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106af6:	e9 54 f3 ff ff       	jmp    80105e4f <alltraps>

80106afb <vector199>:
.globl vector199
vector199:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $199
80106afd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b02:	e9 48 f3 ff ff       	jmp    80105e4f <alltraps>

80106b07 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $200
80106b09:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b0e:	e9 3c f3 ff ff       	jmp    80105e4f <alltraps>

80106b13 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $201
80106b15:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b1a:	e9 30 f3 ff ff       	jmp    80105e4f <alltraps>

80106b1f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $202
80106b21:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b26:	e9 24 f3 ff ff       	jmp    80105e4f <alltraps>

80106b2b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $203
80106b2d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b32:	e9 18 f3 ff ff       	jmp    80105e4f <alltraps>

80106b37 <vector204>:
.globl vector204
vector204:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $204
80106b39:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b3e:	e9 0c f3 ff ff       	jmp    80105e4f <alltraps>

80106b43 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $205
80106b45:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b4a:	e9 00 f3 ff ff       	jmp    80105e4f <alltraps>

80106b4f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $206
80106b51:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b56:	e9 f4 f2 ff ff       	jmp    80105e4f <alltraps>

80106b5b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $207
80106b5d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b62:	e9 e8 f2 ff ff       	jmp    80105e4f <alltraps>

80106b67 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $208
80106b69:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b6e:	e9 dc f2 ff ff       	jmp    80105e4f <alltraps>

80106b73 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $209
80106b75:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b7a:	e9 d0 f2 ff ff       	jmp    80105e4f <alltraps>

80106b7f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $210
80106b81:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b86:	e9 c4 f2 ff ff       	jmp    80105e4f <alltraps>

80106b8b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $211
80106b8d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b92:	e9 b8 f2 ff ff       	jmp    80105e4f <alltraps>

80106b97 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $212
80106b99:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b9e:	e9 ac f2 ff ff       	jmp    80105e4f <alltraps>

80106ba3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $213
80106ba5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106baa:	e9 a0 f2 ff ff       	jmp    80105e4f <alltraps>

80106baf <vector214>:
.globl vector214
vector214:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $214
80106bb1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106bb6:	e9 94 f2 ff ff       	jmp    80105e4f <alltraps>

80106bbb <vector215>:
.globl vector215
vector215:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $215
80106bbd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106bc2:	e9 88 f2 ff ff       	jmp    80105e4f <alltraps>

80106bc7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $216
80106bc9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106bce:	e9 7c f2 ff ff       	jmp    80105e4f <alltraps>

80106bd3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $217
80106bd5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106bda:	e9 70 f2 ff ff       	jmp    80105e4f <alltraps>

80106bdf <vector218>:
.globl vector218
vector218:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $218
80106be1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106be6:	e9 64 f2 ff ff       	jmp    80105e4f <alltraps>

80106beb <vector219>:
.globl vector219
vector219:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $219
80106bed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106bf2:	e9 58 f2 ff ff       	jmp    80105e4f <alltraps>

80106bf7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $220
80106bf9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106bfe:	e9 4c f2 ff ff       	jmp    80105e4f <alltraps>

80106c03 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $221
80106c05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c0a:	e9 40 f2 ff ff       	jmp    80105e4f <alltraps>

80106c0f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $222
80106c11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c16:	e9 34 f2 ff ff       	jmp    80105e4f <alltraps>

80106c1b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $223
80106c1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c22:	e9 28 f2 ff ff       	jmp    80105e4f <alltraps>

80106c27 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $224
80106c29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c2e:	e9 1c f2 ff ff       	jmp    80105e4f <alltraps>

80106c33 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $225
80106c35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c3a:	e9 10 f2 ff ff       	jmp    80105e4f <alltraps>

80106c3f <vector226>:
.globl vector226
vector226:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $226
80106c41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c46:	e9 04 f2 ff ff       	jmp    80105e4f <alltraps>

80106c4b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $227
80106c4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c52:	e9 f8 f1 ff ff       	jmp    80105e4f <alltraps>

80106c57 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $228
80106c59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c5e:	e9 ec f1 ff ff       	jmp    80105e4f <alltraps>

80106c63 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $229
80106c65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c6a:	e9 e0 f1 ff ff       	jmp    80105e4f <alltraps>

80106c6f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $230
80106c71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c76:	e9 d4 f1 ff ff       	jmp    80105e4f <alltraps>

80106c7b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $231
80106c7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c82:	e9 c8 f1 ff ff       	jmp    80105e4f <alltraps>

80106c87 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $232
80106c89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c8e:	e9 bc f1 ff ff       	jmp    80105e4f <alltraps>

80106c93 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $233
80106c95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c9a:	e9 b0 f1 ff ff       	jmp    80105e4f <alltraps>

80106c9f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $234
80106ca1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ca6:	e9 a4 f1 ff ff       	jmp    80105e4f <alltraps>

80106cab <vector235>:
.globl vector235
vector235:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $235
80106cad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106cb2:	e9 98 f1 ff ff       	jmp    80105e4f <alltraps>

80106cb7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $236
80106cb9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106cbe:	e9 8c f1 ff ff       	jmp    80105e4f <alltraps>

80106cc3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $237
80106cc5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106cca:	e9 80 f1 ff ff       	jmp    80105e4f <alltraps>

80106ccf <vector238>:
.globl vector238
vector238:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $238
80106cd1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106cd6:	e9 74 f1 ff ff       	jmp    80105e4f <alltraps>

80106cdb <vector239>:
.globl vector239
vector239:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $239
80106cdd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ce2:	e9 68 f1 ff ff       	jmp    80105e4f <alltraps>

80106ce7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $240
80106ce9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cee:	e9 5c f1 ff ff       	jmp    80105e4f <alltraps>

80106cf3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $241
80106cf5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106cfa:	e9 50 f1 ff ff       	jmp    80105e4f <alltraps>

80106cff <vector242>:
.globl vector242
vector242:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $242
80106d01:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d06:	e9 44 f1 ff ff       	jmp    80105e4f <alltraps>

80106d0b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $243
80106d0d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d12:	e9 38 f1 ff ff       	jmp    80105e4f <alltraps>

80106d17 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $244
80106d19:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d1e:	e9 2c f1 ff ff       	jmp    80105e4f <alltraps>

80106d23 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $245
80106d25:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d2a:	e9 20 f1 ff ff       	jmp    80105e4f <alltraps>

80106d2f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $246
80106d31:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d36:	e9 14 f1 ff ff       	jmp    80105e4f <alltraps>

80106d3b <vector247>:
.globl vector247
vector247:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $247
80106d3d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d42:	e9 08 f1 ff ff       	jmp    80105e4f <alltraps>

80106d47 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $248
80106d49:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d4e:	e9 fc f0 ff ff       	jmp    80105e4f <alltraps>

80106d53 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $249
80106d55:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d5a:	e9 f0 f0 ff ff       	jmp    80105e4f <alltraps>

80106d5f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $250
80106d61:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d66:	e9 e4 f0 ff ff       	jmp    80105e4f <alltraps>

80106d6b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $251
80106d6d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d72:	e9 d8 f0 ff ff       	jmp    80105e4f <alltraps>

80106d77 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $252
80106d79:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d7e:	e9 cc f0 ff ff       	jmp    80105e4f <alltraps>

80106d83 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $253
80106d85:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d8a:	e9 c0 f0 ff ff       	jmp    80105e4f <alltraps>

80106d8f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $254
80106d91:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d96:	e9 b4 f0 ff ff       	jmp    80105e4f <alltraps>

80106d9b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $255
80106d9d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106da2:	e9 a8 f0 ff ff       	jmp    80105e4f <alltraps>
80106da7:	66 90                	xchg   %ax,%ax
80106da9:	66 90                	xchg   %ax,%ax
80106dab:	66 90                	xchg   %ax,%ax
80106dad:	66 90                	xchg   %ax,%ax
80106daf:	90                   	nop

80106db0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106db6:	89 d3                	mov    %edx,%ebx
{
80106db8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106dba:	c1 eb 16             	shr    $0x16,%ebx
80106dbd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106dc0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106dc3:	8b 06                	mov    (%esi),%eax
80106dc5:	a8 01                	test   $0x1,%al
80106dc7:	74 27                	je     80106df0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106dce:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106dd4:	c1 ef 0a             	shr    $0xa,%edi
}
80106dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106dda:	89 fa                	mov    %edi,%edx
80106ddc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106de2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106df0:	85 c9                	test   %ecx,%ecx
80106df2:	74 2c                	je     80106e20 <walkpgdir+0x70>
80106df4:	e8 07 b7 ff ff       	call   80102500 <kalloc>
80106df9:	85 c0                	test   %eax,%eax
80106dfb:	89 c3                	mov    %eax,%ebx
80106dfd:	74 21                	je     80106e20 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106dff:	83 ec 04             	sub    $0x4,%esp
80106e02:	68 00 10 00 00       	push   $0x1000
80106e07:	6a 00                	push   $0x0
80106e09:	50                   	push   %eax
80106e0a:	e8 81 dd ff ff       	call   80104b90 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e15:	83 c4 10             	add    $0x10,%esp
80106e18:	83 c8 07             	or     $0x7,%eax
80106e1b:	89 06                	mov    %eax,(%esi)
80106e1d:	eb b5                	jmp    80106dd4 <walkpgdir+0x24>
80106e1f:	90                   	nop
}
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	56                   	push   %esi
80106e35:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106e36:	89 d3                	mov    %edx,%ebx
80106e38:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106e3e:	83 ec 1c             	sub    $0x1c,%esp
80106e41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e44:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e50:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e56:	29 df                	sub    %ebx,%edi
80106e58:	83 c8 01             	or     $0x1,%eax
80106e5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e5e:	eb 15                	jmp    80106e75 <mappages+0x45>
    if(*pte & PTE_P)
80106e60:	f6 00 01             	testb  $0x1,(%eax)
80106e63:	75 45                	jne    80106eaa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106e65:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e68:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106e6b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e6d:	74 31                	je     80106ea0 <mappages+0x70>
      break;
    a += PGSIZE;
80106e6f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e78:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e7d:	89 da                	mov    %ebx,%edx
80106e7f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e82:	e8 29 ff ff ff       	call   80106db0 <walkpgdir>
80106e87:	85 c0                	test   %eax,%eax
80106e89:	75 d5                	jne    80106e60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e93:	5b                   	pop    %ebx
80106e94:	5e                   	pop    %esi
80106e95:	5f                   	pop    %edi
80106e96:	5d                   	pop    %ebp
80106e97:	c3                   	ret    
80106e98:	90                   	nop
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
      panic("remap");
80106eaa:	83 ec 0c             	sub    $0xc,%esp
80106ead:	68 54 80 10 80       	push   $0x80108054
80106eb2:	e8 d9 94 ff ff       	call   80100390 <panic>
80106eb7:	89 f6                	mov    %esi,%esi
80106eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ec0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106ec6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ecc:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106ece:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ed4:	83 ec 1c             	sub    $0x1c,%esp
80106ed7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106eda:	39 d3                	cmp    %edx,%ebx
80106edc:	73 66                	jae    80106f44 <deallocuvm.part.0+0x84>
80106ede:	89 d6                	mov    %edx,%esi
80106ee0:	eb 3d                	jmp    80106f1f <deallocuvm.part.0+0x5f>
80106ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ee8:	8b 10                	mov    (%eax),%edx
80106eea:	f6 c2 01             	test   $0x1,%dl
80106eed:	74 26                	je     80106f15 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106eef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ef5:	74 58                	je     80106f4f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ef7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106efa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106f03:	52                   	push   %edx
80106f04:	e8 47 b4 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f0c:	83 c4 10             	add    $0x10,%esp
80106f0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106f15:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f1b:	39 f3                	cmp    %esi,%ebx
80106f1d:	73 25                	jae    80106f44 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f1f:	31 c9                	xor    %ecx,%ecx
80106f21:	89 da                	mov    %ebx,%edx
80106f23:	89 f8                	mov    %edi,%eax
80106f25:	e8 86 fe ff ff       	call   80106db0 <walkpgdir>
    if(!pte)
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	75 ba                	jne    80106ee8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f2e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106f34:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f3a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f40:	39 f3                	cmp    %esi,%ebx
80106f42:	72 db                	jb     80106f1f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4a:	5b                   	pop    %ebx
80106f4b:	5e                   	pop    %esi
80106f4c:	5f                   	pop    %edi
80106f4d:	5d                   	pop    %ebp
80106f4e:	c3                   	ret    
        panic("kfree");
80106f4f:	83 ec 0c             	sub    $0xc,%esp
80106f52:	68 46 79 10 80       	push   $0x80107946
80106f57:	e8 34 94 ff ff       	call   80100390 <panic>
80106f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f60 <seginit>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f66:	e8 75 c8 ff ff       	call   801037e0 <cpuid>
80106f6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f7a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106f81:	ff 00 00 
80106f84:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106f8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f8e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106f95:	ff 00 00 
80106f98:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106f9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fa2:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106fa9:	ff 00 00 
80106fac:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106fb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fb6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106fbd:	ff 00 00 
80106fc0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106fc7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fca:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106fcf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fd3:	c1 e8 10             	shr    $0x10,%eax
80106fd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fdd:	0f 01 10             	lgdtl  (%eax)
}
80106fe0:	c9                   	leave  
80106fe1:	c3                   	ret    
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ff0:	a1 a4 a9 11 80       	mov    0x8011a9a4,%eax
{
80106ff5:	55                   	push   %ebp
80106ff6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ff8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ffd:	0f 22 d8             	mov    %eax,%cr3
}
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <switchuvm>:
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010701c:	85 db                	test   %ebx,%ebx
8010701e:	0f 84 cb 00 00 00    	je     801070ef <switchuvm+0xdf>
  if(p->kstack == 0)
80107024:	8b 43 08             	mov    0x8(%ebx),%eax
80107027:	85 c0                	test   %eax,%eax
80107029:	0f 84 da 00 00 00    	je     80107109 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010702f:	8b 43 04             	mov    0x4(%ebx),%eax
80107032:	85 c0                	test   %eax,%eax
80107034:	0f 84 c2 00 00 00    	je     801070fc <switchuvm+0xec>
  pushcli();
8010703a:	e8 71 d9 ff ff       	call   801049b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010703f:	e8 1c c7 ff ff       	call   80103760 <mycpu>
80107044:	89 c6                	mov    %eax,%esi
80107046:	e8 15 c7 ff ff       	call   80103760 <mycpu>
8010704b:	89 c7                	mov    %eax,%edi
8010704d:	e8 0e c7 ff ff       	call   80103760 <mycpu>
80107052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107055:	83 c7 08             	add    $0x8,%edi
80107058:	e8 03 c7 ff ff       	call   80103760 <mycpu>
8010705d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107060:	83 c0 08             	add    $0x8,%eax
80107063:	ba 67 00 00 00       	mov    $0x67,%edx
80107068:	c1 e8 18             	shr    $0x18,%eax
8010706b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107072:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107079:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010707f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107084:	83 c1 08             	add    $0x8,%ecx
80107087:	c1 e9 10             	shr    $0x10,%ecx
8010708a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107090:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107095:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010709c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801070a1:	e8 ba c6 ff ff       	call   80103760 <mycpu>
801070a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070ad:	e8 ae c6 ff ff       	call   80103760 <mycpu>
801070b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070b6:	8b 73 08             	mov    0x8(%ebx),%esi
801070b9:	e8 a2 c6 ff ff       	call   80103760 <mycpu>
801070be:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070c7:	e8 94 c6 ff ff       	call   80103760 <mycpu>
801070cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070d0:	b8 28 00 00 00       	mov    $0x28,%eax
801070d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070d8:	8b 43 04             	mov    0x4(%ebx),%eax
801070db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070e0:	0f 22 d8             	mov    %eax,%cr3
}
801070e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e6:	5b                   	pop    %ebx
801070e7:	5e                   	pop    %esi
801070e8:	5f                   	pop    %edi
801070e9:	5d                   	pop    %ebp
  popcli();
801070ea:	e9 01 d9 ff ff       	jmp    801049f0 <popcli>
    panic("switchuvm: no process");
801070ef:	83 ec 0c             	sub    $0xc,%esp
801070f2:	68 5a 80 10 80       	push   $0x8010805a
801070f7:	e8 94 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801070fc:	83 ec 0c             	sub    $0xc,%esp
801070ff:	68 85 80 10 80       	push   $0x80108085
80107104:	e8 87 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107109:	83 ec 0c             	sub    $0xc,%esp
8010710c:	68 70 80 10 80       	push   $0x80108070
80107111:	e8 7a 92 ff ff       	call   80100390 <panic>
80107116:	8d 76 00             	lea    0x0(%esi),%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107120 <inituvm>:
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 75 10             	mov    0x10(%ebp),%esi
8010712c:	8b 45 08             	mov    0x8(%ebp),%eax
8010712f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107132:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010713b:	77 49                	ja     80107186 <inituvm+0x66>
  mem = kalloc();
8010713d:	e8 be b3 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
80107142:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107145:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107147:	68 00 10 00 00       	push   $0x1000
8010714c:	6a 00                	push   $0x0
8010714e:	50                   	push   %eax
8010714f:	e8 3c da ff ff       	call   80104b90 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107154:	58                   	pop    %eax
80107155:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010715b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107160:	5a                   	pop    %edx
80107161:	6a 06                	push   $0x6
80107163:	50                   	push   %eax
80107164:	31 d2                	xor    %edx,%edx
80107166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107169:	e8 c2 fc ff ff       	call   80106e30 <mappages>
  memmove(mem, init, sz);
8010716e:	89 75 10             	mov    %esi,0x10(%ebp)
80107171:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107174:	83 c4 10             	add    $0x10,%esp
80107177:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010717a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107181:	e9 ba da ff ff       	jmp    80104c40 <memmove>
    panic("inituvm: more than a page");
80107186:	83 ec 0c             	sub    $0xc,%esp
80107189:	68 99 80 10 80       	push   $0x80108099
8010718e:	e8 fd 91 ff ff       	call   80100390 <panic>
80107193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071a0 <loaduvm>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801071a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801071b0:	0f 85 91 00 00 00    	jne    80107247 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
801071b6:	8b 75 18             	mov    0x18(%ebp),%esi
801071b9:	31 db                	xor    %ebx,%ebx
801071bb:	85 f6                	test   %esi,%esi
801071bd:	75 1a                	jne    801071d9 <loaduvm+0x39>
801071bf:	eb 6f                	jmp    80107230 <loaduvm+0x90>
801071c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071d7:	76 57                	jbe    80107230 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071dc:	8b 45 08             	mov    0x8(%ebp),%eax
801071df:	31 c9                	xor    %ecx,%ecx
801071e1:	01 da                	add    %ebx,%edx
801071e3:	e8 c8 fb ff ff       	call   80106db0 <walkpgdir>
801071e8:	85 c0                	test   %eax,%eax
801071ea:	74 4e                	je     8010723a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801071ec:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801071f1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107201:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107204:	01 d9                	add    %ebx,%ecx
80107206:	05 00 00 00 80       	add    $0x80000000,%eax
8010720b:	57                   	push   %edi
8010720c:	51                   	push   %ecx
8010720d:	50                   	push   %eax
8010720e:	ff 75 10             	pushl  0x10(%ebp)
80107211:	e8 7a a7 ff ff       	call   80101990 <readi>
80107216:	83 c4 10             	add    $0x10,%esp
80107219:	39 f8                	cmp    %edi,%eax
8010721b:	74 ab                	je     801071c8 <loaduvm+0x28>
}
8010721d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
      panic("loaduvm: address should exist");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 b3 80 10 80       	push   $0x801080b3
80107242:	e8 49 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107247:	83 ec 0c             	sub    $0xc,%esp
8010724a:	68 54 81 10 80       	push   $0x80108154
8010724f:	e8 3c 91 ff ff       	call   80100390 <panic>
80107254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010725a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107260 <allocuvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107269:	8b 7d 10             	mov    0x10(%ebp),%edi
8010726c:	85 ff                	test   %edi,%edi
8010726e:	0f 88 8e 00 00 00    	js     80107302 <allocuvm+0xa2>
  if(newsz < oldsz)
80107274:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107277:	0f 82 93 00 00 00    	jb     80107310 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010727d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107280:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107286:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010728c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010728f:	0f 86 7e 00 00 00    	jbe    80107313 <allocuvm+0xb3>
80107295:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107298:	8b 7d 08             	mov    0x8(%ebp),%edi
8010729b:	eb 42                	jmp    801072df <allocuvm+0x7f>
8010729d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801072a0:	83 ec 04             	sub    $0x4,%esp
801072a3:	68 00 10 00 00       	push   $0x1000
801072a8:	6a 00                	push   $0x0
801072aa:	50                   	push   %eax
801072ab:	e8 e0 d8 ff ff       	call   80104b90 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801072b0:	58                   	pop    %eax
801072b1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801072b7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072bc:	5a                   	pop    %edx
801072bd:	6a 06                	push   $0x6
801072bf:	50                   	push   %eax
801072c0:	89 da                	mov    %ebx,%edx
801072c2:	89 f8                	mov    %edi,%eax
801072c4:	e8 67 fb ff ff       	call   80106e30 <mappages>
801072c9:	83 c4 10             	add    $0x10,%esp
801072cc:	85 c0                	test   %eax,%eax
801072ce:	78 50                	js     80107320 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801072d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801072d6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801072d9:	0f 86 81 00 00 00    	jbe    80107360 <allocuvm+0x100>
    mem = kalloc();
801072df:	e8 1c b2 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
801072e4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801072e6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801072e8:	75 b6                	jne    801072a0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801072ea:	83 ec 0c             	sub    $0xc,%esp
801072ed:	68 d1 80 10 80       	push   $0x801080d1
801072f2:	e8 69 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801072f7:	83 c4 10             	add    $0x10,%esp
801072fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801072fd:	39 45 10             	cmp    %eax,0x10(%ebp)
80107300:	77 6e                	ja     80107370 <allocuvm+0x110>
}
80107302:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107305:	31 ff                	xor    %edi,%edi
}
80107307:	89 f8                	mov    %edi,%eax
80107309:	5b                   	pop    %ebx
8010730a:	5e                   	pop    %esi
8010730b:	5f                   	pop    %edi
8010730c:	5d                   	pop    %ebp
8010730d:	c3                   	ret    
8010730e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107310:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107316:	89 f8                	mov    %edi,%eax
80107318:	5b                   	pop    %ebx
80107319:	5e                   	pop    %esi
8010731a:	5f                   	pop    %edi
8010731b:	5d                   	pop    %ebp
8010731c:	c3                   	ret    
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	68 e9 80 10 80       	push   $0x801080e9
80107328:	e8 33 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010732d:	83 c4 10             	add    $0x10,%esp
80107330:	8b 45 0c             	mov    0xc(%ebp),%eax
80107333:	39 45 10             	cmp    %eax,0x10(%ebp)
80107336:	76 0d                	jbe    80107345 <allocuvm+0xe5>
80107338:	89 c1                	mov    %eax,%ecx
8010733a:	8b 55 10             	mov    0x10(%ebp),%edx
8010733d:	8b 45 08             	mov    0x8(%ebp),%eax
80107340:	e8 7b fb ff ff       	call   80106ec0 <deallocuvm.part.0>
      kfree(mem);
80107345:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107348:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010734a:	56                   	push   %esi
8010734b:	e8 00 b0 ff ff       	call   80102350 <kfree>
      return 0;
80107350:	83 c4 10             	add    $0x10,%esp
}
80107353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107356:	89 f8                	mov    %edi,%eax
80107358:	5b                   	pop    %ebx
80107359:	5e                   	pop    %esi
8010735a:	5f                   	pop    %edi
8010735b:	5d                   	pop    %ebp
8010735c:	c3                   	ret    
8010735d:	8d 76 00             	lea    0x0(%esi),%esi
80107360:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107366:	5b                   	pop    %ebx
80107367:	89 f8                	mov    %edi,%eax
80107369:	5e                   	pop    %esi
8010736a:	5f                   	pop    %edi
8010736b:	5d                   	pop    %ebp
8010736c:	c3                   	ret    
8010736d:	8d 76 00             	lea    0x0(%esi),%esi
80107370:	89 c1                	mov    %eax,%ecx
80107372:	8b 55 10             	mov    0x10(%ebp),%edx
80107375:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107378:	31 ff                	xor    %edi,%edi
8010737a:	e8 41 fb ff ff       	call   80106ec0 <deallocuvm.part.0>
8010737f:	eb 92                	jmp    80107313 <allocuvm+0xb3>
80107381:	eb 0d                	jmp    80107390 <deallocuvm>
80107383:	90                   	nop
80107384:	90                   	nop
80107385:	90                   	nop
80107386:	90                   	nop
80107387:	90                   	nop
80107388:	90                   	nop
80107389:	90                   	nop
8010738a:	90                   	nop
8010738b:	90                   	nop
8010738c:	90                   	nop
8010738d:	90                   	nop
8010738e:	90                   	nop
8010738f:	90                   	nop

80107390 <deallocuvm>:
{
80107390:	55                   	push   %ebp
80107391:	89 e5                	mov    %esp,%ebp
80107393:	8b 55 0c             	mov    0xc(%ebp),%edx
80107396:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107399:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010739c:	39 d1                	cmp    %edx,%ecx
8010739e:	73 10                	jae    801073b0 <deallocuvm+0x20>
}
801073a0:	5d                   	pop    %ebp
801073a1:	e9 1a fb ff ff       	jmp    80106ec0 <deallocuvm.part.0>
801073a6:	8d 76 00             	lea    0x0(%esi),%esi
801073a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801073b0:	89 d0                	mov    %edx,%eax
801073b2:	5d                   	pop    %ebp
801073b3:	c3                   	ret    
801073b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801073c0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	57                   	push   %edi
801073c4:	56                   	push   %esi
801073c5:	53                   	push   %ebx
801073c6:	83 ec 0c             	sub    $0xc,%esp
801073c9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073cc:	85 f6                	test   %esi,%esi
801073ce:	74 59                	je     80107429 <freevm+0x69>
801073d0:	31 c9                	xor    %ecx,%ecx
801073d2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073d7:	89 f0                	mov    %esi,%eax
801073d9:	e8 e2 fa ff ff       	call   80106ec0 <deallocuvm.part.0>
801073de:	89 f3                	mov    %esi,%ebx
801073e0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073e6:	eb 0f                	jmp    801073f7 <freevm+0x37>
801073e8:	90                   	nop
801073e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073f0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073f3:	39 fb                	cmp    %edi,%ebx
801073f5:	74 23                	je     8010741a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073f7:	8b 03                	mov    (%ebx),%eax
801073f9:	a8 01                	test   $0x1,%al
801073fb:	74 f3                	je     801073f0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107402:	83 ec 0c             	sub    $0xc,%esp
80107405:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107408:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010740d:	50                   	push   %eax
8010740e:	e8 3d af ff ff       	call   80102350 <kfree>
80107413:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107416:	39 fb                	cmp    %edi,%ebx
80107418:	75 dd                	jne    801073f7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010741a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010741d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107420:	5b                   	pop    %ebx
80107421:	5e                   	pop    %esi
80107422:	5f                   	pop    %edi
80107423:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107424:	e9 27 af ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
80107429:	83 ec 0c             	sub    $0xc,%esp
8010742c:	68 05 81 10 80       	push   $0x80108105
80107431:	e8 5a 8f ff ff       	call   80100390 <panic>
80107436:	8d 76 00             	lea    0x0(%esi),%esi
80107439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107440 <setupkvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	56                   	push   %esi
80107444:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107445:	e8 b6 b0 ff ff       	call   80102500 <kalloc>
8010744a:	85 c0                	test   %eax,%eax
8010744c:	89 c6                	mov    %eax,%esi
8010744e:	74 42                	je     80107492 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107450:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107453:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107458:	68 00 10 00 00       	push   $0x1000
8010745d:	6a 00                	push   $0x0
8010745f:	50                   	push   %eax
80107460:	e8 2b d7 ff ff       	call   80104b90 <memset>
80107465:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107468:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010746b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010746e:	83 ec 08             	sub    $0x8,%esp
80107471:	8b 13                	mov    (%ebx),%edx
80107473:	ff 73 0c             	pushl  0xc(%ebx)
80107476:	50                   	push   %eax
80107477:	29 c1                	sub    %eax,%ecx
80107479:	89 f0                	mov    %esi,%eax
8010747b:	e8 b0 f9 ff ff       	call   80106e30 <mappages>
80107480:	83 c4 10             	add    $0x10,%esp
80107483:	85 c0                	test   %eax,%eax
80107485:	78 19                	js     801074a0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107487:	83 c3 10             	add    $0x10,%ebx
8010748a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107490:	75 d6                	jne    80107468 <setupkvm+0x28>
}
80107492:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107495:	89 f0                	mov    %esi,%eax
80107497:	5b                   	pop    %ebx
80107498:	5e                   	pop    %esi
80107499:	5d                   	pop    %ebp
8010749a:	c3                   	ret    
8010749b:	90                   	nop
8010749c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801074a0:	83 ec 0c             	sub    $0xc,%esp
801074a3:	56                   	push   %esi
      return 0;
801074a4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801074a6:	e8 15 ff ff ff       	call   801073c0 <freevm>
      return 0;
801074ab:	83 c4 10             	add    $0x10,%esp
}
801074ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074b1:	89 f0                	mov    %esi,%eax
801074b3:	5b                   	pop    %ebx
801074b4:	5e                   	pop    %esi
801074b5:	5d                   	pop    %ebp
801074b6:	c3                   	ret    
801074b7:	89 f6                	mov    %esi,%esi
801074b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074c0 <kvmalloc>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074c6:	e8 75 ff ff ff       	call   80107440 <setupkvm>
801074cb:	a3 a4 a9 11 80       	mov    %eax,0x8011a9a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074d0:	05 00 00 00 80       	add    $0x80000000,%eax
801074d5:	0f 22 d8             	mov    %eax,%cr3
}
801074d8:	c9                   	leave  
801074d9:	c3                   	ret    
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074e1:	31 c9                	xor    %ecx,%ecx
{
801074e3:	89 e5                	mov    %esp,%ebp
801074e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074eb:	8b 45 08             	mov    0x8(%ebp),%eax
801074ee:	e8 bd f8 ff ff       	call   80106db0 <walkpgdir>
  if(pte == 0)
801074f3:	85 c0                	test   %eax,%eax
801074f5:	74 05                	je     801074fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801074f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074fa:	c9                   	leave  
801074fb:	c3                   	ret    
    panic("clearpteu");
801074fc:	83 ec 0c             	sub    $0xc,%esp
801074ff:	68 16 81 10 80       	push   $0x80108116
80107504:	e8 87 8e ff ff       	call   80100390 <panic>
80107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107510 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
80107516:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107519:	e8 22 ff ff ff       	call   80107440 <setupkvm>
8010751e:	85 c0                	test   %eax,%eax
80107520:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107523:	0f 84 9f 00 00 00    	je     801075c8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107529:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010752c:	85 c9                	test   %ecx,%ecx
8010752e:	0f 84 94 00 00 00    	je     801075c8 <copyuvm+0xb8>
80107534:	31 ff                	xor    %edi,%edi
80107536:	eb 4a                	jmp    80107582 <copyuvm+0x72>
80107538:	90                   	nop
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107549:	68 00 10 00 00       	push   $0x1000
8010754e:	53                   	push   %ebx
8010754f:	50                   	push   %eax
80107550:	e8 eb d6 ff ff       	call   80104c40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107555:	58                   	pop    %eax
80107556:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010755c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107561:	5a                   	pop    %edx
80107562:	ff 75 e4             	pushl  -0x1c(%ebp)
80107565:	50                   	push   %eax
80107566:	89 fa                	mov    %edi,%edx
80107568:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010756b:	e8 c0 f8 ff ff       	call   80106e30 <mappages>
80107570:	83 c4 10             	add    $0x10,%esp
80107573:	85 c0                	test   %eax,%eax
80107575:	78 61                	js     801075d8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107577:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010757d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107580:	76 46                	jbe    801075c8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107582:	8b 45 08             	mov    0x8(%ebp),%eax
80107585:	31 c9                	xor    %ecx,%ecx
80107587:	89 fa                	mov    %edi,%edx
80107589:	e8 22 f8 ff ff       	call   80106db0 <walkpgdir>
8010758e:	85 c0                	test   %eax,%eax
80107590:	74 61                	je     801075f3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107592:	8b 00                	mov    (%eax),%eax
80107594:	a8 01                	test   $0x1,%al
80107596:	74 4e                	je     801075e6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107598:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010759a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010759f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801075a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801075a8:	e8 53 af ff ff       	call   80102500 <kalloc>
801075ad:	85 c0                	test   %eax,%eax
801075af:	89 c6                	mov    %eax,%esi
801075b1:	75 8d                	jne    80107540 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801075b3:	83 ec 0c             	sub    $0xc,%esp
801075b6:	ff 75 e0             	pushl  -0x20(%ebp)
801075b9:	e8 02 fe ff ff       	call   801073c0 <freevm>
  return 0;
801075be:	83 c4 10             	add    $0x10,%esp
801075c1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801075c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ce:	5b                   	pop    %ebx
801075cf:	5e                   	pop    %esi
801075d0:	5f                   	pop    %edi
801075d1:	5d                   	pop    %ebp
801075d2:	c3                   	ret    
801075d3:	90                   	nop
801075d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801075d8:	83 ec 0c             	sub    $0xc,%esp
801075db:	56                   	push   %esi
801075dc:	e8 6f ad ff ff       	call   80102350 <kfree>
      goto bad;
801075e1:	83 c4 10             	add    $0x10,%esp
801075e4:	eb cd                	jmp    801075b3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801075e6:	83 ec 0c             	sub    $0xc,%esp
801075e9:	68 3a 81 10 80       	push   $0x8010813a
801075ee:	e8 9d 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801075f3:	83 ec 0c             	sub    $0xc,%esp
801075f6:	68 20 81 10 80       	push   $0x80108120
801075fb:	e8 90 8d ff ff       	call   80100390 <panic>

80107600 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107600:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107601:	31 c9                	xor    %ecx,%ecx
{
80107603:	89 e5                	mov    %esp,%ebp
80107605:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107608:	8b 55 0c             	mov    0xc(%ebp),%edx
8010760b:	8b 45 08             	mov    0x8(%ebp),%eax
8010760e:	e8 9d f7 ff ff       	call   80106db0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107613:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107615:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107616:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107618:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010761d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107620:	05 00 00 00 80       	add    $0x80000000,%eax
80107625:	83 fa 05             	cmp    $0x5,%edx
80107628:	ba 00 00 00 00       	mov    $0x0,%edx
8010762d:	0f 45 c2             	cmovne %edx,%eax
}
80107630:	c3                   	ret    
80107631:	eb 0d                	jmp    80107640 <copyout>
80107633:	90                   	nop
80107634:	90                   	nop
80107635:	90                   	nop
80107636:	90                   	nop
80107637:	90                   	nop
80107638:	90                   	nop
80107639:	90                   	nop
8010763a:	90                   	nop
8010763b:	90                   	nop
8010763c:	90                   	nop
8010763d:	90                   	nop
8010763e:	90                   	nop
8010763f:	90                   	nop

80107640 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 1c             	sub    $0x1c,%esp
80107649:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010764c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010764f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107652:	85 db                	test   %ebx,%ebx
80107654:	75 40                	jne    80107696 <copyout+0x56>
80107656:	eb 70                	jmp    801076c8 <copyout+0x88>
80107658:	90                   	nop
80107659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107663:	89 f1                	mov    %esi,%ecx
80107665:	29 d1                	sub    %edx,%ecx
80107667:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010766d:	39 d9                	cmp    %ebx,%ecx
8010766f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107672:	29 f2                	sub    %esi,%edx
80107674:	83 ec 04             	sub    $0x4,%esp
80107677:	01 d0                	add    %edx,%eax
80107679:	51                   	push   %ecx
8010767a:	57                   	push   %edi
8010767b:	50                   	push   %eax
8010767c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010767f:	e8 bc d5 ff ff       	call   80104c40 <memmove>
    len -= n;
    buf += n;
80107684:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107687:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010768a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107690:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107692:	29 cb                	sub    %ecx,%ebx
80107694:	74 32                	je     801076c8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107696:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107698:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010769b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010769e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801076a4:	56                   	push   %esi
801076a5:	ff 75 08             	pushl  0x8(%ebp)
801076a8:	e8 53 ff ff ff       	call   80107600 <uva2ka>
    if(pa0 == 0)
801076ad:	83 c4 10             	add    $0x10,%esp
801076b0:	85 c0                	test   %eax,%eax
801076b2:	75 ac                	jne    80107660 <copyout+0x20>
  }
  return 0;
}
801076b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076bc:	5b                   	pop    %ebx
801076bd:	5e                   	pop    %esi
801076be:	5f                   	pop    %edi
801076bf:	5d                   	pop    %ebp
801076c0:	c3                   	ret    
801076c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076cb:	31 c0                	xor    %eax,%eax
}
801076cd:	5b                   	pop    %ebx
801076ce:	5e                   	pop    %esi
801076cf:	5f                   	pop    %edi
801076d0:	5d                   	pop    %ebp
801076d1:	c3                   	ret    
