
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
8010004c:	68 80 77 10 80       	push   $0x80107780
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 75 49 00 00       	call   801049d0 <initlock>
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
80100092:	68 87 77 10 80       	push   $0x80107787
80100097:	50                   	push   %eax
80100098:	e8 03 48 00 00       	call   801048a0 <initsleeplock>
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
801000e4:	e8 27 4a 00 00       	call   80104b10 <acquire>
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
80100162:	e8 69 4a 00 00       	call   80104bd0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 6e 47 00 00       	call   801048e0 <acquiresleep>
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
80100193:	68 8e 77 10 80       	push   $0x8010778e
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
801001ae:	e8 cd 47 00 00       	call   80104980 <holdingsleep>
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
801001cc:	68 9f 77 10 80       	push   $0x8010779f
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
801001ef:	e8 8c 47 00 00       	call   80104980 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 47 00 00       	call   80104940 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 00 49 00 00       	call   80104b10 <acquire>
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
8010025c:	e9 6f 49 00 00       	jmp    80104bd0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 77 10 80       	push   $0x801077a6
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
8010028c:	e8 7f 48 00 00       	call   80104b10 <acquire>
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
801002c5:	e8 66 3d 00 00       	call   80104030 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 10 35 00 00       	call   801037f0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 dc 48 00 00       	call   80104bd0 <release>
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
8010034d:	e8 7e 48 00 00       	call   80104bd0 <release>
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
801003b2:	68 ad 77 10 80       	push   $0x801077ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 63 81 10 80 	movl   $0x80108163,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 13 46 00 00       	call   801049f0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 77 10 80       	push   $0x801077c1
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
8010043a:	e8 41 5f 00 00       	call   80106380 <uartputc>
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
801004ec:	e8 8f 5e 00 00       	call   80106380 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 5e 00 00       	call   80106380 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 5e 00 00       	call   80106380 <uartputc>
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
80100524:	e8 a7 47 00 00       	call   80104cd0 <memmove>
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
80100541:	e8 da 46 00 00       	call   80104c20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 77 10 80       	push   $0x801077c5
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
801005b1:	0f b6 92 f0 77 10 80 	movzbl -0x7fef8810(%edx),%edx
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
8010061b:	e8 f0 44 00 00       	call   80104b10 <acquire>
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
80100647:	e8 84 45 00 00       	call   80104bd0 <release>
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
8010071f:	e8 ac 44 00 00       	call   80104bd0 <release>
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
801007d0:	ba d8 77 10 80       	mov    $0x801077d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 1b 43 00 00       	call   80104b10 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 77 10 80       	push   $0x801077df
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
80100823:	e8 e8 42 00 00       	call   80104b10 <acquire>
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
80100888:	e8 43 43 00 00       	call   80104bd0 <release>
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
80100916:	e8 f5 37 00 00       	call   80104110 <wakeup>
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
80100997:	e9 74 38 00 00       	jmp    80104210 <procdump>
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
801009c6:	68 e8 77 10 80       	push   $0x801077e8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 fb 3f 00 00       	call   801049d0 <initlock>

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
80100a1c:	e8 cf 2d 00 00       	call   801037f0 <myproc>
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
80100a94:	e8 37 6a 00 00       	call   801074d0 <setupkvm>
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
80100af6:	e8 f5 67 00 00       	call   801072f0 <allocuvm>
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
80100b28:	e8 03 67 00 00       	call   80107230 <loaduvm>
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
80100b72:	e8 d9 68 00 00       	call   80107450 <freevm>
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
80100baa:	e8 41 67 00 00       	call   801072f0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 8a 68 00 00       	call   80107450 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 78 20 00 00       	call   80102c50 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 78 10 80       	push   $0x80107801
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
80100c06:	e8 65 69 00 00       	call   80107570 <clearpteu>
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
80100c39:	e8 02 42 00 00       	call   80104e40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 41 00 00       	call   80104e40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 6e 6a 00 00       	call   801076d0 <copyout>
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
80100cc7:	e8 04 6a 00 00       	call   801076d0 <copyout>
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
80100d08:	e8 f3 40 00 00       	call   80104e00 <safestrcpy>
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
80100d63:	e8 38 63 00 00       	call   801070a0 <switchuvm>
  freevm(oldpgdir);
80100d68:	89 3c 24             	mov    %edi,(%esp)
80100d6b:	e8 e0 66 00 00       	call   80107450 <freevm>
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
80100d96:	68 0d 78 10 80       	push   $0x8010780d
80100d9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100da0:	e8 2b 3c 00 00       	call   801049d0 <initlock>
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
80100dc1:	e8 4a 3d 00 00       	call   80104b10 <acquire>
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
80100df1:	e8 da 3d 00 00       	call   80104bd0 <release>
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
80100e0a:	e8 c1 3d 00 00       	call   80104bd0 <release>
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
80100e2f:	e8 dc 3c 00 00       	call   80104b10 <acquire>
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
80100e4c:	e8 7f 3d 00 00       	call   80104bd0 <release>
  return f;
}
80100e51:	89 d8                	mov    %ebx,%eax
80100e53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e56:	c9                   	leave  
80100e57:	c3                   	ret    
    panic("filedup");
80100e58:	83 ec 0c             	sub    $0xc,%esp
80100e5b:	68 14 78 10 80       	push   $0x80107814
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
80100e81:	e8 8a 3c 00 00       	call   80104b10 <acquire>
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
80100eac:	e9 1f 3d 00 00       	jmp    80104bd0 <release>
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
80100ed8:	e8 f3 3c 00 00       	call   80104bd0 <release>
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
80100f32:	68 1c 78 10 80       	push   $0x8010781c
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
80101012:	68 26 78 10 80       	push   $0x80107826
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
80101125:	68 2f 78 10 80       	push   $0x8010782f
8010112a:	e8 61 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 35 78 10 80       	push   $0x80107835
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
801011a3:	68 3f 78 10 80       	push   $0x8010783f
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
80101254:	68 52 78 10 80       	push   $0x80107852
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
80101295:	e8 86 39 00 00       	call   80104c20 <memset>
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
801012da:	e8 31 38 00 00       	call   80104b10 <acquire>
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
8010133f:	e8 8c 38 00 00       	call   80104bd0 <release>

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
8010136d:	e8 5e 38 00 00       	call   80104bd0 <release>
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
80101382:	68 68 78 10 80       	push   $0x80107868
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
80101457:	68 78 78 10 80       	push   $0x80107878
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
80101491:	e8 3a 38 00 00       	call   80104cd0 <memmove>
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
801014bc:	68 8b 78 10 80       	push   $0x8010788b
801014c1:	68 e0 19 11 80       	push   $0x801119e0
801014c6:	e8 05 35 00 00       	call   801049d0 <initlock>
801014cb:	83 c4 10             	add    $0x10,%esp
801014ce:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	68 92 78 10 80       	push   $0x80107892
801014d8:	53                   	push   %ebx
801014d9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014df:	e8 bc 33 00 00       	call   801048a0 <initsleeplock>
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
80101529:	68 f8 78 10 80       	push   $0x801078f8
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
801015be:	e8 5d 36 00 00       	call   80104c20 <memset>
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
801015f3:	68 98 78 10 80       	push   $0x80107898
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
80101661:	e8 6a 36 00 00       	call   80104cd0 <memmove>
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
8010168f:	e8 7c 34 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101694:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101698:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010169f:	e8 2c 35 00 00       	call   80104bd0 <release>
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
801016d2:	e8 09 32 00 00       	call   801048e0 <acquiresleep>
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
80101748:	e8 83 35 00 00       	call   80104cd0 <memmove>
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
8010176d:	68 b0 78 10 80       	push   $0x801078b0
80101772:	e8 19 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101777:	83 ec 0c             	sub    $0xc,%esp
8010177a:	68 aa 78 10 80       	push   $0x801078aa
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
801017a3:	e8 d8 31 00 00       	call   80104980 <holdingsleep>
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
801017bf:	e9 7c 31 00 00       	jmp    80104940 <releasesleep>
    panic("iunlock");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 bf 78 10 80       	push   $0x801078bf
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
801017f0:	e8 eb 30 00 00       	call   801048e0 <acquiresleep>
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
8010180a:	e8 31 31 00 00       	call   80104940 <releasesleep>
  acquire(&icache.lock);
8010180f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101816:	e8 f5 32 00 00       	call   80104b10 <acquire>
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
80101830:	e9 9b 33 00 00       	jmp    80104bd0 <release>
80101835:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 e0 19 11 80       	push   $0x801119e0
80101840:	e8 cb 32 00 00       	call   80104b10 <acquire>
    int r = ip->ref;
80101845:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101848:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010184f:	e8 7c 33 00 00       	call   80104bd0 <release>
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
80101a37:	e8 94 32 00 00       	call   80104cd0 <memmove>
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
80101b33:	e8 98 31 00 00       	call   80104cd0 <memmove>
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
80101bce:	e8 6d 31 00 00       	call   80104d40 <strncmp>
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
80101c2d:	e8 0e 31 00 00       	call   80104d40 <strncmp>
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
80101c72:	68 d9 78 10 80       	push   $0x801078d9
80101c77:	e8 14 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c7c:	83 ec 0c             	sub    $0xc,%esp
80101c7f:	68 c7 78 10 80       	push   $0x801078c7
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
80101ca9:	e8 42 1b 00 00       	call   801037f0 <myproc>
  acquire(&icache.lock);
80101cae:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cb1:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101cb4:	68 e0 19 11 80       	push   $0x801119e0
80101cb9:	e8 52 2e 00 00       	call   80104b10 <acquire>
  ip->ref++;
80101cbe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cc9:	e8 02 2f 00 00       	call   80104bd0 <release>
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
80101d25:	e8 a6 2f 00 00       	call   80104cd0 <memmove>
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
80101db8:	e8 13 2f 00 00       	call   80104cd0 <memmove>
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
80101ead:	e8 ee 2e 00 00       	call   80104da0 <strncpy>
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
80101eeb:	68 e8 78 10 80       	push   $0x801078e8
80101ef0:	e8 9b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ef5:	83 ec 0c             	sub    $0xc,%esp
80101ef8:	68 4a 7f 10 80       	push   $0x80107f4a
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
8010200b:	68 54 79 10 80       	push   $0x80107954
80102010:	e8 7b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102015:	83 ec 0c             	sub    $0xc,%esp
80102018:	68 4b 79 10 80       	push   $0x8010794b
8010201d:	e8 6e e3 ff ff       	call   80100390 <panic>
80102022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102036:	68 66 79 10 80       	push   $0x80107966
8010203b:	68 80 b5 10 80       	push   $0x8010b580
80102040:	e8 8b 29 00 00       	call   801049d0 <initlock>
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
801020be:	e8 4d 2a 00 00       	call   80104b10 <acquire>

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
80102121:	e8 ea 1f 00 00       	call   80104110 <wakeup>

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
8010213f:	e8 8c 2a 00 00       	call   80104bd0 <release>

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
8010215e:	e8 1d 28 00 00       	call   80104980 <holdingsleep>
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
80102198:	e8 73 29 00 00       	call   80104b10 <acquire>

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
801021e9:	e8 42 1e 00 00       	call   80104030 <sleep>
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
80102206:	e9 c5 29 00 00       	jmp    80104bd0 <release>
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
8010222a:	68 80 79 10 80       	push   $0x80107980
8010222f:	e8 5c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102234:	83 ec 0c             	sub    $0xc,%esp
80102237:	68 6a 79 10 80       	push   $0x8010796a
8010223c:	e8 4f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102241:	83 ec 0c             	sub    $0xc,%esp
80102244:	68 95 79 10 80       	push   $0x80107995
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
801022a7:	68 b4 79 10 80       	push   $0x801079b4
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
80102382:	e8 99 28 00 00       	call   80104c20 <memset>

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
801023bb:	e9 10 28 00 00       	jmp    80104bd0 <release>
    acquire(&kmem.lock);
801023c0:	83 ec 0c             	sub    $0xc,%esp
801023c3:	68 40 36 11 80       	push   $0x80113640
801023c8:	e8 43 27 00 00       	call   80104b10 <acquire>
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	eb c2                	jmp    80102394 <kfree+0x44>
    panic("kfree");
801023d2:	83 ec 0c             	sub    $0xc,%esp
801023d5:	68 e6 79 10 80       	push   $0x801079e6
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
8010243b:	68 ec 79 10 80       	push   $0x801079ec
80102440:	68 40 36 11 80       	push   $0x80113640
80102445:	e8 86 25 00 00       	call   801049d0 <initlock>
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
80102533:	e8 d8 25 00 00       	call   80104b10 <acquire>
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
80102561:	e8 6a 26 00 00       	call   80104bd0 <release>
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
801025b3:	0f b6 82 20 7b 10 80 	movzbl -0x7fef84e0(%edx),%eax
801025ba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025bc:	0f b6 82 20 7a 10 80 	movzbl -0x7fef85e0(%edx),%eax
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
801025d3:	8b 04 85 00 7a 10 80 	mov    -0x7fef8600(,%eax,4),%eax
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
801025f8:	0f b6 82 20 7b 10 80 	movzbl -0x7fef84e0(%edx),%eax
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
80102977:	e8 f4 22 00 00       	call   80104c70 <memcmp>
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
80102aa4:	e8 27 22 00 00       	call   80104cd0 <memmove>
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
80102b4a:	68 20 7c 10 80       	push   $0x80107c20
80102b4f:	68 80 36 11 80       	push   $0x80113680
80102b54:	e8 77 1e 00 00       	call   801049d0 <initlock>
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
80102beb:	e8 20 1f 00 00       	call   80104b10 <acquire>
80102bf0:	83 c4 10             	add    $0x10,%esp
80102bf3:	eb 18                	jmp    80102c0d <begin_op+0x2d>
80102bf5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bf8:	83 ec 08             	sub    $0x8,%esp
80102bfb:	68 80 36 11 80       	push   $0x80113680
80102c00:	68 80 36 11 80       	push   $0x80113680
80102c05:	e8 26 14 00 00       	call   80104030 <sleep>
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
80102c3c:	e8 8f 1f 00 00       	call   80104bd0 <release>
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
80102c5e:	e8 ad 1e 00 00       	call   80104b10 <acquire>
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
80102c9c:	e8 2f 1f 00 00       	call   80104bd0 <release>
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
80102cf6:	e8 d5 1f 00 00       	call   80104cd0 <memmove>
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
80102d3f:	e8 cc 1d 00 00       	call   80104b10 <acquire>
    wakeup(&log);
80102d44:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d4b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d52:	00 00 00 
    wakeup(&log);
80102d55:	e8 b6 13 00 00       	call   80104110 <wakeup>
    release(&log.lock);
80102d5a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d61:	e8 6a 1e 00 00       	call   80104bd0 <release>
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
80102d80:	e8 8b 13 00 00       	call   80104110 <wakeup>
  release(&log.lock);
80102d85:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d8c:	e8 3f 1e 00 00       	call   80104bd0 <release>
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
80102d9f:	68 24 7c 10 80       	push   $0x80107c24
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
80102dee:	e8 1d 1d 00 00       	call   80104b10 <acquire>
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
80102e3d:	e9 8e 1d 00 00       	jmp    80104bd0 <release>
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
80102e69:	68 33 7c 10 80       	push   $0x80107c33
80102e6e:	e8 1d d5 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e73:	83 ec 0c             	sub    $0xc,%esp
80102e76:	68 49 7c 10 80       	push   $0x80107c49
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
80102e87:	e8 44 09 00 00       	call   801037d0 <cpuid>
80102e8c:	89 c3                	mov    %eax,%ebx
80102e8e:	e8 3d 09 00 00       	call   801037d0 <cpuid>
80102e93:	83 ec 04             	sub    $0x4,%esp
80102e96:	53                   	push   %ebx
80102e97:	50                   	push   %eax
80102e98:	68 64 7c 10 80       	push   $0x80107c64
80102e9d:	e8 be d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ea2:	e8 e9 30 00 00       	call   80105f90 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ea7:	e8 a4 08 00 00       	call   80103750 <mycpu>
80102eac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102eae:	b8 01 00 00 00       	mov    $0x1,%eax
80102eb3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eba:	e8 d1 15 00 00       	call   80104490 <scheduler>
80102ebf:	90                   	nop

80102ec0 <mpenter>:
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ec6:	e8 b5 41 00 00       	call   80107080 <switchkvm>
  seginit();
80102ecb:	e8 20 41 00 00       	call   80106ff0 <seginit>
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
80102f01:	e8 4a 46 00 00       	call   80107550 <kvmalloc>
  mpinit();        // detect other processors
80102f06:	e8 75 01 00 00       	call   80103080 <mpinit>
  lapicinit();     // interrupt controller
80102f0b:	e8 60 f7 ff ff       	call   80102670 <lapicinit>
  seginit();       // segment descriptors
80102f10:	e8 db 40 00 00       	call   80106ff0 <seginit>
  picinit();       // disable pic
80102f15:	e8 46 03 00 00       	call   80103260 <picinit>
  ioapicinit();    // another interrupt controller
80102f1a:	e8 41 f3 ff ff       	call   80102260 <ioapicinit>
  consoleinit();   // console hardware
80102f1f:	e8 9c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f24:	e8 97 33 00 00       	call   801062c0 <uartinit>
  pinit();         // process table
80102f29:	e8 02 08 00 00       	call   80103730 <pinit>
  tvinit();        // trap vectors
80102f2e:	e8 dd 2f 00 00       	call   80105f10 <tvinit>
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
80102f54:	e8 77 1d 00 00       	call   80104cd0 <memmove>

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
80102f80:	e8 cb 07 00 00       	call   80103750 <mycpu>
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
80102ff5:	e8 56 09 00 00       	call   80103950 <userinit>
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
8010302e:	68 78 7c 10 80       	push   $0x80107c78
80103033:	56                   	push   %esi
80103034:	e8 37 1c 00 00       	call   80104c70 <memcmp>
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
801030ec:	68 95 7c 10 80       	push   $0x80107c95
801030f1:	56                   	push   %esi
801030f2:	e8 79 1b 00 00       	call   80104c70 <memcmp>
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
80103180:	ff 24 95 bc 7c 10 80 	jmp    *-0x7fef8344(,%edx,4)
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
80103233:	68 7d 7c 10 80       	push   $0x80107c7d
80103238:	e8 53 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010323d:	83 ec 0c             	sub    $0xc,%esp
80103240:	68 9c 7c 10 80       	push   $0x80107c9c
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
8010333b:	68 d0 7c 10 80       	push   $0x80107cd0
80103340:	50                   	push   %eax
80103341:	e8 8a 16 00 00       	call   801049d0 <initlock>
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
8010339f:	e8 6c 17 00 00       	call   80104b10 <acquire>
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
801033bf:	e8 4c 0d 00 00       	call   80104110 <wakeup>
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
801033e4:	e9 e7 17 00 00       	jmp    80104bd0 <release>
801033e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801033f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801033f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801033f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103400:	00 00 00 
    wakeup(&p->nwrite);
80103403:	50                   	push   %eax
80103404:	e8 07 0d 00 00       	call   80104110 <wakeup>
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	eb b9                	jmp    801033c7 <pipeclose+0x37>
8010340e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	53                   	push   %ebx
80103414:	e8 b7 17 00 00       	call   80104bd0 <release>
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
8010343d:	e8 ce 16 00 00       	call   80104b10 <acquire>
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
80103494:	e8 77 0c 00 00       	call   80104110 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103499:	5a                   	pop    %edx
8010349a:	59                   	pop    %ecx
8010349b:	53                   	push   %ebx
8010349c:	56                   	push   %esi
8010349d:	e8 8e 0b 00 00       	call   80104030 <sleep>
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
801034c4:	e8 27 03 00 00       	call   801037f0 <myproc>
801034c9:	8b 40 24             	mov    0x24(%eax),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 c0                	je     80103490 <pipewrite+0x60>
        release(&p->lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	53                   	push   %ebx
801034d4:	e8 f7 16 00 00       	call   80104bd0 <release>
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
80103523:	e8 e8 0b 00 00       	call   80104110 <wakeup>
  release(&p->lock);
80103528:	89 1c 24             	mov    %ebx,(%esp)
8010352b:	e8 a0 16 00 00       	call   80104bd0 <release>
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
80103550:	e8 bb 15 00 00       	call   80104b10 <acquire>
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
80103585:	e8 a6 0a 00 00       	call   80104030 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010358a:	83 c4 10             	add    $0x10,%esp
8010358d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103593:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103599:	75 35                	jne    801035d0 <piperead+0x90>
8010359b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	0f 84 8f 00 00 00    	je     80103638 <piperead+0xf8>
    if(myproc()->killed){
801035a9:	e8 42 02 00 00       	call   801037f0 <myproc>
801035ae:	8b 48 24             	mov    0x24(%eax),%ecx
801035b1:	85 c9                	test   %ecx,%ecx
801035b3:	74 cb                	je     80103580 <piperead+0x40>
      release(&p->lock);
801035b5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035bd:	56                   	push   %esi
801035be:	e8 0d 16 00 00       	call   80104bd0 <release>
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
80103617:	e8 f4 0a 00 00       	call   80104110 <wakeup>
  release(&p->lock);
8010361c:	89 34 24             	mov    %esi,(%esp)
8010361f:	e8 ac 15 00 00       	call   80104bd0 <release>
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
80103641:	89 c1                	mov    %eax,%ecx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103643:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
{
80103648:	89 e5                	mov    %esp,%ebp
8010364a:	57                   	push   %edi
8010364b:	56                   	push   %esi
8010364c:	53                   	push   %ebx

static inline int
cas(volatile void *addr, int expected, int newval){
  int eflags;

  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010364d:	be fd ff ff ff       	mov    $0xfffffffd,%esi
80103652:	83 ec 1c             	sub    $0x1c,%esp
80103655:	eb 17                	jmp    8010366e <wakeup1+0x2e>
80103657:	89 f6                	mov    %esi,%esi
80103659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103660:	81 c2 90 01 00 00    	add    $0x190,%edx
80103666:	81 fa 54 a1 11 80    	cmp    $0x8011a154,%edx
8010366c:	73 62                	jae    801036d0 <wakeup1+0x90>
    if(p->chan == chan && (p->state == SLEEPING || p->state == -SLEEPING)){
8010366e:	39 4a 20             	cmp    %ecx,0x20(%edx)
80103671:	75 ed                	jne    80103660 <wakeup1+0x20>
80103673:	8b 42 0c             	mov    0xc(%edx),%eax
80103676:	83 f8 02             	cmp    $0x2,%eax
80103679:	74 0d                	je     80103688 <wakeup1+0x48>
8010367b:	8b 42 0c             	mov    0xc(%edx),%eax
8010367e:	83 f8 fe             	cmp    $0xfffffffe,%eax
80103681:	75 dd                	jne    80103660 <wakeup1+0x20>
80103683:	90                   	nop
80103684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(p->state == -SLEEPING);
80103688:	8b 42 0c             	mov    0xc(%edx),%eax
8010368b:	83 f8 fe             	cmp    $0xfffffffe,%eax
8010368e:	74 f8                	je     80103688 <wakeup1+0x48>
80103690:	8d 5a 0c             	lea    0xc(%edx),%ebx
80103693:	b8 02 00 00 00       	mov    $0x2,%eax
80103698:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
8010369c:	9c                   	pushf  
8010369d:	8f 45 e4             	popl   -0x1c(%ebp)
      if(cas(&p->state,SLEEPING,-RUNNABLE)){
801036a0:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801036a4:	74 ba                	je     80103660 <wakeup1+0x20>
        p->chan = 0;
801036a6:	c7 42 20 00 00 00 00 	movl   $0x0,0x20(%edx)
801036ad:	bf 03 00 00 00       	mov    $0x3,%edi
801036b2:	89 f0                	mov    %esi,%eax
801036b4:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
801036b8:	9c                   	pushf  
801036b9:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&p->state,-RUNNABLE,RUNNABLE)){
801036bc:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801036c0:	75 9e                	jne    80103660 <wakeup1+0x20>
          panic("wakeup cas");
801036c2:	83 ec 0c             	sub    $0xc,%esp
801036c5:	68 d5 7c 10 80       	push   $0x80107cd5
801036ca:	e8 c1 cc ff ff       	call   80100390 <panic>
801036cf:	90                   	nop
        }
      }
    }
  }
}
801036d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036d3:	5b                   	pop    %ebx
801036d4:	5e                   	pop    %esi
801036d5:	5f                   	pop    %edi
801036d6:	5d                   	pop    %ebp
801036d7:	c3                   	ret    
801036d8:	90                   	nop
801036d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036e0 <forkret>:
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 08             	sub    $0x8,%esp
  popcli();
801036e6:	e8 95 13 00 00       	call   80104a80 <popcli>
  if (first) {
801036eb:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801036f0:	85 c0                	test   %eax,%eax
801036f2:	75 0c                	jne    80103700 <forkret+0x20>
}
801036f4:	c9                   	leave  
801036f5:	c3                   	ret    
801036f6:	8d 76 00             	lea    0x0(%esi),%esi
801036f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iinit(ROOTDEV);
80103700:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103703:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010370a:	00 00 00 
    iinit(ROOTDEV);
8010370d:	6a 01                	push   $0x1
8010370f:	e8 9c dd ff ff       	call   801014b0 <iinit>
    initlog(ROOTDEV);
80103714:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010371b:	e8 20 f4 ff ff       	call   80102b40 <initlog>
80103720:	83 c4 10             	add    $0x10,%esp
}
80103723:	c9                   	leave  
80103724:	c3                   	ret    
80103725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <pinit>:
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103736:	68 e0 7c 10 80       	push   $0x80107ce0
8010373b:	68 20 3d 11 80       	push   $0x80113d20
80103740:	e8 8b 12 00 00       	call   801049d0 <initlock>
}
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	c9                   	leave  
80103749:	c3                   	ret    
8010374a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103750 <mycpu>:
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103755:	9c                   	pushf  
80103756:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103757:	f6 c4 02             	test   $0x2,%ah
8010375a:	75 5e                	jne    801037ba <mycpu+0x6a>
  apicid = lapicid();
8010375c:	e8 0f f0 ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103761:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103767:	85 f6                	test   %esi,%esi
80103769:	7e 42                	jle    801037ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010376b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103772:	39 d0                	cmp    %edx,%eax
80103774:	74 30                	je     801037a6 <mycpu+0x56>
80103776:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010377b:	31 d2                	xor    %edx,%edx
8010377d:	8d 76 00             	lea    0x0(%esi),%esi
80103780:	83 c2 01             	add    $0x1,%edx
80103783:	39 f2                	cmp    %esi,%edx
80103785:	74 26                	je     801037ad <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103787:	0f b6 19             	movzbl (%ecx),%ebx
8010378a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103790:	39 c3                	cmp    %eax,%ebx
80103792:	75 ec                	jne    80103780 <mycpu+0x30>
80103794:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010379a:	05 80 37 11 80       	add    $0x80113780,%eax
}
8010379f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a2:	5b                   	pop    %ebx
801037a3:	5e                   	pop    %esi
801037a4:	5d                   	pop    %ebp
801037a5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037a6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
801037ab:	eb f2                	jmp    8010379f <mycpu+0x4f>
  panic("unknown apicid\n");
801037ad:	83 ec 0c             	sub    $0xc,%esp
801037b0:	68 e7 7c 10 80       	push   $0x80107ce7
801037b5:	e8 d6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ba:	83 ec 0c             	sub    $0xc,%esp
801037bd:	68 20 7e 10 80       	push   $0x80107e20
801037c2:	e8 c9 cb ff ff       	call   80100390 <panic>
801037c7:	89 f6                	mov    %esi,%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <cpuid>:
cpuid() {
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801037d6:	e8 75 ff ff ff       	call   80103750 <mycpu>
801037db:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
801037e0:	c9                   	leave  
  return mycpu()-cpus;
801037e1:	c1 f8 04             	sar    $0x4,%eax
801037e4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801037ea:	c3                   	ret    
801037eb:	90                   	nop
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037f0 <myproc>:
myproc(void) {
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
801037f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801037f7:	e8 44 12 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801037fc:	e8 4f ff ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103801:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103807:	e8 74 12 00 00       	call   80104a80 <popcli>
}
8010380c:	83 c4 04             	add    $0x4,%esp
8010380f:	89 d8                	mov    %ebx,%eax
80103811:	5b                   	pop    %ebx
80103812:	5d                   	pop    %ebp
80103813:	c3                   	ret    
80103814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010381a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103820 <allocpid>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	bb 04 b0 10 80       	mov    $0x8010b004,%ebx
8010382a:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010382d:	e8 0e 12 00 00       	call   80104a40 <pushcli>
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pid = nextpid;
80103838:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  }while (!cas(&nextpid,pid,pid+1));
8010383d:	8d 70 01             	lea    0x1(%eax),%esi
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103840:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103844:	9c                   	pushf  
80103845:	8f 45 f4             	popl   -0xc(%ebp)
80103848:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
8010384c:	74 ea                	je     80103838 <allocpid+0x18>
  popcli();
8010384e:	e8 2d 12 00 00       	call   80104a80 <popcli>
}
80103853:	83 c4 10             	add    $0x10,%esp
80103856:	89 f0                	mov    %esi,%eax
80103858:	5b                   	pop    %ebx
80103859:	5e                   	pop    %esi
8010385a:	5d                   	pop    %ebp
8010385b:	c3                   	ret    
8010385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103860 <allocproc>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103865:	be 54 3d 11 80       	mov    $0x80113d54,%esi
{
8010386a:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010386d:	e8 ce 11 00 00       	call   80104a40 <pushcli>
80103872:	31 c0                	xor    %eax,%eax
80103874:	ba 01 00 00 00       	mov    $0x1,%edx
80103879:	eb 17                	jmp    80103892 <allocproc+0x32>
8010387b:	90                   	nop
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103880:	81 c6 90 01 00 00    	add    $0x190,%esi
80103886:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
8010388c:	0f 83 a2 00 00 00    	jae    80103934 <allocproc+0xd4>
80103892:	8d 5e 0c             	lea    0xc(%esi),%ebx
80103895:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103899:	9c                   	pushf  
8010389a:	8f 45 f4             	popl   -0xc(%ebp)
      if(cas(&(p->state),UNUSED,EMBRYO)){
8010389d:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
801038a1:	74 dd                	je     80103880 <allocproc+0x20>
  popcli();
801038a3:	e8 d8 11 00 00       	call   80104a80 <popcli>
  p->pid = allocpid();
801038a8:	e8 73 ff ff ff       	call   80103820 <allocpid>
801038ad:	89 46 10             	mov    %eax,0x10(%esi)
  if((p->kstack = kalloc()) == 0){
801038b0:	e8 4b ec ff ff       	call   80102500 <kalloc>
801038b5:	85 c0                	test   %eax,%eax
801038b7:	89 46 08             	mov    %eax,0x8(%esi)
801038ba:	0f 84 84 00 00 00    	je     80103944 <allocproc+0xe4>
  sp -= sizeof *p->tf;
801038c0:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
801038c6:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038c9:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038ce:	89 56 18             	mov    %edx,0x18(%esi)
  *(uint*)sp = (uint)trapret;
801038d1:	c7 40 14 f7 5e 10 80 	movl   $0x80105ef7,0x14(%eax)
  p->context = (struct context*)sp;
801038d8:	89 46 1c             	mov    %eax,0x1c(%esi)
  memset(p->context, 0, sizeof *p->context);
801038db:	6a 14                	push   $0x14
801038dd:	6a 00                	push   $0x0
801038df:	50                   	push   %eax
801038e0:	e8 3b 13 00 00       	call   80104c20 <memset>
  p->context->eip = (uint)forkret;
801038e5:	8b 46 1c             	mov    0x1c(%esi),%eax
801038e8:	8d 96 0c 01 00 00    	lea    0x10c(%esi),%edx
801038ee:	83 c4 10             	add    $0x10,%esp
801038f1:	c7 40 10 e0 36 10 80 	movl   $0x801036e0,0x10(%eax)
801038f8:	8d 86 8c 00 00 00    	lea    0x8c(%esi),%eax
801038fe:	66 90                	xchg   %ax,%ax
    p->signalHandler[i] =(void*)SIG_DFL;
80103900:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103907:	00 00 00 
    p->signalHandlerMasks[i] = 0;
8010390a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103910:	83 c0 04             	add    $0x4,%eax
  for(int i = 0 ; i < SIGNAL_HANDLERS_SIZE ; i++){
80103913:	39 c2                	cmp    %eax,%edx
80103915:	75 e9                	jne    80103900 <allocproc+0xa0>
  p->pendingSignals = 0;
80103917:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010391e:	00 00 00 
  p->signalMask = 0;
80103921:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80103928:	00 00 00 
}
8010392b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010392e:	89 f0                	mov    %esi,%eax
80103930:	5b                   	pop    %ebx
80103931:	5e                   	pop    %esi
80103932:	5d                   	pop    %ebp
80103933:	c3                   	ret    
    popcli();
80103934:	e8 47 11 00 00       	call   80104a80 <popcli>
}
80103939:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010393c:	31 f6                	xor    %esi,%esi
}
8010393e:	89 f0                	mov    %esi,%eax
80103940:	5b                   	pop    %ebx
80103941:	5e                   	pop    %esi
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    
    p->state = UNUSED;
80103944:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return 0;
8010394b:	31 f6                	xor    %esi,%esi
8010394d:	eb dc                	jmp    8010392b <allocproc+0xcb>
8010394f:	90                   	nop

80103950 <userinit>:
{
80103950:	55                   	push   %ebp
80103951:	89 e5                	mov    %esp,%ebp
80103953:	53                   	push   %ebx
80103954:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103957:	e8 04 ff ff ff       	call   80103860 <allocproc>
8010395c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010395e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103963:	e8 68 3b 00 00       	call   801074d0 <setupkvm>
80103968:	85 c0                	test   %eax,%eax
8010396a:	89 43 04             	mov    %eax,0x4(%ebx)
8010396d:	0f 84 c3 00 00 00    	je     80103a36 <userinit+0xe6>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103973:	83 ec 04             	sub    $0x4,%esp
80103976:	68 2c 00 00 00       	push   $0x2c
8010397b:	68 60 b4 10 80       	push   $0x8010b460
80103980:	50                   	push   %eax
80103981:	e8 2a 38 00 00       	call   801071b0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103986:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103989:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010398f:	6a 4c                	push   $0x4c
80103991:	6a 00                	push   $0x0
80103993:	ff 73 18             	pushl  0x18(%ebx)
80103996:	e8 85 12 00 00       	call   80104c20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399b:	8b 43 18             	mov    0x18(%ebx),%eax
8010399e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039a3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039a8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ab:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039af:	8b 43 18             	mov    0x18(%ebx),%eax
801039b2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039b6:	8b 43 18             	mov    0x18(%ebx),%eax
801039b9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039bd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039c1:	8b 43 18             	mov    0x18(%ebx),%eax
801039c4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039c8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039cc:	8b 43 18             	mov    0x18(%ebx),%eax
801039cf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039d6:	8b 43 18             	mov    0x18(%ebx),%eax
801039d9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039e0:	8b 43 18             	mov    0x18(%ebx),%eax
801039e3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ea:	8d 43 70             	lea    0x70(%ebx),%eax
801039ed:	6a 10                	push   $0x10
801039ef:	68 10 7d 10 80       	push   $0x80107d10
  if(!cas(&p->state,EMBRYO,RUNNABLE)){
801039f4:	83 c3 0c             	add    $0xc,%ebx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039f7:	50                   	push   %eax
801039f8:	e8 03 14 00 00       	call   80104e00 <safestrcpy>
  p->cwd = namei("/");
801039fd:	c7 04 24 19 7d 10 80 	movl   $0x80107d19,(%esp)
80103a04:	e8 07 e5 ff ff       	call   80101f10 <namei>
80103a09:	89 43 60             	mov    %eax,0x60(%ebx)
  pushcli();
80103a0c:	e8 2f 10 00 00       	call   80104a40 <pushcli>
80103a11:	b8 01 00 00 00       	mov    $0x1,%eax
80103a16:	ba 03 00 00 00       	mov    $0x3,%edx
80103a1b:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103a1f:	9c                   	pushf  
80103a20:	8f 45 f4             	popl   -0xc(%ebp)
  if(!cas(&p->state,EMBRYO,RUNNABLE)){
80103a23:	83 c4 10             	add    $0x10,%esp
80103a26:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
80103a2a:	74 17                	je     80103a43 <userinit+0xf3>
  popcli();
80103a2c:	e8 4f 10 00 00       	call   80104a80 <popcli>
}
80103a31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a34:	c9                   	leave  
80103a35:	c3                   	ret    
    panic("userinit: out of memory?");
80103a36:	83 ec 0c             	sub    $0xc,%esp
80103a39:	68 f7 7c 10 80       	push   $0x80107cf7
80103a3e:	e8 4d c9 ff ff       	call   80100390 <panic>
    panic("user init cas err");
80103a43:	83 ec 0c             	sub    $0xc,%esp
80103a46:	68 1b 7d 10 80       	push   $0x80107d1b
80103a4b:	e8 40 c9 ff ff       	call   80100390 <panic>

80103a50 <growproc>:
{
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	56                   	push   %esi
80103a54:	53                   	push   %ebx
80103a55:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a58:	e8 e3 0f 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103a5d:	e8 ee fc ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103a62:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a68:	e8 13 10 00 00       	call   80104a80 <popcli>
  if(n > 0){
80103a6d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a70:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a72:	7f 1c                	jg     80103a90 <growproc+0x40>
  } else if(n < 0){
80103a74:	75 3a                	jne    80103ab0 <growproc+0x60>
  switchuvm(curproc);
80103a76:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a79:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a7b:	53                   	push   %ebx
80103a7c:	e8 1f 36 00 00       	call   801070a0 <switchuvm>
  return 0;
80103a81:	83 c4 10             	add    $0x10,%esp
80103a84:	31 c0                	xor    %eax,%eax
}
80103a86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a89:	5b                   	pop    %ebx
80103a8a:	5e                   	pop    %esi
80103a8b:	5d                   	pop    %ebp
80103a8c:	c3                   	ret    
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a90:	83 ec 04             	sub    $0x4,%esp
80103a93:	01 c6                	add    %eax,%esi
80103a95:	56                   	push   %esi
80103a96:	50                   	push   %eax
80103a97:	ff 73 04             	pushl  0x4(%ebx)
80103a9a:	e8 51 38 00 00       	call   801072f0 <allocuvm>
80103a9f:	83 c4 10             	add    $0x10,%esp
80103aa2:	85 c0                	test   %eax,%eax
80103aa4:	75 d0                	jne    80103a76 <growproc+0x26>
      return -1;
80103aa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103aab:	eb d9                	jmp    80103a86 <growproc+0x36>
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ab0:	83 ec 04             	sub    $0x4,%esp
80103ab3:	01 c6                	add    %eax,%esi
80103ab5:	56                   	push   %esi
80103ab6:	50                   	push   %eax
80103ab7:	ff 73 04             	pushl  0x4(%ebx)
80103aba:	e8 61 39 00 00       	call   80107420 <deallocuvm>
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	85 c0                	test   %eax,%eax
80103ac4:	75 b0                	jne    80103a76 <growproc+0x26>
80103ac6:	eb de                	jmp    80103aa6 <growproc+0x56>
80103ac8:	90                   	nop
80103ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <fork>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	57                   	push   %edi
80103ad4:	56                   	push   %esi
80103ad5:	53                   	push   %ebx
80103ad6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103ad9:	e8 62 0f 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103ade:	e8 6d fc ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103ae3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae9:	e8 92 0f 00 00       	call   80104a80 <popcli>
  if((np = allocproc()) == 0){
80103aee:	e8 6d fd ff ff       	call   80103860 <allocproc>
80103af3:	85 c0                	test   %eax,%eax
80103af5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103af8:	0f 84 09 01 00 00    	je     80103c07 <fork+0x137>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103afe:	83 ec 08             	sub    $0x8,%esp
80103b01:	ff 33                	pushl  (%ebx)
80103b03:	ff 73 04             	pushl  0x4(%ebx)
80103b06:	e8 95 3a 00 00       	call   801075a0 <copyuvm>
80103b0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103b0e:	83 c4 10             	add    $0x10,%esp
80103b11:	85 c0                	test   %eax,%eax
80103b13:	89 42 04             	mov    %eax,0x4(%edx)
80103b16:	0f 84 f2 00 00 00    	je     80103c0e <fork+0x13e>
  np->sz = curproc->sz;
80103b1c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103b1e:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103b23:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b26:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
80103b29:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103b2b:	8b 73 18             	mov    0x18(%ebx),%esi
80103b2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->signalMask = curproc->signalMask;
80103b30:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  np->pendingSignals = 0;
80103b36:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80103b3d:	00 00 00 
  np->signalMask = curproc->signalMask;
80103b40:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  for(int i = 0 ; i < 32 ; i++){
80103b46:	31 c0                	xor    %eax,%eax
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->signalHandler[i] = curproc->signalHandler[i];
80103b50:	8b 8c 83 0c 01 00 00 	mov    0x10c(%ebx,%eax,4),%ecx
80103b57:	89 8c 82 0c 01 00 00 	mov    %ecx,0x10c(%edx,%eax,4)
    np->signalHandlerMasks[i] = curproc->signalHandlerMasks[i];
80103b5e:	8b 8c 83 8c 00 00 00 	mov    0x8c(%ebx,%eax,4),%ecx
80103b65:	89 8c 82 8c 00 00 00 	mov    %ecx,0x8c(%edx,%eax,4)
  for(int i = 0 ; i < 32 ; i++){
80103b6c:	83 c0 01             	add    $0x1,%eax
80103b6f:	83 f8 20             	cmp    $0x20,%eax
80103b72:	75 dc                	jne    80103b50 <fork+0x80>
  np->tf->eax = 0;
80103b74:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80103b77:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b79:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103b80:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103b84:	85 c0                	test   %eax,%eax
80103b86:	74 16                	je     80103b9e <fork+0xce>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b88:	83 ec 0c             	sub    $0xc,%esp
80103b8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80103b8e:	50                   	push   %eax
80103b8f:	e8 8c d2 ff ff       	call   80100e20 <filedup>
80103b94:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103b97:	83 c4 10             	add    $0x10,%esp
80103b9a:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b9e:	83 c6 01             	add    $0x1,%esi
80103ba1:	83 fe 10             	cmp    $0x10,%esi
80103ba4:	75 da                	jne    80103b80 <fork+0xb0>
  np->cwd = idup(curproc->cwd);
80103ba6:	83 ec 0c             	sub    $0xc,%esp
80103ba9:	ff 73 6c             	pushl  0x6c(%ebx)
80103bac:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103baf:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103bb2:	e8 c9 da ff ff       	call   80101680 <idup>
80103bb7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bba:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bbd:	89 42 6c             	mov    %eax,0x6c(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bc0:	8d 42 70             	lea    0x70(%edx),%eax
80103bc3:	6a 10                	push   $0x10
80103bc5:	53                   	push   %ebx
80103bc6:	50                   	push   %eax
80103bc7:	e8 34 12 00 00       	call   80104e00 <safestrcpy>
  pid = np->pid;
80103bcc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103bcf:	8b 72 10             	mov    0x10(%edx),%esi
  pushcli();
80103bd2:	e8 69 0e 00 00       	call   80104a40 <pushcli>
  if(!cas(&np->state,EMBRYO,RUNNABLE)){
80103bd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80103bda:	b8 01 00 00 00       	mov    $0x1,%eax
80103bdf:	8d 5a 0c             	lea    0xc(%edx),%ebx
80103be2:	ba 03 00 00 00       	mov    $0x3,%edx
80103be7:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103beb:	9c                   	pushf  
80103bec:	8f 45 e4             	popl   -0x1c(%ebp)
80103bef:	83 c4 10             	add    $0x10,%esp
80103bf2:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103bf6:	74 3c                	je     80103c34 <fork+0x164>
  popcli();
80103bf8:	e8 83 0e 00 00       	call   80104a80 <popcli>
}
80103bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c00:	89 f0                	mov    %esi,%eax
80103c02:	5b                   	pop    %ebx
80103c03:	5e                   	pop    %esi
80103c04:	5f                   	pop    %edi
80103c05:	5d                   	pop    %ebp
80103c06:	c3                   	ret    
    return -1;
80103c07:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c0c:	eb ef                	jmp    80103bfd <fork+0x12d>
    kfree(np->kstack);
80103c0e:	83 ec 0c             	sub    $0xc,%esp
80103c11:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80103c14:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c19:	e8 32 e7 ff ff       	call   80102350 <kfree>
    np->kstack = 0;
80103c1e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    return -1;
80103c21:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103c24:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80103c2b:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80103c32:	eb c9                	jmp    80103bfd <fork+0x12d>
    panic("fork cas error");
80103c34:	83 ec 0c             	sub    $0xc,%esp
80103c37:	68 2d 7d 10 80       	push   $0x80107d2d
80103c3c:	e8 4f c7 ff ff       	call   80100390 <panic>
80103c41:	eb 0d                	jmp    80103c50 <sched>
80103c43:	90                   	nop
80103c44:	90                   	nop
80103c45:	90                   	nop
80103c46:	90                   	nop
80103c47:	90                   	nop
80103c48:	90                   	nop
80103c49:	90                   	nop
80103c4a:	90                   	nop
80103c4b:	90                   	nop
80103c4c:	90                   	nop
80103c4d:	90                   	nop
80103c4e:	90                   	nop
80103c4f:	90                   	nop

80103c50 <sched>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	56                   	push   %esi
80103c54:	53                   	push   %ebx
  pushcli();
80103c55:	e8 e6 0d 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103c5a:	e8 f1 fa ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103c5f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c65:	e8 16 0e 00 00       	call   80104a80 <popcli>
  if(mycpu()->ncli != 1)
80103c6a:	e8 e1 fa ff ff       	call   80103750 <mycpu>
80103c6f:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c76:	75 43                	jne    80103cbb <sched+0x6b>
  if(p->state == RUNNING)
80103c78:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c7b:	83 f8 04             	cmp    $0x4,%eax
80103c7e:	74 55                	je     80103cd5 <sched+0x85>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c80:	9c                   	pushf  
80103c81:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c82:	f6 c4 02             	test   $0x2,%ah
80103c85:	75 41                	jne    80103cc8 <sched+0x78>
  intena = mycpu()->intena;
80103c87:	e8 c4 fa ff ff       	call   80103750 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c8c:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c8f:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c95:	e8 b6 fa ff ff       	call   80103750 <mycpu>
80103c9a:	83 ec 08             	sub    $0x8,%esp
80103c9d:	ff 70 04             	pushl  0x4(%eax)
80103ca0:	53                   	push   %ebx
80103ca1:	e8 b5 11 00 00       	call   80104e5b <swtch>
  mycpu()->intena = intena;
80103ca6:	e8 a5 fa ff ff       	call   80103750 <mycpu>
}
80103cab:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cae:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cb4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb7:	5b                   	pop    %ebx
80103cb8:	5e                   	pop    %esi
80103cb9:	5d                   	pop    %ebp
80103cba:	c3                   	ret    
    panic("sched locks");
80103cbb:	83 ec 0c             	sub    $0xc,%esp
80103cbe:	68 3c 7d 10 80       	push   $0x80107d3c
80103cc3:	e8 c8 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	68 56 7d 10 80       	push   $0x80107d56
80103cd0:	e8 bb c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103cd5:	83 ec 0c             	sub    $0xc,%esp
80103cd8:	68 48 7d 10 80       	push   $0x80107d48
80103cdd:	e8 ae c6 ff ff       	call   80100390 <panic>
80103ce2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <exit>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103cf9:	e8 42 0d 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103cfe:	e8 4d fa ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103d03:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d09:	e8 72 0d 00 00       	call   80104a80 <popcli>
  if(curproc == initproc)
80103d0e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103d14:	8d 5e 2c             	lea    0x2c(%esi),%ebx
80103d17:	8d 7e 6c             	lea    0x6c(%esi),%edi
80103d1a:	0f 84 e2 00 00 00    	je     80103e02 <exit+0x112>
    if(curproc->ofile[fd]){
80103d20:	8b 03                	mov    (%ebx),%eax
80103d22:	85 c0                	test   %eax,%eax
80103d24:	74 12                	je     80103d38 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d26:	83 ec 0c             	sub    $0xc,%esp
80103d29:	50                   	push   %eax
80103d2a:	e8 41 d1 ff ff       	call   80100e70 <fileclose>
      curproc->ofile[fd] = 0;
80103d2f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d3b:	39 df                	cmp    %ebx,%edi
80103d3d:	75 e1                	jne    80103d20 <exit+0x30>
  begin_op();
80103d3f:	e8 9c ee ff ff       	call   80102be0 <begin_op>
  iput(curproc->cwd);
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	ff 76 6c             	pushl  0x6c(%esi)
  if(!cas(&curproc->state,RUNNING,-ZOMBIE)){
80103d4a:	8d 5e 0c             	lea    0xc(%esi),%ebx
  iput(curproc->cwd);
80103d4d:	e8 8e da ff ff       	call   801017e0 <iput>
  end_op();
80103d52:	e8 f9 ee ff ff       	call   80102c50 <end_op>
  curproc->cwd = 0;
80103d57:	c7 46 6c 00 00 00 00 	movl   $0x0,0x6c(%esi)
  pushcli();
80103d5e:	e8 dd 0c 00 00       	call   80104a40 <pushcli>
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103d63:	b8 04 00 00 00       	mov    $0x4,%eax
80103d68:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
80103d6d:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103d71:	9c                   	pushf  
80103d72:	8f 45 e4             	popl   -0x1c(%ebp)
  if(!cas(&curproc->state,RUNNING,-ZOMBIE)){
80103d75:	83 c4 10             	add    $0x10,%esp
80103d78:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103d7c:	74 6c                	je     80103dea <exit+0xfa>
   wakeup1(curproc->parent);
80103d7e:	8b 46 14             	mov    0x14(%esi),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d81:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
   wakeup1(curproc->parent);
80103d86:	e8 b5 f8 ff ff       	call   80103640 <wakeup1>
80103d8b:	eb 11                	jmp    80103d9e <exit+0xae>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d90:	81 c3 90 01 00 00    	add    $0x190,%ebx
80103d96:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
80103d9c:	73 3a                	jae    80103dd8 <exit+0xe8>
    if(p->parent == curproc){
80103d9e:	39 73 14             	cmp    %esi,0x14(%ebx)
80103da1:	75 ed                	jne    80103d90 <exit+0xa0>
      p->parent = initproc;
80103da3:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103da8:	89 43 14             	mov    %eax,0x14(%ebx)
80103dab:	90                   	nop
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(p->state == -ZOMBIE);
80103db0:	8b 53 0c             	mov    0xc(%ebx),%edx
80103db3:	83 fa fb             	cmp    $0xfffffffb,%edx
80103db6:	74 f8                	je     80103db0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103db8:	8b 53 0c             	mov    0xc(%ebx),%edx
80103dbb:	83 fa 05             	cmp    $0x5,%edx
80103dbe:	75 d0                	jne    80103d90 <exit+0xa0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc0:	81 c3 90 01 00 00    	add    $0x190,%ebx
        wakeup1(initproc);
80103dc6:	e8 75 f8 ff ff       	call   80103640 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dcb:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
80103dd1:	72 cb                	jb     80103d9e <exit+0xae>
80103dd3:	90                   	nop
80103dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  sched();
80103dd8:	e8 73 fe ff ff       	call   80103c50 <sched>
  panic("zombie exit");
80103ddd:	83 ec 0c             	sub    $0xc,%esp
80103de0:	68 88 7d 10 80       	push   $0x80107d88
80103de5:	e8 a6 c5 ff ff       	call   80100390 <panic>
    cprintf("exit cas err %d\n",curproc->state);
80103dea:	8b 46 0c             	mov    0xc(%esi),%eax
80103ded:	52                   	push   %edx
80103dee:	52                   	push   %edx
80103def:	50                   	push   %eax
80103df0:	68 77 7d 10 80       	push   $0x80107d77
80103df5:	e8 66 c8 ff ff       	call   80100660 <cprintf>
80103dfa:	83 c4 10             	add    $0x10,%esp
80103dfd:	e9 7c ff ff ff       	jmp    80103d7e <exit+0x8e>
    panic("init exiting");
80103e02:	83 ec 0c             	sub    $0xc,%esp
80103e05:	68 6a 7d 10 80       	push   $0x80107d6a
80103e0a:	e8 81 c5 ff ff       	call   80100390 <panic>
80103e0f:	90                   	nop

80103e10 <wait>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	57                   	push   %edi
80103e14:	56                   	push   %esi
80103e15:	53                   	push   %ebx
80103e16:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103e19:	e8 22 0c 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103e1e:	e8 2d f9 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103e23:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103e29:	e8 52 0c 00 00       	call   80104a80 <popcli>
  pushcli();
80103e2e:	e8 0d 0c 00 00       	call   80104a40 <pushcli>
80103e33:	8d 47 0c             	lea    0xc(%edi),%eax
80103e36:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103e39:	b8 04 00 00 00       	mov    $0x4,%eax
80103e3e:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
80103e43:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103e46:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103e4a:	9c                   	pushf  
80103e4b:	8f 45 e4             	popl   -0x1c(%ebp)
    if(!cas(&curproc->state,RUNNING,-SLEEPING)){
80103e4e:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103e52:	0f 84 0c 01 00 00    	je     80103f64 <wait+0x154>
    curproc->chan = curproc;
80103e58:	89 7f 20             	mov    %edi,0x20(%edi)
    havekids = 0;
80103e5b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5d:	be 54 3d 11 80       	mov    $0x80113d54,%esi
80103e62:	b9 06 00 00 00       	mov    $0x6,%ecx
80103e67:	eb 15                	jmp    80103e7e <wait+0x6e>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e70:	81 c6 90 01 00 00    	add    $0x190,%esi
80103e76:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
80103e7c:	73 3d                	jae    80103ebb <wait+0xab>
      if(p->parent != curproc)
80103e7e:	39 7e 14             	cmp    %edi,0x14(%esi)
80103e81:	75 ed                	jne    80103e70 <wait+0x60>
80103e83:	90                   	nop
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(p->state == -ZOMBIE);
80103e88:	8b 46 0c             	mov    0xc(%esi),%eax
80103e8b:	83 f8 fb             	cmp    $0xfffffffb,%eax
80103e8e:	74 f8                	je     80103e88 <wait+0x78>
80103e90:	8d 56 0c             	lea    0xc(%esi),%edx
80103e93:	b8 05 00 00 00       	mov    $0x5,%eax
80103e98:	89 d3                	mov    %edx,%ebx
80103e9a:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103e9e:	9c                   	pushf  
80103e9f:	8f 45 e4             	popl   -0x1c(%ebp)
      if(cas(&p->state ,ZOMBIE, PRE_UNUSED)){
80103ea2:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103ea6:	75 38                	jne    80103ee0 <wait+0xd0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ea8:	81 c6 90 01 00 00    	add    $0x190,%esi
      havekids = 1;
80103eae:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb3:	81 fe 54 a1 11 80    	cmp    $0x8011a154,%esi
80103eb9:	72 c3                	jb     80103e7e <wait+0x6e>
    if(!havekids || curproc->killed){
80103ebb:	85 c0                	test   %eax,%eax
80103ebd:	0f 84 b6 00 00 00    	je     80103f79 <wait+0x169>
80103ec3:	8b 47 24             	mov    0x24(%edi),%eax
80103ec6:	85 c0                	test   %eax,%eax
80103ec8:	0f 85 ab 00 00 00    	jne    80103f79 <wait+0x169>
    sched();
80103ece:	e8 7d fd ff ff       	call   80103c50 <sched>
    if(!cas(&curproc->state,RUNNING,-SLEEPING)){
80103ed3:	e9 61 ff ff ff       	jmp    80103e39 <wait+0x29>
80103ed8:	90                   	nop
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103ee0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80103ee3:	8b 7e 10             	mov    0x10(%esi),%edi
        kfree(p->kstack);
80103ee6:	ff 76 08             	pushl  0x8(%esi)
80103ee9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
80103eec:	89 55 d0             	mov    %edx,-0x30(%ebp)
80103eef:	e8 5c e4 ff ff       	call   80102350 <kfree>
        p->kstack = 0;
80103ef4:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80103efb:	5a                   	pop    %edx
80103efc:	ff 76 04             	pushl  0x4(%esi)
80103eff:	e8 4c 35 00 00       	call   80107450 <freevm>
        p->pid = 0;
80103f04:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
80103f0b:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
80103f12:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
        p->name[0] = 0;
80103f17:	c6 46 70 00          	movb   $0x0,0x70(%esi)
        p->killed = 0;
80103f1b:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
80103f22:	be 04 00 00 00       	mov    $0x4,%esi
80103f27:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103f2a:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103f2e:	9c                   	pushf  
80103f2f:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&curproc->state,-SLEEPING,RUNNING)){
80103f32:	83 c4 10             	add    $0x10,%esp
80103f35:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103f39:	8b 55 d0             	mov    -0x30(%ebp),%edx
80103f3c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
80103f3f:	74 73                	je     80103fb4 <wait+0x1a4>
80103f41:	31 f6                	xor    %esi,%esi
80103f43:	89 c8                	mov    %ecx,%eax
80103f45:	89 d3                	mov    %edx,%ebx
80103f47:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103f4b:	9c                   	pushf  
80103f4c:	8f 45 e4             	popl   -0x1c(%ebp)
        if(!cas(&p->state,PRE_UNUSED,UNUSED)){
80103f4f:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103f53:	74 5f                	je     80103fb4 <wait+0x1a4>
        popcli();
80103f55:	e8 26 0b 00 00       	call   80104a80 <popcli>
}
80103f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f5d:	89 f8                	mov    %edi,%eax
80103f5f:	5b                   	pop    %ebx
80103f60:	5e                   	pop    %esi
80103f61:	5f                   	pop    %edi
80103f62:	5d                   	pop    %ebp
80103f63:	c3                   	ret    
      cprintf("wait cas err1\n");
80103f64:	83 ec 0c             	sub    $0xc,%esp
80103f67:	68 94 7d 10 80       	push   $0x80107d94
80103f6c:	e8 ef c6 ff ff       	call   80100660 <cprintf>
80103f71:	83 c4 10             	add    $0x10,%esp
80103f74:	e9 df fe ff ff       	jmp    80103e58 <wait+0x48>
80103f79:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103f7e:	ba 04 00 00 00       	mov    $0x4,%edx
80103f83:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103f86:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103f8a:	9c                   	pushf  
80103f8b:	8f 45 e4             	popl   -0x1c(%ebp)
      if(!cas(&curproc->state,-SLEEPING,RUNNING)){
80103f8e:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
80103f92:	74 13                	je     80103fa7 <wait+0x197>
      curproc->chan = 0;
80103f94:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
      return -1;
80103f9b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      popcli();
80103fa0:	e8 db 0a 00 00       	call   80104a80 <popcli>
      return -1;
80103fa5:	eb b3                	jmp    80103f5a <wait+0x14a>
        panic("wait cas err\n");
80103fa7:	83 ec 0c             	sub    $0xc,%esp
80103faa:	68 ad 7d 10 80       	push   $0x80107dad
80103faf:	e8 dc c3 ff ff       	call   80100390 <panic>
          panic("wait cas\n");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 a3 7d 10 80       	push   $0x80107da3
80103fbc:	e8 cf c3 ff ff       	call   80100390 <panic>
80103fc1:	eb 0d                	jmp    80103fd0 <yield>
80103fc3:	90                   	nop
80103fc4:	90                   	nop
80103fc5:	90                   	nop
80103fc6:	90                   	nop
80103fc7:	90                   	nop
80103fc8:	90                   	nop
80103fc9:	90                   	nop
80103fca:	90                   	nop
80103fcb:	90                   	nop
80103fcc:	90                   	nop
80103fcd:	90                   	nop
80103fce:	90                   	nop
80103fcf:	90                   	nop

80103fd0 <yield>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	53                   	push   %ebx
80103fd4:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80103fd7:	e8 64 0a 00 00       	call   80104a40 <pushcli>
  pushcli();
80103fdc:	e8 5f 0a 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80103fe1:	e8 6a f7 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80103fe6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fec:	e8 8f 0a 00 00       	call   80104a80 <popcli>
80103ff1:	b8 04 00 00 00       	mov    $0x4,%eax
80103ff6:	ba fd ff ff ff       	mov    $0xfffffffd,%edx
  if(!cas(&myproc()->state,RUNNING, -RUNNABLE)){
80103ffb:	83 c3 0c             	add    $0xc,%ebx
80103ffe:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104002:	9c                   	pushf  
80104003:	8f 45 f4             	popl   -0xc(%ebp)
80104006:	f6 45 f4 40          	testb  $0x40,-0xc(%ebp)
8010400a:	74 0f                	je     8010401b <yield+0x4b>
  sched();
8010400c:	e8 3f fc ff ff       	call   80103c50 <sched>
  popcli();
80104011:	e8 6a 0a 00 00       	call   80104a80 <popcli>
}
80104016:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104019:	c9                   	leave  
8010401a:	c3                   	ret    
    panic("yeild cas");
8010401b:	83 ec 0c             	sub    $0xc,%esp
8010401e:	68 bb 7d 10 80       	push   $0x80107dbb
80104023:	e8 68 c3 ff ff       	call   80100390 <panic>
80104028:	90                   	nop
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104030 <sleep>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
80104034:	56                   	push   %esi
80104035:	53                   	push   %ebx
80104036:	83 ec 1c             	sub    $0x1c,%esp
80104039:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pushcli();
8010403c:	e8 ff 09 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104041:	e8 0a f7 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104046:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010404c:	e8 2f 0a 00 00       	call   80104a80 <popcli>
  if(p == 0)
80104051:	85 f6                	test   %esi,%esi
80104053:	0f 84 9b 00 00 00    	je     801040f4 <sleep+0xc4>
  if(lk == 0)
80104059:	85 ff                	test   %edi,%edi
8010405b:	0f 84 86 00 00 00    	je     801040e7 <sleep+0xb7>
  if(!cas(&p->state,RUNNING,-SLEEPING)){
80104061:	8d 5e 0c             	lea    0xc(%esi),%ebx
80104064:	b8 04 00 00 00       	mov    $0x4,%eax
80104069:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
8010406e:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104072:	9c                   	pushf  
80104073:	8f 45 e4             	popl   -0x1c(%ebp)
80104076:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
8010407a:	74 5e                	je     801040da <sleep+0xaa>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010407c:	81 ff 20 3d 11 80    	cmp    $0x80113d20,%edi
80104082:	74 3c                	je     801040c0 <sleep+0x90>
    pushcli();
80104084:	e8 b7 09 00 00       	call   80104a40 <pushcli>
    release(lk);
80104089:	83 ec 0c             	sub    $0xc,%esp
8010408c:	57                   	push   %edi
8010408d:	e8 3e 0b 00 00       	call   80104bd0 <release>
  p->chan = chan;
80104092:	8b 45 08             	mov    0x8(%ebp),%eax
80104095:	89 46 20             	mov    %eax,0x20(%esi)
  sched();
80104098:	e8 b3 fb ff ff       	call   80103c50 <sched>
  p->chan = 0;
8010409d:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
    popcli();
801040a4:	e8 d7 09 00 00       	call   80104a80 <popcli>
    acquire(lk);
801040a9:	89 3c 24             	mov    %edi,(%esp)
801040ac:	e8 5f 0a 00 00       	call   80104b10 <acquire>
801040b1:	83 c4 10             	add    $0x10,%esp
}
801040b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040b7:	5b                   	pop    %ebx
801040b8:	5e                   	pop    %esi
801040b9:	5f                   	pop    %edi
801040ba:	5d                   	pop    %ebp
801040bb:	c3                   	ret    
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801040c0:	8b 45 08             	mov    0x8(%ebp),%eax
801040c3:	89 46 20             	mov    %eax,0x20(%esi)
  sched();
801040c6:	e8 85 fb ff ff       	call   80103c50 <sched>
  p->chan = 0;
801040cb:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
}
801040d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040d5:	5b                   	pop    %ebx
801040d6:	5e                   	pop    %esi
801040d7:	5f                   	pop    %edi
801040d8:	5d                   	pop    %ebp
801040d9:	c3                   	ret    
    panic("sleep cas");
801040da:	83 ec 0c             	sub    $0xc,%esp
801040dd:	68 dc 7d 10 80       	push   $0x80107ddc
801040e2:	e8 a9 c2 ff ff       	call   80100390 <panic>
    panic("sleep without lk");
801040e7:	83 ec 0c             	sub    $0xc,%esp
801040ea:	68 cb 7d 10 80       	push   $0x80107dcb
801040ef:	e8 9c c2 ff ff       	call   80100390 <panic>
    panic("sleep");
801040f4:	83 ec 0c             	sub    $0xc,%esp
801040f7:	68 c5 7d 10 80       	push   $0x80107dc5
801040fc:	e8 8f c2 ff ff       	call   80100390 <panic>
80104101:	eb 0d                	jmp    80104110 <wakeup>
80104103:	90                   	nop
80104104:	90                   	nop
80104105:	90                   	nop
80104106:	90                   	nop
80104107:	90                   	nop
80104108:	90                   	nop
80104109:	90                   	nop
8010410a:	90                   	nop
8010410b:	90                   	nop
8010410c:	90                   	nop
8010410d:	90                   	nop
8010410e:	90                   	nop
8010410f:	90                   	nop

80104110 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 04             	sub    $0x4,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010411a:	e8 21 09 00 00       	call   80104a40 <pushcli>
  wakeup1(chan);
8010411f:	89 d8                	mov    %ebx,%eax
80104121:	e8 1a f5 ff ff       	call   80103640 <wakeup1>
  popcli();
}
80104126:	83 c4 04             	add    $0x4,%esp
80104129:	5b                   	pop    %ebx
8010412a:	5d                   	pop    %ebp
  popcli();
8010412b:	e9 50 09 00 00       	jmp    80104a80 <popcli>

80104130 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid, int signum)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	83 ec 10             	sub    $0x10,%esp
80104138:	8b 75 0c             	mov    0xc(%ebp),%esi
8010413b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  if(signum<0||signum>=32){
8010413e:	83 fe 1f             	cmp    $0x1f,%esi
80104141:	0f 87 ba 00 00 00    	ja     80104201 <kill+0xd1>
    return -1;
  }

  // updating proc for new signal
  //acquire(&ptable.lock);
  pushcli();
80104147:	e8 f4 08 00 00       	call   80104a40 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010414c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104151:	eb 15                	jmp    80104168 <kill+0x38>
80104153:	90                   	nop
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104158:	05 90 01 00 00       	add    $0x190,%eax
8010415d:	3d 54 a1 11 80       	cmp    $0x8011a154,%eax
80104162:	0f 83 88 00 00 00    	jae    801041f0 <kill+0xc0>
    if(p->pid == pid && p->state !=UNUSED){
80104168:	39 58 10             	cmp    %ebx,0x10(%eax)
8010416b:	75 eb                	jne    80104158 <kill+0x28>
8010416d:	8b 50 0c             	mov    0xc(%eax),%edx
80104170:	85 d2                	test   %edx,%edx
80104172:	74 e4                	je     80104158 <kill+0x28>
      if(p->signalHandler[signum]==(void*)SIG_IGN){
80104174:	8b 9c b0 0c 01 00 00 	mov    0x10c(%eax,%esi,4),%ebx
8010417b:	83 fb 01             	cmp    $0x1,%ebx
8010417e:	74 1f                	je     8010419f <kill+0x6f>
        popcli();
        return 0;
      }
      p->pendingSignals |= (1 << signum);
80104180:	89 f1                	mov    %esi,%ecx
80104182:	ba 01 00 00 00       	mov    $0x1,%edx
80104187:	d3 e2                	shl    %cl,%edx

      if((p->state == SLEEPING) || (p->state == -SLEEPING)){
80104189:	8b 48 0c             	mov    0xc(%eax),%ecx
      p->pendingSignals |= (1 << signum);
8010418c:	09 90 80 00 00 00    	or     %edx,0x80(%eax)
      if((p->state == SLEEPING) || (p->state == -SLEEPING)){
80104192:	83 f9 02             	cmp    $0x2,%ecx
80104195:	74 19                	je     801041b0 <kill+0x80>
80104197:	8b 48 0c             	mov    0xc(%eax),%ecx
8010419a:	83 f9 fe             	cmp    $0xfffffffe,%ecx
8010419d:	74 11                	je     801041b0 <kill+0x80>
        popcli();
8010419f:	e8 dc 08 00 00       	call   80104a80 <popcli>
        return 0;
801041a4:	31 c0                	xor    %eax,%eax
      return 0;
    }
  }
  popcli();
  return -1;
}
801041a6:	83 c4 10             	add    $0x10,%esp
801041a9:	5b                   	pop    %ebx
801041aa:	5e                   	pop    %esi
801041ab:	5d                   	pop    %ebp
801041ac:	c3                   	ret    
801041ad:	8d 76 00             	lea    0x0(%esi),%esi
        if((signum == SIGKILL) ||
801041b0:	83 fe 09             	cmp    $0x9,%esi
801041b3:	74 1b                	je     801041d0 <kill+0xa0>
801041b5:	85 90 84 00 00 00    	test   %edx,0x84(%eax)
801041bb:	75 e2                	jne    8010419f <kill+0x6f>
        (((p->signalMask & (1 << signum)) == 0) && (p->signalHandler[signum]== (void*)SIGKILL || p->signalHandler[signum]== (void*)SIG_DFL))){
801041bd:	83 fb 09             	cmp    $0x9,%ebx
801041c0:	74 0e                	je     801041d0 <kill+0xa0>
801041c2:	85 db                	test   %ebx,%ebx
801041c4:	75 d9                	jne    8010419f <kill+0x6f>
801041c6:	8d 76 00             	lea    0x0(%esi),%esi
801041c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          while(p->state == -SLEEPING);
801041d0:	8b 50 0c             	mov    0xc(%eax),%edx
801041d3:	83 fa fe             	cmp    $0xfffffffe,%edx
801041d6:	74 f8                	je     801041d0 <kill+0xa0>
          cas(&p->state, SLEEPING, RUNNABLE);
801041d8:	8d 58 0c             	lea    0xc(%eax),%ebx
801041db:	ba 03 00 00 00       	mov    $0x3,%edx
801041e0:	b8 02 00 00 00       	mov    $0x2,%eax
801041e5:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801041e9:	9c                   	pushf  
801041ea:	8f 45 f4             	popl   -0xc(%ebp)
801041ed:	eb b0                	jmp    8010419f <kill+0x6f>
801041ef:	90                   	nop
  popcli();
801041f0:	e8 8b 08 00 00       	call   80104a80 <popcli>
}
801041f5:	83 c4 10             	add    $0x10,%esp
  return -1;
801041f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041fd:	5b                   	pop    %ebx
801041fe:	5e                   	pop    %esi
801041ff:	5d                   	pop    %ebp
80104200:	c3                   	ret    
    return -1;
80104201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104206:	eb 9e                	jmp    801041a6 <kill+0x76>
80104208:	90                   	nop
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104210 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104216:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010421b:	83 ec 3c             	sub    $0x3c,%esp
8010421e:	eb 22                	jmp    80104242 <procdump+0x32>
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104220:	83 ec 0c             	sub    $0xc,%esp
80104223:	68 63 81 10 80       	push   $0x80108163
80104228:	e8 33 c4 ff ff       	call   80100660 <cprintf>
8010422d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104230:	81 c3 90 01 00 00    	add    $0x190,%ebx
80104236:	81 fb 54 a1 11 80    	cmp    $0x8011a154,%ebx
8010423c:	0f 83 9e 00 00 00    	jae    801042e0 <procdump+0xd0>
    if(p->state == UNUSED)
80104242:	8b 43 0c             	mov    0xc(%ebx),%eax
80104245:	85 c0                	test   %eax,%eax
80104247:	74 e7                	je     80104230 <procdump+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104249:	8b 43 0c             	mov    0xc(%ebx),%eax
8010424c:	8b 53 0c             	mov    0xc(%ebx),%edx
      state = "???";
8010424f:	b8 e6 7d 10 80       	mov    $0x80107de6,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104254:	83 fa 05             	cmp    $0x5,%edx
80104257:	77 18                	ja     80104271 <procdump+0x61>
80104259:	8b 53 0c             	mov    0xc(%ebx),%edx
8010425c:	8b 14 95 48 7e 10 80 	mov    -0x7fef81b8(,%edx,4),%edx
80104263:	85 d2                	test   %edx,%edx
80104265:	74 0a                	je     80104271 <procdump+0x61>
      state = states[p->state];
80104267:	8b 43 0c             	mov    0xc(%ebx),%eax
8010426a:	8b 04 85 48 7e 10 80 	mov    -0x7fef81b8(,%eax,4),%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80104271:	8d 53 70             	lea    0x70(%ebx),%edx
80104274:	52                   	push   %edx
80104275:	50                   	push   %eax
80104276:	ff 73 10             	pushl  0x10(%ebx)
80104279:	68 ea 7d 10 80       	push   $0x80107dea
8010427e:	e8 dd c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104283:	8b 43 0c             	mov    0xc(%ebx),%eax
80104286:	83 c4 10             	add    $0x10,%esp
80104289:	83 f8 02             	cmp    $0x2,%eax
8010428c:	75 92                	jne    80104220 <procdump+0x10>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010428e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104291:	83 ec 08             	sub    $0x8,%esp
80104294:	8d 75 c0             	lea    -0x40(%ebp),%esi
80104297:	8d 7d e8             	lea    -0x18(%ebp),%edi
8010429a:	50                   	push   %eax
8010429b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010429e:	8b 40 0c             	mov    0xc(%eax),%eax
801042a1:	83 c0 08             	add    $0x8,%eax
801042a4:	50                   	push   %eax
801042a5:	e8 46 07 00 00       	call   801049f0 <getcallerpcs>
801042aa:	83 c4 10             	add    $0x10,%esp
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801042b0:	8b 16                	mov    (%esi),%edx
801042b2:	85 d2                	test   %edx,%edx
801042b4:	0f 84 66 ff ff ff    	je     80104220 <procdump+0x10>
        cprintf(" %p", pc[i]);
801042ba:	83 ec 08             	sub    $0x8,%esp
801042bd:	83 c6 04             	add    $0x4,%esi
801042c0:	52                   	push   %edx
801042c1:	68 c1 77 10 80       	push   $0x801077c1
801042c6:	e8 95 c3 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042cb:	83 c4 10             	add    $0x10,%esp
801042ce:	39 f7                	cmp    %esi,%edi
801042d0:	75 de                	jne    801042b0 <procdump+0xa0>
801042d2:	e9 49 ff ff ff       	jmp    80104220 <procdump+0x10>
801042d7:	89 f6                	mov    %esi,%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
801042e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042e3:	5b                   	pop    %ebx
801042e4:	5e                   	pop    %esi
801042e5:	5f                   	pop    %edi
801042e6:	5d                   	pop    %ebp
801042e7:	c3                   	ret    
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <sigprocmask>:

uint 
sigprocmask(uint sigmask){
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	56                   	push   %esi
801042f4:	53                   	push   %ebx
  pushcli();
801042f5:	e8 46 07 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801042fa:	e8 51 f4 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801042ff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104305:	e8 76 07 00 00       	call   80104a80 <popcli>
  uint oldMask = myproc()->signalMask;
8010430a:	8b 9b 84 00 00 00    	mov    0x84(%ebx),%ebx
  pushcli();
80104310:	e8 2b 07 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104315:	e8 36 f4 ff ff       	call   80103750 <mycpu>
  p = c->proc;
8010431a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104320:	e8 5b 07 00 00       	call   80104a80 <popcli>
  myproc()->signalMask = sigmask;
80104325:	8b 45 08             	mov    0x8(%ebp),%eax
80104328:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
  return oldMask;
}
8010432e:	89 d8                	mov    %ebx,%eax
80104330:	5b                   	pop    %ebx
80104331:	5e                   	pop    %esi
80104332:	5d                   	pop    %ebp
80104333:	c3                   	ret    
80104334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010433a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104340 <sigaction>:

int
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact){
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010434c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010434f:	e8 ec 06 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104354:	e8 f7 f3 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104359:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010435f:	e8 1c 07 00 00       	call   80104a80 <popcli>
  struct proc *p;
  p=myproc();
  if(oldact!=null){ 
80104364:	85 db                	test   %ebx,%ebx
80104366:	74 17                	je     8010437f <sigaction+0x3f>
80104368:	8b 45 08             	mov    0x8(%ebp),%eax
8010436b:	8d 14 87             	lea    (%edi,%eax,4),%edx
    oldact->sa_handler = p->signalHandler[signum];
8010436e:	8b 8a 0c 01 00 00    	mov    0x10c(%edx),%ecx
80104374:	89 0b                	mov    %ecx,(%ebx)
    oldact->sigmask = p->signalHandlerMasks[signum];
80104376:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
8010437c:	89 53 04             	mov    %edx,0x4(%ebx)
8010437f:	8b 45 08             	mov    0x8(%ebp),%eax
  } 

  p->signalHandler[signum] = act->sa_handler;
80104382:	8b 16                	mov    (%esi),%edx
80104384:	8d 04 87             	lea    (%edi,%eax,4),%eax
80104387:	89 90 0c 01 00 00    	mov    %edx,0x10c(%eax)
  p->signalHandlerMasks[signum] = act->sigmask;
8010438d:	8b 56 04             	mov    0x4(%esi),%edx
80104390:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)

  return 0;
}
80104396:	83 c4 0c             	add    $0xc,%esp
80104399:	31 c0                	xor    %eax,%eax
8010439b:	5b                   	pop    %ebx
8010439c:	5e                   	pop    %esi
8010439d:	5f                   	pop    %edi
8010439e:	5d                   	pop    %ebp
8010439f:	c3                   	ret    

801043a0 <is_it_sigkill>:

/************************* SIGNAL HANDLERS *************************/
int
is_it_sigkill(struct proc *p, int signum){
801043a0:	55                   	push   %ebp
  if(signum == SIGKILL){
    return 1;
801043a1:	b8 01 00 00 00       	mov    $0x1,%eax
is_it_sigkill(struct proc *p, int signum){
801043a6:	89 e5                	mov    %esp,%ebp
801043a8:	83 ec 08             	sub    $0x8,%esp
801043ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801043ae:	8b 55 08             	mov    0x8(%ebp),%edx
  if(signum == SIGKILL){
801043b1:	83 f9 09             	cmp    $0x9,%ecx
801043b4:	74 2c                	je     801043e2 <is_it_sigkill+0x42>
  }
  if((p->signalMask & (1 << signum)) == 0){
801043b6:	d3 e0                	shl    %cl,%eax
801043b8:	85 82 84 00 00 00    	test   %eax,0x84(%edx)
801043be:	75 10                	jne    801043d0 <is_it_sigkill+0x30>
    if(p->signalHandler[signum]== (void*)SIGKILL || p->signalHandler[signum]== (void*)SIG_DFL){
801043c0:	8b 84 8a 0c 01 00 00 	mov    0x10c(%edx,%ecx,4),%eax
801043c7:	83 f8 09             	cmp    $0x9,%eax
801043ca:	74 1c                	je     801043e8 <is_it_sigkill+0x48>
801043cc:	85 c0                	test   %eax,%eax
801043ce:	74 18                	je     801043e8 <is_it_sigkill+0x48>
      return 1;
    }
  }
  cprintf("no");
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 63 79 10 80       	push   $0x80107963
801043d8:	e8 83 c2 ff ff       	call   80100660 <cprintf>
  return 0;
801043dd:	83 c4 10             	add    $0x10,%esp
801043e0:	31 c0                	xor    %eax,%eax
}
801043e2:	c9                   	leave  
801043e3:	c3                   	ret    
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 1;
801043e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801043ed:	c9                   	leave  
801043ee:	c3                   	ret    
801043ef:	90                   	nop

801043f0 <check_cont_sig>:
int
check_cont_sig(struct proc *p){
801043f0:	55                   	push   %ebp
801043f1:	31 c9                	xor    %ecx,%ecx
801043f3:	89 e5                	mov    %esp,%ebp
801043f5:	57                   	push   %edi
801043f6:	56                   	push   %esi
801043f7:	8b 45 08             	mov    0x8(%ebp),%eax
801043fa:	53                   	push   %ebx
801043fb:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
80104401:	b8 01 00 00 00       	mov    $0x1,%eax
80104406:	eb 0e                	jmp    80104416 <check_cont_sig+0x26>
80104408:	90                   	nop
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104410:	83 c1 01             	add    $0x1,%ecx
80104413:	83 c0 01             	add    $0x1,%eax
80104416:	ba 01 00 00 00       	mov    $0x1,%edx
8010441b:	89 df                	mov    %ebx,%edi
8010441d:	d3 e2                	shl    %cl,%edx
8010441f:	21 d7                	and    %edx,%edi
  int def ;
  for(int i = 0 ; i < 32; i++){
     def = ((i == SIGCONT) && (p->signalHandler[i] == (void*)SIG_DFL));
80104421:	83 f9 13             	cmp    $0x13,%ecx
80104424:	74 2a                	je     80104450 <check_cont_sig+0x60>
    if(((p->pendingSignals & (1 << i)) != 0) && ((p->signalMask & (1 << i)) == 0) && ((p->signalHandler[i] == (void*)SIGCONT) || def)){
80104426:	85 ff                	test   %edi,%edi
80104428:	74 15                	je     8010443f <check_cont_sig+0x4f>
8010442a:	8b 7d 08             	mov    0x8(%ebp),%edi
8010442d:	85 97 84 00 00 00    	test   %edx,0x84(%edi)
80104433:	75 0a                	jne    8010443f <check_cont_sig+0x4f>
80104435:	83 bc 8f 0c 01 00 00 	cmpl   $0x13,0x10c(%edi,%ecx,4)
8010443c:	13 
8010443d:	74 2d                	je     8010446c <check_cont_sig+0x7c>
  for(int i = 0 ; i < 32; i++){
8010443f:	83 f8 20             	cmp    $0x20,%eax
80104442:	75 cc                	jne    80104410 <check_cont_sig+0x20>
      p->pendingSignals = p->pendingSignals ^ (1 << i);
      return 1;
    }
  }
  return 0;
}
80104444:	5b                   	pop    %ebx
  return 0;
80104445:	31 c0                	xor    %eax,%eax
}
80104447:	5e                   	pop    %esi
80104448:	5f                   	pop    %edi
80104449:	5d                   	pop    %ebp
8010444a:	c3                   	ret    
8010444b:	90                   	nop
8010444c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     def = ((i == SIGCONT) && (p->signalHandler[i] == (void*)SIG_DFL));
80104450:	8b 75 08             	mov    0x8(%ebp),%esi
80104453:	8b b6 58 01 00 00    	mov    0x158(%esi),%esi
80104459:	85 f6                	test   %esi,%esi
8010445b:	75 c9                	jne    80104426 <check_cont_sig+0x36>
    if(((p->pendingSignals & (1 << i)) != 0) && ((p->signalMask & (1 << i)) == 0) && ((p->signalHandler[i] == (void*)SIGCONT) || def)){
8010445d:	85 ff                	test   %edi,%edi
8010445f:	74 af                	je     80104410 <check_cont_sig+0x20>
80104461:	8b 75 08             	mov    0x8(%ebp),%esi
80104464:	85 96 84 00 00 00    	test   %edx,0x84(%esi)
8010446a:	75 d3                	jne    8010443f <check_cont_sig+0x4f>
      p->pendingSignals = p->pendingSignals ^ (1 << i);
8010446c:	8b 45 08             	mov    0x8(%ebp),%eax
8010446f:	31 da                	xor    %ebx,%edx
80104471:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
      return 1;
80104477:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5f                   	pop    %edi
8010447f:	5d                   	pop    %ebp
80104480:	c3                   	ret    
80104481:	eb 0d                	jmp    80104490 <scheduler>
80104483:	90                   	nop
80104484:	90                   	nop
80104485:	90                   	nop
80104486:	90                   	nop
80104487:	90                   	nop
80104488:	90                   	nop
80104489:	90                   	nop
8010448a:	90                   	nop
8010448b:	90                   	nop
8010448c:	90                   	nop
8010448d:	90                   	nop
8010448e:	90                   	nop
8010448f:	90                   	nop

80104490 <scheduler>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80104499:	e8 b2 f2 ff ff       	call   80103750 <mycpu>
  c->proc = 0;
8010449e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801044a5:	00 00 00 
  struct cpu *c = mycpu();
801044a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801044ab:	83 c0 04             	add    $0x4,%eax
801044ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
801044b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801044b8:	fb                   	sti    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b9:	bf 54 3d 11 80       	mov    $0x80113d54,%edi
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801044be:	be fc ff ff ff       	mov    $0xfffffffc,%esi
    pushcli();
801044c3:	e8 78 05 00 00       	call   80104a40 <pushcli>
801044c8:	e9 a0 00 00 00       	jmp    8010456d <scheduler+0xdd>
801044cd:	8d 76 00             	lea    0x0(%esi),%esi
801044d0:	8d 5f 0c             	lea    0xc(%edi),%ebx
801044d3:	b8 03 00 00 00       	mov    $0x3,%eax
801044d8:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
801044dc:	9c                   	pushf  
801044dd:	8f 45 e4             	popl   -0x1c(%ebp)
      if(!cas(&p->state, RUNNABLE, -RUNNING))
801044e0:	f6 45 e4 40          	testb  $0x40,-0x1c(%ebp)
801044e4:	74 79                	je     8010455f <scheduler+0xcf>
      c->proc = p;
801044e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      switchuvm(p);
801044e9:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801044ec:	89 ba ac 00 00 00    	mov    %edi,0xac(%edx)
      switchuvm(p);
801044f2:	57                   	push   %edi
801044f3:	e8 a8 2b 00 00       	call   801070a0 <switchuvm>
801044f8:	b9 04 00 00 00       	mov    $0x4,%ecx
801044fd:	89 f0                	mov    %esi,%eax
801044ff:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104503:	9c                   	pushf  
80104504:	8f 45 e4             	popl   -0x1c(%ebp)
      swtch(&(c->scheduler), p->context);
80104507:	58                   	pop    %eax
80104508:	5a                   	pop    %edx
80104509:	ff 77 1c             	pushl  0x1c(%edi)
8010450c:	ff 75 d0             	pushl  -0x30(%ebp)
8010450f:	e8 47 09 00 00       	call   80104e5b <swtch>
      switchkvm();
80104514:	e8 67 2b 00 00       	call   80107080 <switchkvm>
      c->proc = 0;
80104519:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010451c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104521:	c7 82 ac 00 00 00 00 	movl   $0x0,0xac(%edx)
80104528:	00 00 00 
8010452b:	ba 03 00 00 00       	mov    $0x3,%edx
80104530:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104534:	9c                   	pushf  
80104535:	8f 45 e4             	popl   -0x1c(%ebp)
80104538:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
8010453d:	b9 02 00 00 00       	mov    $0x2,%ecx
80104542:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104546:	9c                   	pushf  
80104547:	8f 45 e4             	popl   -0x1c(%ebp)
8010454a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
8010454f:	b9 05 00 00 00       	mov    $0x5,%ecx
80104554:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80104558:	9c                   	pushf  
80104559:	8f 45 e4             	popl   -0x1c(%ebp)
8010455c:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010455f:	81 c7 90 01 00 00    	add    $0x190,%edi
80104565:	81 ff 54 a1 11 80    	cmp    $0x8011a154,%edi
8010456b:	73 2b                	jae    80104598 <scheduler+0x108>
      if(p->frozen){
8010456d:	8b 4f 28             	mov    0x28(%edi),%ecx
80104570:	85 c9                	test   %ecx,%ecx
80104572:	0f 84 58 ff ff ff    	je     801044d0 <scheduler+0x40>
        if(check_cont_sig(p)){
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	57                   	push   %edi
8010457c:	e8 6f fe ff ff       	call   801043f0 <check_cont_sig>
80104581:	83 c4 10             	add    $0x10,%esp
80104584:	85 c0                	test   %eax,%eax
80104586:	74 d7                	je     8010455f <scheduler+0xcf>
          p->frozen = 0;
80104588:	c7 47 28 00 00 00 00 	movl   $0x0,0x28(%edi)
8010458f:	e9 3c ff ff ff       	jmp    801044d0 <scheduler+0x40>
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    popcli();
80104598:	e8 e3 04 00 00       	call   80104a80 <popcli>
    sti();
8010459d:	e9 16 ff ff ff       	jmp    801044b8 <scheduler+0x28>
801045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <sh_sigkill>:

void 
sh_sigkill(){
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801045b7:	e8 84 04 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801045bc:	e8 8f f1 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801045c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045c7:	e8 b4 04 00 00       	call   80104a80 <popcli>
  myproc()->killed = 1;
801045cc:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
801045d3:	83 c4 04             	add    $0x4,%esp
801045d6:	5b                   	pop    %ebx
801045d7:	5d                   	pop    %ebp
801045d8:	c3                   	ret    
801045d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045e0 <sh_sigstop>:

void
sh_sigstop(){
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801045e7:	e8 54 04 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801045ec:	e8 5f f1 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801045f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045f7:	e8 84 04 00 00       	call   80104a80 <popcli>
  myproc()->frozen = 1;
801045fc:	c7 43 28 01 00 00 00 	movl   $0x1,0x28(%ebx)
  yield();
}
80104603:	83 c4 04             	add    $0x4,%esp
80104606:	5b                   	pop    %ebx
80104607:	5d                   	pop    %ebp
  yield();
80104608:	e9 c3 f9 ff ff       	jmp    80103fd0 <yield>
8010460d:	8d 76 00             	lea    0x0(%esi),%esi

80104610 <sh_sigcont>:

void
sh_sigcont(){
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104617:	e8 24 04 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010461c:	e8 2f f1 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104621:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104627:	e8 54 04 00 00       	call   80104a80 <popcli>
  myproc()->frozen = 0;
8010462c:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
}
80104633:	83 c4 04             	add    $0x4,%esp
80104636:	5b                   	pop    %ebx
80104637:	5d                   	pop    %ebp
80104638:	c3                   	ret    
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104640 <sigret>:

void 
sigret(){
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
  pushcli();
80104645:	e8 f6 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010464a:	e8 01 f1 ff ff       	call   80103750 <mycpu>
  p = c->proc;
8010464f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104655:	e8 26 04 00 00       	call   80104a80 <popcli>
  pushcli();
8010465a:	e8 e1 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010465f:	e8 ec f0 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104664:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010466a:	e8 11 04 00 00       	call   80104a80 <popcli>
  myproc()->signalMask=myproc()->signalMaskBU;
8010466f:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80104675:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  pushcli();
8010467b:	e8 c0 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
80104680:	e8 cb f0 ff ff       	call   80103750 <mycpu>
  p = c->proc;
80104685:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010468b:	e8 f0 03 00 00       	call   80104a80 <popcli>
  //memmove(&myproc()->signalMask, &myproc()->signalMaskBU, 4);
  memmove(myproc()->tf, myproc()->uTrapFrameBU, sizeof(struct trapframe));
80104690:	8b b3 8c 01 00 00    	mov    0x18c(%ebx),%esi
  pushcli();
80104696:	e8 a5 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
8010469b:	e8 b0 f0 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801046a0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a6:	e8 d5 03 00 00       	call   80104a80 <popcli>
  memmove(myproc()->tf, myproc()->uTrapFrameBU, sizeof(struct trapframe));
801046ab:	83 ec 04             	sub    $0x4,%esp
801046ae:	6a 4c                	push   $0x4c
801046b0:	56                   	push   %esi
801046b1:	ff 73 18             	pushl  0x18(%ebx)
801046b4:	e8 17 06 00 00       	call   80104cd0 <memmove>
}
801046b9:	83 c4 10             	add    $0x10,%esp
801046bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046bf:	5b                   	pop    %ebx
801046c0:	5e                   	pop    %esi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
801046c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <handle_signals>:

void
handle_signals(struct trapframe *tf){
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	53                   	push   %ebx
801046d6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801046d9:	e8 62 03 00 00       	call   80104a40 <pushcli>
  c = mycpu();
801046de:	e8 6d f0 ff ff       	call   80103750 <mycpu>
  p = c->proc;
801046e3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046e9:	e8 92 03 00 00       	call   80104a80 <popcli>
    struct proc* p = myproc();
    
    if(p == 0 || p == null){
801046ee:	85 f6                	test   %esi,%esi
801046f0:	74 10                	je     80104702 <handle_signals+0x32>
      return;
    }
    if((tf->cs &3) != DPL_USER)
801046f2:	8b 45 08             	mov    0x8(%ebp),%eax
801046f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801046f9:	83 e0 03             	and    $0x3,%eax
801046fc:	66 83 f8 03          	cmp    $0x3,%ax
80104700:	74 0e                	je     80104710 <handle_signals+0x40>
          return;

        }
      }
    }
80104702:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104705:	5b                   	pop    %ebx
80104706:	5e                   	pop    %esi
80104707:	5f                   	pop    %edi
80104708:	5d                   	pop    %ebp
80104709:	c3                   	ret    
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(p->killed){
80104710:	8b 5e 24             	mov    0x24(%esi),%ebx
80104713:	85 db                	test   %ebx,%ebx
80104715:	75 eb                	jne    80104702 <handle_signals+0x32>
    for(int i = 0 ; (p->pendingSignals != 0) && i < 32 ; i++){   
80104717:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010471d:	85 c0                	test   %eax,%eax
8010471f:	75 67                	jne    80104788 <handle_signals+0xb8>
80104721:	eb df                	jmp    80104702 <handle_signals+0x32>
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        p->pendingSignals &= ~(1 << i);
80104728:	f7 d2                	not    %edx
8010472a:	21 c2                	and    %eax,%edx
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
8010472c:	83 ff 11             	cmp    $0x11,%edi
        p->pendingSignals &= ~(1 << i);
8010472f:	89 96 80 00 00 00    	mov    %edx,0x80(%esi)
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
80104735:	0f 84 45 01 00 00    	je     80104880 <handle_signals+0x1b0>
8010473b:	83 fb 11             	cmp    $0x11,%ebx
8010473e:	0f 84 3c 01 00 00    	je     80104880 <handle_signals+0x1b0>
        }else if(p->signalHandler[i] == (void*)SIGCONT || (i == SIGCONT && p->signalHandler[i] == (void*)SIG_DFL)){
80104744:	83 ff 13             	cmp    $0x13,%edi
80104747:	0f 84 43 01 00 00    	je     80104890 <handle_signals+0x1c0>
8010474d:	85 ff                	test   %edi,%edi
8010474f:	0f 94 c0             	sete   %al
80104752:	83 fb 13             	cmp    $0x13,%ebx
80104755:	75 08                	jne    8010475f <handle_signals+0x8f>
80104757:	84 c0                	test   %al,%al
80104759:	0f 85 31 01 00 00    	jne    80104890 <handle_signals+0x1c0>
        }else if(p->signalHandler[i] == (void*)SIGKILL || p->signalHandler[i] == (void*)SIG_DFL){
8010475f:	83 ff 09             	cmp    $0x9,%edi
80104762:	74 04                	je     80104768 <handle_signals+0x98>
80104764:	84 c0                	test   %al,%al
80104766:	74 77                	je     801047df <handle_signals+0x10f>
          sh_sigkill();
80104768:	e8 43 fe ff ff       	call   801045b0 <sh_sigkill>
8010476d:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104773:	90                   	nop
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(int i = 0 ; (p->pendingSignals != 0) && i < 32 ; i++){   
80104778:	83 c3 01             	add    $0x1,%ebx
8010477b:	85 c0                	test   %eax,%eax
8010477d:	74 83                	je     80104702 <handle_signals+0x32>
8010477f:	83 fb 20             	cmp    $0x20,%ebx
80104782:	0f 84 7a ff ff ff    	je     80104702 <handle_signals+0x32>
      if((p->pendingSignals & (1 << i)) != 0){
80104788:	ba 01 00 00 00       	mov    $0x1,%edx
8010478d:	89 d9                	mov    %ebx,%ecx
8010478f:	d3 e2                	shl    %cl,%edx
80104791:	85 c2                	test   %eax,%edx
80104793:	74 e3                	je     80104778 <handle_signals+0xa8>
        if(((p->signalMask & (1 << i)) != 0) && blockable){
80104795:	8b be 84 00 00 00    	mov    0x84(%esi),%edi
      int blockable = (i != SIGKILL) && (i != SIGSTOP);
8010479b:	8d 4b f7             	lea    -0x9(%ebx),%ecx
8010479e:	83 e1 f7             	and    $0xfffffff7,%ecx
        if(((p->signalMask & (1 << i)) != 0) && blockable){
801047a1:	85 d7                	test   %edx,%edi
801047a3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801047a6:	74 04                	je     801047ac <handle_signals+0xdc>
801047a8:	85 c9                	test   %ecx,%ecx
801047aa:	75 cc                	jne    80104778 <handle_signals+0xa8>
      uint espbu = p->tf->esp;
801047ac:	8b 7e 18             	mov    0x18(%esi),%edi
801047af:	89 7d e0             	mov    %edi,-0x20(%ebp)
801047b2:	8b 7f 44             	mov    0x44(%edi),%edi
801047b5:	89 7d dc             	mov    %edi,-0x24(%ebp)
        if(p->signalHandler[i]==(void*)SIG_IGN && blockable){
801047b8:	8b bc 9e 0c 01 00 00 	mov    0x10c(%esi,%ebx,4),%edi
801047bf:	83 ff 01             	cmp    $0x1,%edi
801047c2:	0f 85 60 ff ff ff    	jne    80104728 <handle_signals+0x58>
801047c8:	85 c9                	test   %ecx,%ecx
801047ca:	75 ac                	jne    80104778 <handle_signals+0xa8>
        p->pendingSignals &= ~(1 << i);
801047cc:	f7 d2                	not    %edx
801047ce:	21 c2                	and    %eax,%edx
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
801047d0:	83 fb 11             	cmp    $0x11,%ebx
        p->pendingSignals &= ~(1 << i);
801047d3:	89 96 80 00 00 00    	mov    %edx,0x80(%esi)
        if(p->signalHandler[i] == (void*)SIGSTOP || i == SIGSTOP){
801047d9:	0f 84 a1 00 00 00    	je     80104880 <handle_signals+0x1b0>
          p->signalMaskBU=p->signalMask;
801047df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801047e2:	8d 3c 9e             	lea    (%esi,%ebx,4),%edi
          memmove(p->uTrapFrameBU, p->tf, sizeof(struct trapframe));
801047e5:	83 ec 04             	sub    $0x4,%esp
          p->signalMaskBU=p->signalMask;
801047e8:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
          p->signalMask = p->signalHandlerMasks[i];
801047ee:	8b 87 8c 00 00 00    	mov    0x8c(%edi),%eax
801047f4:	89 86 84 00 00 00    	mov    %eax,0x84(%esi)
          p->tf->esp -= sizeof (struct trapframe);
801047fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047fd:	83 68 44 4c          	subl   $0x4c,0x44(%eax)
          p->uTrapFrameBU = (void*) (p->tf->esp);
80104801:	8b 56 18             	mov    0x18(%esi),%edx
80104804:	8b 42 44             	mov    0x44(%edx),%eax
80104807:	89 86 8c 01 00 00    	mov    %eax,0x18c(%esi)
          memmove(p->uTrapFrameBU, p->tf, sizeof(struct trapframe));
8010480d:	6a 4c                	push   $0x4c
8010480f:	52                   	push   %edx
80104810:	50                   	push   %eax
80104811:	e8 ba 04 00 00       	call   80104cd0 <memmove>
          p->uTrapFrameBU->esp=espbu;
80104816:	8b 86 8c 01 00 00    	mov    0x18c(%esi),%eax
8010481c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
          memmove((void*)p->tf->esp,sigret_start, (uint)&sigret_end - (uint)&sigret_start);
8010481f:	83 c4 0c             	add    $0xc,%esp
          p->uTrapFrameBU->esp=espbu;
80104822:	89 48 44             	mov    %ecx,0x44(%eax)
          p->tf->esp -= (uint)&sigret_end - (uint)&sigret_start;
80104825:	8b 56 18             	mov    0x18(%esi),%edx
80104828:	b8 4e 22 10 80       	mov    $0x8010224e,%eax
8010482d:	2d 55 22 10 80       	sub    $0x80102255,%eax
80104832:	01 42 44             	add    %eax,0x44(%edx)
          memmove((void*)p->tf->esp,sigret_start, (uint)&sigret_end - (uint)&sigret_start);
80104835:	b8 55 22 10 80       	mov    $0x80102255,%eax
8010483a:	2d 4e 22 10 80       	sub    $0x8010224e,%eax
8010483f:	50                   	push   %eax
80104840:	68 4e 22 10 80       	push   $0x8010224e
80104845:	8b 46 18             	mov    0x18(%esi),%eax
80104848:	ff 70 44             	pushl  0x44(%eax)
8010484b:	e8 80 04 00 00       	call   80104cd0 <memmove>
          *((int*)(p->tf->esp-4)) = i;
80104850:	8b 46 18             	mov    0x18(%esi),%eax
          return;
80104853:	83 c4 10             	add    $0x10,%esp
          *((int*)(p->tf->esp-4)) = i;
80104856:	8b 40 44             	mov    0x44(%eax),%eax
80104859:	89 58 fc             	mov    %ebx,-0x4(%eax)
          *((int*)(p->tf->esp-8)) = p->tf->esp;
8010485c:	8b 46 18             	mov    0x18(%esi),%eax
8010485f:	8b 40 44             	mov    0x44(%eax),%eax
80104862:	89 40 f8             	mov    %eax,-0x8(%eax)
          p->tf->esp -= 8;
80104865:	8b 46 18             	mov    0x18(%esi),%eax
80104868:	83 68 44 08          	subl   $0x8,0x44(%eax)
          p->tf->eip = (uint)p->signalHandler[i];
8010486c:	8b 46 18             	mov    0x18(%esi),%eax
8010486f:	8b 97 0c 01 00 00    	mov    0x10c(%edi),%edx
80104875:	89 50 38             	mov    %edx,0x38(%eax)
          return;
80104878:	e9 85 fe ff ff       	jmp    80104702 <handle_signals+0x32>
8010487d:	8d 76 00             	lea    0x0(%esi),%esi
          sh_sigstop();
80104880:	e8 5b fd ff ff       	call   801045e0 <sh_sigstop>
80104885:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010488b:	e9 e8 fe ff ff       	jmp    80104778 <handle_signals+0xa8>
          sh_sigcont();
80104890:	e8 7b fd ff ff       	call   80104610 <sh_sigcont>
80104895:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
8010489b:	e9 d8 fe ff ff       	jmp    80104778 <handle_signals+0xa8>

801048a0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801048aa:	68 60 7e 10 80       	push   $0x80107e60
801048af:	8d 43 04             	lea    0x4(%ebx),%eax
801048b2:	50                   	push   %eax
801048b3:	e8 18 01 00 00       	call   801049d0 <initlock>
  lk->name = name;
801048b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801048bb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801048c1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801048c4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801048cb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801048ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d1:	c9                   	leave  
801048d2:	c3                   	ret    
801048d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	8d 73 04             	lea    0x4(%ebx),%esi
801048ee:	56                   	push   %esi
801048ef:	e8 1c 02 00 00       	call   80104b10 <acquire>
  while (lk->locked) {
801048f4:	8b 13                	mov    (%ebx),%edx
801048f6:	83 c4 10             	add    $0x10,%esp
801048f9:	85 d2                	test   %edx,%edx
801048fb:	74 16                	je     80104913 <acquiresleep+0x33>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104900:	83 ec 08             	sub    $0x8,%esp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	e8 26 f7 ff ff       	call   80104030 <sleep>
  while (lk->locked) {
8010490a:	8b 03                	mov    (%ebx),%eax
8010490c:	83 c4 10             	add    $0x10,%esp
8010490f:	85 c0                	test   %eax,%eax
80104911:	75 ed                	jne    80104900 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104913:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104919:	e8 d2 ee ff ff       	call   801037f0 <myproc>
8010491e:	8b 40 10             	mov    0x10(%eax),%eax
80104921:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104924:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104927:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010492a:	5b                   	pop    %ebx
8010492b:	5e                   	pop    %esi
8010492c:	5d                   	pop    %ebp
  release(&lk->lk);
8010492d:	e9 9e 02 00 00       	jmp    80104bd0 <release>
80104932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	53                   	push   %ebx
80104945:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	8d 73 04             	lea    0x4(%ebx),%esi
8010494e:	56                   	push   %esi
8010494f:	e8 bc 01 00 00       	call   80104b10 <acquire>
  lk->locked = 0;
80104954:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010495a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104961:	89 1c 24             	mov    %ebx,(%esp)
80104964:	e8 a7 f7 ff ff       	call   80104110 <wakeup>
  release(&lk->lk);
80104969:	89 75 08             	mov    %esi,0x8(%ebp)
8010496c:	83 c4 10             	add    $0x10,%esp
}
8010496f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104972:	5b                   	pop    %ebx
80104973:	5e                   	pop    %esi
80104974:	5d                   	pop    %ebp
  release(&lk->lk);
80104975:	e9 56 02 00 00       	jmp    80104bd0 <release>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	57                   	push   %edi
80104984:	56                   	push   %esi
80104985:	53                   	push   %ebx
80104986:	31 ff                	xor    %edi,%edi
80104988:	83 ec 18             	sub    $0x18,%esp
8010498b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010498e:	8d 73 04             	lea    0x4(%ebx),%esi
80104991:	56                   	push   %esi
80104992:	e8 79 01 00 00       	call   80104b10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104997:	8b 03                	mov    (%ebx),%eax
80104999:	83 c4 10             	add    $0x10,%esp
8010499c:	85 c0                	test   %eax,%eax
8010499e:	74 13                	je     801049b3 <holdingsleep+0x33>
801049a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801049a3:	e8 48 ee ff ff       	call   801037f0 <myproc>
801049a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801049ab:	0f 94 c0             	sete   %al
801049ae:	0f b6 c0             	movzbl %al,%eax
801049b1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801049b3:	83 ec 0c             	sub    $0xc,%esp
801049b6:	56                   	push   %esi
801049b7:	e8 14 02 00 00       	call   80104bd0 <release>
  return r;
}
801049bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049bf:	89 f8                	mov    %edi,%eax
801049c1:	5b                   	pop    %ebx
801049c2:	5e                   	pop    %esi
801049c3:	5f                   	pop    %edi
801049c4:	5d                   	pop    %ebp
801049c5:	c3                   	ret    
801049c6:	66 90                	xchg   %ax,%ax
801049c8:	66 90                	xchg   %ax,%ax
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801049d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801049d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801049df:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801049e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801049f0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801049f1:	31 d2                	xor    %edx,%edx
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801049f6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801049f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801049fc:	83 e8 08             	sub    $0x8,%eax
801049ff:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a00:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104a06:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104a0c:	77 1a                	ja     80104a28 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104a0e:	8b 58 04             	mov    0x4(%eax),%ebx
80104a11:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104a14:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104a17:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104a19:	83 fa 0a             	cmp    $0xa,%edx
80104a1c:	75 e2                	jne    80104a00 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104a1e:	5b                   	pop    %ebx
80104a1f:	5d                   	pop    %ebp
80104a20:	c3                   	ret    
80104a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a28:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104a2b:	83 c1 28             	add    $0x28,%ecx
80104a2e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104a36:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104a39:	39 c1                	cmp    %eax,%ecx
80104a3b:	75 f3                	jne    80104a30 <getcallerpcs+0x40>
}
80104a3d:	5b                   	pop    %ebx
80104a3e:	5d                   	pop    %ebp
80104a3f:	c3                   	ret    

80104a40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a47:	9c                   	pushf  
80104a48:	5b                   	pop    %ebx
  asm volatile("cli");
80104a49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a4a:	e8 01 ed ff ff       	call   80103750 <mycpu>
80104a4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a55:	85 c0                	test   %eax,%eax
80104a57:	75 11                	jne    80104a6a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a59:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a5f:	e8 ec ec ff ff       	call   80103750 <mycpu>
80104a64:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a6a:	e8 e1 ec ff ff       	call   80103750 <mycpu>
80104a6f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a76:	83 c4 04             	add    $0x4,%esp
80104a79:	5b                   	pop    %ebx
80104a7a:	5d                   	pop    %ebp
80104a7b:	c3                   	ret    
80104a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a80 <popcli>:

void
popcli(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a86:	9c                   	pushf  
80104a87:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a88:	f6 c4 02             	test   $0x2,%ah
80104a8b:	75 35                	jne    80104ac2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a8d:	e8 be ec ff ff       	call   80103750 <mycpu>
80104a92:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a99:	78 34                	js     80104acf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a9b:	e8 b0 ec ff ff       	call   80103750 <mycpu>
80104aa0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104aa6:	85 d2                	test   %edx,%edx
80104aa8:	74 06                	je     80104ab0 <popcli+0x30>
    sti();
}
80104aaa:	c9                   	leave  
80104aab:	c3                   	ret    
80104aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ab0:	e8 9b ec ff ff       	call   80103750 <mycpu>
80104ab5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104abb:	85 c0                	test   %eax,%eax
80104abd:	74 eb                	je     80104aaa <popcli+0x2a>
  asm volatile("sti");
80104abf:	fb                   	sti    
}
80104ac0:	c9                   	leave  
80104ac1:	c3                   	ret    
    panic("popcli - interruptible");
80104ac2:	83 ec 0c             	sub    $0xc,%esp
80104ac5:	68 6b 7e 10 80       	push   $0x80107e6b
80104aca:	e8 c1 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	68 82 7e 10 80       	push   $0x80107e82
80104ad7:	e8 b4 b8 ff ff       	call   80100390 <panic>
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <holding>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	53                   	push   %ebx
80104ae5:	8b 75 08             	mov    0x8(%ebp),%esi
80104ae8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104aea:	e8 51 ff ff ff       	call   80104a40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aef:	8b 06                	mov    (%esi),%eax
80104af1:	85 c0                	test   %eax,%eax
80104af3:	74 10                	je     80104b05 <holding+0x25>
80104af5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104af8:	e8 53 ec ff ff       	call   80103750 <mycpu>
80104afd:	39 c3                	cmp    %eax,%ebx
80104aff:	0f 94 c3             	sete   %bl
80104b02:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104b05:	e8 76 ff ff ff       	call   80104a80 <popcli>
}
80104b0a:	89 d8                	mov    %ebx,%eax
80104b0c:	5b                   	pop    %ebx
80104b0d:	5e                   	pop    %esi
80104b0e:	5d                   	pop    %ebp
80104b0f:	c3                   	ret    

80104b10 <acquire>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	56                   	push   %esi
80104b14:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104b15:	e8 26 ff ff ff       	call   80104a40 <pushcli>
  if(holding(lk))
80104b1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b1d:	83 ec 0c             	sub    $0xc,%esp
80104b20:	53                   	push   %ebx
80104b21:	e8 ba ff ff ff       	call   80104ae0 <holding>
80104b26:	83 c4 10             	add    $0x10,%esp
80104b29:	85 c0                	test   %eax,%eax
80104b2b:	0f 85 83 00 00 00    	jne    80104bb4 <acquire+0xa4>
80104b31:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b33:	ba 01 00 00 00       	mov    $0x1,%edx
80104b38:	eb 09                	jmp    80104b43 <acquire+0x33>
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b43:	89 d0                	mov    %edx,%eax
80104b45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	75 f4                	jne    80104b40 <acquire+0x30>
  __sync_synchronize();
80104b4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b54:	e8 f7 eb ff ff       	call   80103750 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104b59:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104b5c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b5f:	89 e8                	mov    %ebp,%eax
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b68:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104b6e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104b74:	77 1a                	ja     80104b90 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b76:	8b 48 04             	mov    0x4(%eax),%ecx
80104b79:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104b7c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b81:	83 fe 0a             	cmp    $0xa,%esi
80104b84:	75 e2                	jne    80104b68 <acquire+0x58>
}
80104b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b89:	5b                   	pop    %ebx
80104b8a:	5e                   	pop    %esi
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
80104b90:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104b93:	83 c2 28             	add    $0x28,%edx
80104b96:	8d 76 00             	lea    0x0(%esi),%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ba6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ba9:	39 d0                	cmp    %edx,%eax
80104bab:	75 f3                	jne    80104ba0 <acquire+0x90>
}
80104bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb0:	5b                   	pop    %ebx
80104bb1:	5e                   	pop    %esi
80104bb2:	5d                   	pop    %ebp
80104bb3:	c3                   	ret    
    panic("acquire");
80104bb4:	83 ec 0c             	sub    $0xc,%esp
80104bb7:	68 89 7e 10 80       	push   $0x80107e89
80104bbc:	e8 cf b7 ff ff       	call   80100390 <panic>
80104bc1:	eb 0d                	jmp    80104bd0 <release>
80104bc3:	90                   	nop
80104bc4:	90                   	nop
80104bc5:	90                   	nop
80104bc6:	90                   	nop
80104bc7:	90                   	nop
80104bc8:	90                   	nop
80104bc9:	90                   	nop
80104bca:	90                   	nop
80104bcb:	90                   	nop
80104bcc:	90                   	nop
80104bcd:	90                   	nop
80104bce:	90                   	nop
80104bcf:	90                   	nop

80104bd0 <release>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	53                   	push   %ebx
80104bd4:	83 ec 10             	sub    $0x10,%esp
80104bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bda:	53                   	push   %ebx
80104bdb:	e8 00 ff ff ff       	call   80104ae0 <holding>
80104be0:	83 c4 10             	add    $0x10,%esp
80104be3:	85 c0                	test   %eax,%eax
80104be5:	74 22                	je     80104c09 <release+0x39>
  lk->pcs[0] = 0;
80104be7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bee:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bf5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bfa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104c00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c03:	c9                   	leave  
  popcli();
80104c04:	e9 77 fe ff ff       	jmp    80104a80 <popcli>
    panic("release");
80104c09:	83 ec 0c             	sub    $0xc,%esp
80104c0c:	68 91 7e 10 80       	push   $0x80107e91
80104c11:	e8 7a b7 ff ff       	call   80100390 <panic>
80104c16:	66 90                	xchg   %ax,%ax
80104c18:	66 90                	xchg   %ax,%ax
80104c1a:	66 90                	xchg   %ax,%ax
80104c1c:	66 90                	xchg   %ax,%ax
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	53                   	push   %ebx
80104c25:	8b 55 08             	mov    0x8(%ebp),%edx
80104c28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104c2b:	f6 c2 03             	test   $0x3,%dl
80104c2e:	75 05                	jne    80104c35 <memset+0x15>
80104c30:	f6 c1 03             	test   $0x3,%cl
80104c33:	74 13                	je     80104c48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104c35:	89 d7                	mov    %edx,%edi
80104c37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c3a:	fc                   	cld    
80104c3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c3d:	5b                   	pop    %ebx
80104c3e:	89 d0                	mov    %edx,%eax
80104c40:	5f                   	pop    %edi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	90                   	nop
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104c48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c4c:	c1 e9 02             	shr    $0x2,%ecx
80104c4f:	89 f8                	mov    %edi,%eax
80104c51:	89 fb                	mov    %edi,%ebx
80104c53:	c1 e0 18             	shl    $0x18,%eax
80104c56:	c1 e3 10             	shl    $0x10,%ebx
80104c59:	09 d8                	or     %ebx,%eax
80104c5b:	09 f8                	or     %edi,%eax
80104c5d:	c1 e7 08             	shl    $0x8,%edi
80104c60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c62:	89 d7                	mov    %edx,%edi
80104c64:	fc                   	cld    
80104c65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104c67:	5b                   	pop    %ebx
80104c68:	89 d0                	mov    %edx,%eax
80104c6a:	5f                   	pop    %edi
80104c6b:	5d                   	pop    %ebp
80104c6c:	c3                   	ret    
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi

80104c70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	57                   	push   %edi
80104c74:	56                   	push   %esi
80104c75:	53                   	push   %ebx
80104c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104c79:	8b 75 08             	mov    0x8(%ebp),%esi
80104c7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c7f:	85 db                	test   %ebx,%ebx
80104c81:	74 29                	je     80104cac <memcmp+0x3c>
    if(*s1 != *s2)
80104c83:	0f b6 16             	movzbl (%esi),%edx
80104c86:	0f b6 0f             	movzbl (%edi),%ecx
80104c89:	38 d1                	cmp    %dl,%cl
80104c8b:	75 2b                	jne    80104cb8 <memcmp+0x48>
80104c8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104c92:	eb 14                	jmp    80104ca8 <memcmp+0x38>
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104c9c:	83 c0 01             	add    $0x1,%eax
80104c9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104ca4:	38 ca                	cmp    %cl,%dl
80104ca6:	75 10                	jne    80104cb8 <memcmp+0x48>
  while(n-- > 0){
80104ca8:	39 d8                	cmp    %ebx,%eax
80104caa:	75 ec                	jne    80104c98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104cac:	5b                   	pop    %ebx
  return 0;
80104cad:	31 c0                	xor    %eax,%eax
}
80104caf:	5e                   	pop    %esi
80104cb0:	5f                   	pop    %edi
80104cb1:	5d                   	pop    %ebp
80104cb2:	c3                   	ret    
80104cb3:	90                   	nop
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104cb8:	0f b6 c2             	movzbl %dl,%eax
}
80104cbb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104cbc:	29 c8                	sub    %ecx,%eax
}
80104cbe:	5e                   	pop    %esi
80104cbf:	5f                   	pop    %edi
80104cc0:	5d                   	pop    %ebp
80104cc1:	c3                   	ret    
80104cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	56                   	push   %esi
80104cd4:	53                   	push   %ebx
80104cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104cd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104cdb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104cde:	39 c3                	cmp    %eax,%ebx
80104ce0:	73 26                	jae    80104d08 <memmove+0x38>
80104ce2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ce5:	39 c8                	cmp    %ecx,%eax
80104ce7:	73 1f                	jae    80104d08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ce9:	85 f6                	test   %esi,%esi
80104ceb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104cee:	74 0f                	je     80104cff <memmove+0x2f>
      *--d = *--s;
80104cf0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104cf4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104cf7:	83 ea 01             	sub    $0x1,%edx
80104cfa:	83 fa ff             	cmp    $0xffffffff,%edx
80104cfd:	75 f1                	jne    80104cf0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cff:	5b                   	pop    %ebx
80104d00:	5e                   	pop    %esi
80104d01:	5d                   	pop    %ebp
80104d02:	c3                   	ret    
80104d03:	90                   	nop
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104d08:	31 d2                	xor    %edx,%edx
80104d0a:	85 f6                	test   %esi,%esi
80104d0c:	74 f1                	je     80104cff <memmove+0x2f>
80104d0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104d10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104d17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104d1a:	39 d6                	cmp    %edx,%esi
80104d1c:	75 f2                	jne    80104d10 <memmove+0x40>
}
80104d1e:	5b                   	pop    %ebx
80104d1f:	5e                   	pop    %esi
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    
80104d22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104d34:	eb 9a                	jmp    80104cd0 <memmove>
80104d36:	8d 76 00             	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104d48:	53                   	push   %ebx
80104d49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d4f:	85 ff                	test   %edi,%edi
80104d51:	74 2f                	je     80104d82 <strncmp+0x42>
80104d53:	0f b6 01             	movzbl (%ecx),%eax
80104d56:	0f b6 1e             	movzbl (%esi),%ebx
80104d59:	84 c0                	test   %al,%al
80104d5b:	74 37                	je     80104d94 <strncmp+0x54>
80104d5d:	38 c3                	cmp    %al,%bl
80104d5f:	75 33                	jne    80104d94 <strncmp+0x54>
80104d61:	01 f7                	add    %esi,%edi
80104d63:	eb 13                	jmp    80104d78 <strncmp+0x38>
80104d65:	8d 76 00             	lea    0x0(%esi),%esi
80104d68:	0f b6 01             	movzbl (%ecx),%eax
80104d6b:	84 c0                	test   %al,%al
80104d6d:	74 21                	je     80104d90 <strncmp+0x50>
80104d6f:	0f b6 1a             	movzbl (%edx),%ebx
80104d72:	89 d6                	mov    %edx,%esi
80104d74:	38 d8                	cmp    %bl,%al
80104d76:	75 1c                	jne    80104d94 <strncmp+0x54>
    n--, p++, q++;
80104d78:	8d 56 01             	lea    0x1(%esi),%edx
80104d7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d7e:	39 fa                	cmp    %edi,%edx
80104d80:	75 e6                	jne    80104d68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d82:	5b                   	pop    %ebx
    return 0;
80104d83:	31 c0                	xor    %eax,%eax
}
80104d85:	5e                   	pop    %esi
80104d86:	5f                   	pop    %edi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104d94:	29 d8                	sub    %ebx,%eax
}
80104d96:	5b                   	pop    %ebx
80104d97:	5e                   	pop    %esi
80104d98:	5f                   	pop    %edi
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    
80104d9b:	90                   	nop
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104da0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
80104da5:	8b 45 08             	mov    0x8(%ebp),%eax
80104da8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104dab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104dae:	89 c2                	mov    %eax,%edx
80104db0:	eb 19                	jmp    80104dcb <strncpy+0x2b>
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db8:	83 c3 01             	add    $0x1,%ebx
80104dbb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104dbf:	83 c2 01             	add    $0x1,%edx
80104dc2:	84 c9                	test   %cl,%cl
80104dc4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104dc7:	74 09                	je     80104dd2 <strncpy+0x32>
80104dc9:	89 f1                	mov    %esi,%ecx
80104dcb:	85 c9                	test   %ecx,%ecx
80104dcd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104dd0:	7f e6                	jg     80104db8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104dd2:	31 c9                	xor    %ecx,%ecx
80104dd4:	85 f6                	test   %esi,%esi
80104dd6:	7e 17                	jle    80104def <strncpy+0x4f>
80104dd8:	90                   	nop
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104de0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104de4:	89 f3                	mov    %esi,%ebx
80104de6:	83 c1 01             	add    $0x1,%ecx
80104de9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104deb:	85 db                	test   %ebx,%ebx
80104ded:	7f f1                	jg     80104de0 <strncpy+0x40>
  return os;
}
80104def:	5b                   	pop    %ebx
80104df0:	5e                   	pop    %esi
80104df1:	5d                   	pop    %ebp
80104df2:	c3                   	ret    
80104df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	56                   	push   %esi
80104e04:	53                   	push   %ebx
80104e05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e08:	8b 45 08             	mov    0x8(%ebp),%eax
80104e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104e0e:	85 c9                	test   %ecx,%ecx
80104e10:	7e 26                	jle    80104e38 <safestrcpy+0x38>
80104e12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104e16:	89 c1                	mov    %eax,%ecx
80104e18:	eb 17                	jmp    80104e31 <safestrcpy+0x31>
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e20:	83 c2 01             	add    $0x1,%edx
80104e23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e27:	83 c1 01             	add    $0x1,%ecx
80104e2a:	84 db                	test   %bl,%bl
80104e2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e2f:	74 04                	je     80104e35 <safestrcpy+0x35>
80104e31:	39 f2                	cmp    %esi,%edx
80104e33:	75 eb                	jne    80104e20 <safestrcpy+0x20>
    ;
  *s = 0;
80104e35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e38:	5b                   	pop    %ebx
80104e39:	5e                   	pop    %esi
80104e3a:	5d                   	pop    %ebp
80104e3b:	c3                   	ret    
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strlen>:

int
strlen(const char *s)
{
80104e40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e41:	31 c0                	xor    %eax,%eax
{
80104e43:	89 e5                	mov    %esp,%ebp
80104e45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104e48:	80 3a 00             	cmpb   $0x0,(%edx)
80104e4b:	74 0c                	je     80104e59 <strlen+0x19>
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
80104e50:	83 c0 01             	add    $0x1,%eax
80104e53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e57:	75 f7                	jne    80104e50 <strlen+0x10>
    ;
  return n;
}
80104e59:	5d                   	pop    %ebp
80104e5a:	c3                   	ret    

80104e5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e63:	55                   	push   %ebp
  pushl %ebx
80104e64:	53                   	push   %ebx
  pushl %esi
80104e65:	56                   	push   %esi
  pushl %edi
80104e66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e6b:	5f                   	pop    %edi
  popl %esi
80104e6c:	5e                   	pop    %esi
  popl %ebx
80104e6d:	5b                   	pop    %ebx
  popl %ebp
80104e6e:	5d                   	pop    %ebp
  ret
80104e6f:	c3                   	ret    

80104e70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	53                   	push   %ebx
80104e74:	83 ec 04             	sub    $0x4,%esp
80104e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e7a:	e8 71 e9 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e7f:	8b 00                	mov    (%eax),%eax
80104e81:	39 d8                	cmp    %ebx,%eax
80104e83:	76 1b                	jbe    80104ea0 <fetchint+0x30>
80104e85:	8d 53 04             	lea    0x4(%ebx),%edx
80104e88:	39 d0                	cmp    %edx,%eax
80104e8a:	72 14                	jb     80104ea0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8f:	8b 13                	mov    (%ebx),%edx
80104e91:	89 10                	mov    %edx,(%eax)
  return 0;
80104e93:	31 c0                	xor    %eax,%eax
}
80104e95:	83 c4 04             	add    $0x4,%esp
80104e98:	5b                   	pop    %ebx
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ea5:	eb ee                	jmp    80104e95 <fetchint+0x25>
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	53                   	push   %ebx
80104eb4:	83 ec 04             	sub    $0x4,%esp
80104eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eba:	e8 31 e9 ff ff       	call   801037f0 <myproc>

  if(addr >= curproc->sz)
80104ebf:	39 18                	cmp    %ebx,(%eax)
80104ec1:	76 29                	jbe    80104eec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ec6:	89 da                	mov    %ebx,%edx
80104ec8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104eca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104ecc:	39 c3                	cmp    %eax,%ebx
80104ece:	73 1c                	jae    80104eec <fetchstr+0x3c>
    if(*s == 0)
80104ed0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ed3:	75 10                	jne    80104ee5 <fetchstr+0x35>
80104ed5:	eb 39                	jmp    80104f10 <fetchstr+0x60>
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ee0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ee3:	74 1b                	je     80104f00 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ee5:	83 c2 01             	add    $0x1,%edx
80104ee8:	39 d0                	cmp    %edx,%eax
80104eea:	77 f4                	ja     80104ee0 <fetchstr+0x30>
    return -1;
80104eec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ef1:	83 c4 04             	add    $0x4,%esp
80104ef4:	5b                   	pop    %ebx
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f00:	83 c4 04             	add    $0x4,%esp
80104f03:	89 d0                	mov    %edx,%eax
80104f05:	29 d8                	sub    %ebx,%eax
80104f07:	5b                   	pop    %ebx
80104f08:	5d                   	pop    %ebp
80104f09:	c3                   	ret    
80104f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104f10:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104f12:	eb dd                	jmp    80104ef1 <fetchstr+0x41>
80104f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104f20 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	56                   	push   %esi
80104f24:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f25:	e8 c6 e8 ff ff       	call   801037f0 <myproc>
80104f2a:	8b 40 18             	mov    0x18(%eax),%eax
80104f2d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f30:	8b 40 44             	mov    0x44(%eax),%eax
80104f33:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104f36:	e8 b5 e8 ff ff       	call   801037f0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f3b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f3d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f40:	39 c6                	cmp    %eax,%esi
80104f42:	73 1c                	jae    80104f60 <argint+0x40>
80104f44:	8d 53 08             	lea    0x8(%ebx),%edx
80104f47:	39 d0                	cmp    %edx,%eax
80104f49:	72 15                	jb     80104f60 <argint+0x40>
  *ip = *(int*)(addr);
80104f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f4e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f51:	89 10                	mov    %edx,(%eax)
  return 0;
80104f53:	31 c0                	xor    %eax,%eax
}
80104f55:	5b                   	pop    %ebx
80104f56:	5e                   	pop    %esi
80104f57:	5d                   	pop    %ebp
80104f58:	c3                   	ret    
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f65:	eb ee                	jmp    80104f55 <argint+0x35>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f70 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	56                   	push   %esi
80104f74:	53                   	push   %ebx
80104f75:	83 ec 10             	sub    $0x10,%esp
80104f78:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f7b:	e8 70 e8 ff ff       	call   801037f0 <myproc>
80104f80:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104f82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f85:	83 ec 08             	sub    $0x8,%esp
80104f88:	50                   	push   %eax
80104f89:	ff 75 08             	pushl  0x8(%ebp)
80104f8c:	e8 8f ff ff ff       	call   80104f20 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 c0                	test   %eax,%eax
80104f96:	78 28                	js     80104fc0 <argptr+0x50>
80104f98:	85 db                	test   %ebx,%ebx
80104f9a:	78 24                	js     80104fc0 <argptr+0x50>
80104f9c:	8b 16                	mov    (%esi),%edx
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	39 c2                	cmp    %eax,%edx
80104fa3:	76 1b                	jbe    80104fc0 <argptr+0x50>
80104fa5:	01 c3                	add    %eax,%ebx
80104fa7:	39 da                	cmp    %ebx,%edx
80104fa9:	72 15                	jb     80104fc0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104fab:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fae:	89 02                	mov    %eax,(%edx)
  return 0;
80104fb0:	31 c0                	xor    %eax,%eax
}
80104fb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fb5:	5b                   	pop    %ebx
80104fb6:	5e                   	pop    %esi
80104fb7:	5d                   	pop    %ebp
80104fb8:	c3                   	ret    
80104fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	eb eb                	jmp    80104fb2 <argptr+0x42>
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fd9:	50                   	push   %eax
80104fda:	ff 75 08             	pushl  0x8(%ebp)
80104fdd:	e8 3e ff ff ff       	call   80104f20 <argint>
80104fe2:	83 c4 10             	add    $0x10,%esp
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 17                	js     80105000 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104fe9:	83 ec 08             	sub    $0x8,%esp
80104fec:	ff 75 0c             	pushl  0xc(%ebp)
80104fef:	ff 75 f4             	pushl  -0xc(%ebp)
80104ff2:	e8 b9 fe ff ff       	call   80104eb0 <fetchstr>
80104ff7:	83 c4 10             	add    $0x10,%esp
}
80104ffa:	c9                   	leave  
80104ffb:	c3                   	ret    
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <syscall>:
[SYS_sigret] sys_sigret,
};

void
syscall(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	53                   	push   %ebx
80105014:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105017:	e8 d4 e7 ff ff       	call   801037f0 <myproc>
8010501c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010501e:	8b 40 18             	mov    0x18(%eax),%eax
80105021:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105024:	8d 50 ff             	lea    -0x1(%eax),%edx
80105027:	83 fa 17             	cmp    $0x17,%edx
8010502a:	77 1c                	ja     80105048 <syscall+0x38>
8010502c:	8b 14 85 c0 7e 10 80 	mov    -0x7fef8140(,%eax,4),%edx
80105033:	85 d2                	test   %edx,%edx
80105035:	74 11                	je     80105048 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105037:	ff d2                	call   *%edx
80105039:	8b 53 18             	mov    0x18(%ebx),%edx
8010503c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010503f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105042:	c9                   	leave  
80105043:	c3                   	ret    
80105044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105048:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105049:	8d 43 70             	lea    0x70(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010504c:	50                   	push   %eax
8010504d:	ff 73 10             	pushl  0x10(%ebx)
80105050:	68 99 7e 10 80       	push   $0x80107e99
80105055:	e8 06 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010505a:	8b 43 18             	mov    0x18(%ebx),%eax
8010505d:	83 c4 10             	add    $0x10,%esp
80105060:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105067:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010506a:	c9                   	leave  
8010506b:	c3                   	ret    
8010506c:	66 90                	xchg   %ax,%ax
8010506e:	66 90                	xchg   %ax,%ax

80105070 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105076:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105079:	83 ec 34             	sub    $0x34,%esp
8010507c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010507f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105082:	56                   	push   %esi
80105083:	50                   	push   %eax
{
80105084:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105087:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010508a:	e8 a1 ce ff ff       	call   80101f30 <nameiparent>
8010508f:	83 c4 10             	add    $0x10,%esp
80105092:	85 c0                	test   %eax,%eax
80105094:	0f 84 46 01 00 00    	je     801051e0 <create+0x170>
    return 0;
  ilock(dp);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	89 c3                	mov    %eax,%ebx
8010509f:	50                   	push   %eax
801050a0:	e8 0b c6 ff ff       	call   801016b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801050a5:	83 c4 0c             	add    $0xc,%esp
801050a8:	6a 00                	push   $0x0
801050aa:	56                   	push   %esi
801050ab:	53                   	push   %ebx
801050ac:	e8 2f cb ff ff       	call   80101be0 <dirlookup>
801050b1:	83 c4 10             	add    $0x10,%esp
801050b4:	85 c0                	test   %eax,%eax
801050b6:	89 c7                	mov    %eax,%edi
801050b8:	74 36                	je     801050f0 <create+0x80>
    iunlockput(dp);
801050ba:	83 ec 0c             	sub    $0xc,%esp
801050bd:	53                   	push   %ebx
801050be:	e8 7d c8 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
801050c3:	89 3c 24             	mov    %edi,(%esp)
801050c6:	e8 e5 c5 ff ff       	call   801016b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050cb:	83 c4 10             	add    $0x10,%esp
801050ce:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050d3:	0f 85 97 00 00 00    	jne    80105170 <create+0x100>
801050d9:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801050de:	0f 85 8c 00 00 00    	jne    80105170 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050e7:	89 f8                	mov    %edi,%eax
801050e9:	5b                   	pop    %ebx
801050ea:	5e                   	pop    %esi
801050eb:	5f                   	pop    %edi
801050ec:	5d                   	pop    %ebp
801050ed:	c3                   	ret    
801050ee:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
801050f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	50                   	push   %eax
801050f8:	ff 33                	pushl  (%ebx)
801050fa:	e8 41 c4 ff ff       	call   80101540 <ialloc>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	85 c0                	test   %eax,%eax
80105104:	89 c7                	mov    %eax,%edi
80105106:	0f 84 e8 00 00 00    	je     801051f4 <create+0x184>
  ilock(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	50                   	push   %eax
80105110:	e8 9b c5 ff ff       	call   801016b0 <ilock>
  ip->major = major;
80105115:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105119:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010511d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105121:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105125:	b8 01 00 00 00       	mov    $0x1,%eax
8010512a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010512e:	89 3c 24             	mov    %edi,(%esp)
80105131:	e8 ca c4 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010513e:	74 50                	je     80105190 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	ff 77 04             	pushl  0x4(%edi)
80105146:	56                   	push   %esi
80105147:	53                   	push   %ebx
80105148:	e8 03 cd ff ff       	call   80101e50 <dirlink>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	0f 88 8f 00 00 00    	js     801051e7 <create+0x177>
  iunlockput(dp);
80105158:	83 ec 0c             	sub    $0xc,%esp
8010515b:	53                   	push   %ebx
8010515c:	e8 df c7 ff ff       	call   80101940 <iunlockput>
  return ip;
80105161:	83 c4 10             	add    $0x10,%esp
}
80105164:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105167:	89 f8                	mov    %edi,%eax
80105169:	5b                   	pop    %ebx
8010516a:	5e                   	pop    %esi
8010516b:	5f                   	pop    %edi
8010516c:	5d                   	pop    %ebp
8010516d:	c3                   	ret    
8010516e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105170:	83 ec 0c             	sub    $0xc,%esp
80105173:	57                   	push   %edi
    return 0;
80105174:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105176:	e8 c5 c7 ff ff       	call   80101940 <iunlockput>
    return 0;
8010517b:	83 c4 10             	add    $0x10,%esp
}
8010517e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105181:	89 f8                	mov    %edi,%eax
80105183:	5b                   	pop    %ebx
80105184:	5e                   	pop    %esi
80105185:	5f                   	pop    %edi
80105186:	5d                   	pop    %ebp
80105187:	c3                   	ret    
80105188:	90                   	nop
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105190:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	53                   	push   %ebx
80105199:	e8 62 c4 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010519e:	83 c4 0c             	add    $0xc,%esp
801051a1:	ff 77 04             	pushl  0x4(%edi)
801051a4:	68 40 7f 10 80       	push   $0x80107f40
801051a9:	57                   	push   %edi
801051aa:	e8 a1 cc ff ff       	call   80101e50 <dirlink>
801051af:	83 c4 10             	add    $0x10,%esp
801051b2:	85 c0                	test   %eax,%eax
801051b4:	78 1c                	js     801051d2 <create+0x162>
801051b6:	83 ec 04             	sub    $0x4,%esp
801051b9:	ff 73 04             	pushl  0x4(%ebx)
801051bc:	68 3f 7f 10 80       	push   $0x80107f3f
801051c1:	57                   	push   %edi
801051c2:	e8 89 cc ff ff       	call   80101e50 <dirlink>
801051c7:	83 c4 10             	add    $0x10,%esp
801051ca:	85 c0                	test   %eax,%eax
801051cc:	0f 89 6e ff ff ff    	jns    80105140 <create+0xd0>
      panic("create dots");
801051d2:	83 ec 0c             	sub    $0xc,%esp
801051d5:	68 33 7f 10 80       	push   $0x80107f33
801051da:	e8 b1 b1 ff ff       	call   80100390 <panic>
801051df:	90                   	nop
    return 0;
801051e0:	31 ff                	xor    %edi,%edi
801051e2:	e9 fd fe ff ff       	jmp    801050e4 <create+0x74>
    panic("create: dirlink");
801051e7:	83 ec 0c             	sub    $0xc,%esp
801051ea:	68 42 7f 10 80       	push   $0x80107f42
801051ef:	e8 9c b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 24 7f 10 80       	push   $0x80107f24
801051fc:	e8 8f b1 ff ff       	call   80100390 <panic>
80105201:	eb 0d                	jmp    80105210 <argfd.constprop.0>
80105203:	90                   	nop
80105204:	90                   	nop
80105205:	90                   	nop
80105206:	90                   	nop
80105207:	90                   	nop
80105208:	90                   	nop
80105209:	90                   	nop
8010520a:	90                   	nop
8010520b:	90                   	nop
8010520c:	90                   	nop
8010520d:	90                   	nop
8010520e:	90                   	nop
8010520f:	90                   	nop

80105210 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	56                   	push   %esi
80105214:	53                   	push   %ebx
80105215:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105217:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010521a:	89 d6                	mov    %edx,%esi
8010521c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010521f:	50                   	push   %eax
80105220:	6a 00                	push   $0x0
80105222:	e8 f9 fc ff ff       	call   80104f20 <argint>
80105227:	83 c4 10             	add    $0x10,%esp
8010522a:	85 c0                	test   %eax,%eax
8010522c:	78 2a                	js     80105258 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010522e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105232:	77 24                	ja     80105258 <argfd.constprop.0+0x48>
80105234:	e8 b7 e5 ff ff       	call   801037f0 <myproc>
80105239:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010523c:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80105240:	85 c0                	test   %eax,%eax
80105242:	74 14                	je     80105258 <argfd.constprop.0+0x48>
  if(pfd)
80105244:	85 db                	test   %ebx,%ebx
80105246:	74 02                	je     8010524a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105248:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010524a:	89 06                	mov    %eax,(%esi)
  return 0;
8010524c:	31 c0                	xor    %eax,%eax
}
8010524e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105251:	5b                   	pop    %ebx
80105252:	5e                   	pop    %esi
80105253:	5d                   	pop    %ebp
80105254:	c3                   	ret    
80105255:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010525d:	eb ef                	jmp    8010524e <argfd.constprop.0+0x3e>
8010525f:	90                   	nop

80105260 <sys_dup>:
{
80105260:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105261:	31 c0                	xor    %eax,%eax
{
80105263:	89 e5                	mov    %esp,%ebp
80105265:	56                   	push   %esi
80105266:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105267:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010526a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010526d:	e8 9e ff ff ff       	call   80105210 <argfd.constprop.0>
80105272:	85 c0                	test   %eax,%eax
80105274:	78 42                	js     801052b8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105276:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105279:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010527b:	e8 70 e5 ff ff       	call   801037f0 <myproc>
80105280:	eb 0e                	jmp    80105290 <sys_dup+0x30>
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105288:	83 c3 01             	add    $0x1,%ebx
8010528b:	83 fb 10             	cmp    $0x10,%ebx
8010528e:	74 28                	je     801052b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105290:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105294:	85 d2                	test   %edx,%edx
80105296:	75 f0                	jne    80105288 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105298:	89 74 98 2c          	mov    %esi,0x2c(%eax,%ebx,4)
  filedup(f);
8010529c:	83 ec 0c             	sub    $0xc,%esp
8010529f:	ff 75 f4             	pushl  -0xc(%ebp)
801052a2:	e8 79 bb ff ff       	call   80100e20 <filedup>
  return fd;
801052a7:	83 c4 10             	add    $0x10,%esp
}
801052aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ad:	89 d8                	mov    %ebx,%eax
801052af:	5b                   	pop    %ebx
801052b0:	5e                   	pop    %esi
801052b1:	5d                   	pop    %ebp
801052b2:	c3                   	ret    
801052b3:	90                   	nop
801052b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801052bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801052c0:	89 d8                	mov    %ebx,%eax
801052c2:	5b                   	pop    %ebx
801052c3:	5e                   	pop    %esi
801052c4:	5d                   	pop    %ebp
801052c5:	c3                   	ret    
801052c6:	8d 76 00             	lea    0x0(%esi),%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_read>:
{
801052d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d1:	31 c0                	xor    %eax,%eax
{
801052d3:	89 e5                	mov    %esp,%ebp
801052d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052db:	e8 30 ff ff ff       	call   80105210 <argfd.constprop.0>
801052e0:	85 c0                	test   %eax,%eax
801052e2:	78 4c                	js     80105330 <sys_read+0x60>
801052e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e7:	83 ec 08             	sub    $0x8,%esp
801052ea:	50                   	push   %eax
801052eb:	6a 02                	push   $0x2
801052ed:	e8 2e fc ff ff       	call   80104f20 <argint>
801052f2:	83 c4 10             	add    $0x10,%esp
801052f5:	85 c0                	test   %eax,%eax
801052f7:	78 37                	js     80105330 <sys_read+0x60>
801052f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fc:	83 ec 04             	sub    $0x4,%esp
801052ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105302:	50                   	push   %eax
80105303:	6a 01                	push   $0x1
80105305:	e8 66 fc ff ff       	call   80104f70 <argptr>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	85 c0                	test   %eax,%eax
8010530f:	78 1f                	js     80105330 <sys_read+0x60>
  return fileread(f, p, n);
80105311:	83 ec 04             	sub    $0x4,%esp
80105314:	ff 75 f0             	pushl  -0x10(%ebp)
80105317:	ff 75 f4             	pushl  -0xc(%ebp)
8010531a:	ff 75 ec             	pushl  -0x14(%ebp)
8010531d:	e8 6e bc ff ff       	call   80100f90 <fileread>
80105322:	83 c4 10             	add    $0x10,%esp
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_write>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105348:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010534b:	e8 c0 fe ff ff       	call   80105210 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 4c                	js     801053a0 <sys_write+0x60>
80105354:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105357:	83 ec 08             	sub    $0x8,%esp
8010535a:	50                   	push   %eax
8010535b:	6a 02                	push   $0x2
8010535d:	e8 be fb ff ff       	call   80104f20 <argint>
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	85 c0                	test   %eax,%eax
80105367:	78 37                	js     801053a0 <sys_write+0x60>
80105369:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010536c:	83 ec 04             	sub    $0x4,%esp
8010536f:	ff 75 f0             	pushl  -0x10(%ebp)
80105372:	50                   	push   %eax
80105373:	6a 01                	push   $0x1
80105375:	e8 f6 fb ff ff       	call   80104f70 <argptr>
8010537a:	83 c4 10             	add    $0x10,%esp
8010537d:	85 c0                	test   %eax,%eax
8010537f:	78 1f                	js     801053a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105381:	83 ec 04             	sub    $0x4,%esp
80105384:	ff 75 f0             	pushl  -0x10(%ebp)
80105387:	ff 75 f4             	pushl  -0xc(%ebp)
8010538a:	ff 75 ec             	pushl  -0x14(%ebp)
8010538d:	e8 8e bc ff ff       	call   80101020 <filewrite>
80105392:	83 c4 10             	add    $0x10,%esp
}
80105395:	c9                   	leave  
80105396:	c3                   	ret    
80105397:	89 f6                	mov    %esi,%esi
80105399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053a5:	c9                   	leave  
801053a6:	c3                   	ret    
801053a7:	89 f6                	mov    %esi,%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <sys_close>:
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801053b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801053b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053bc:	e8 4f fe ff ff       	call   80105210 <argfd.constprop.0>
801053c1:	85 c0                	test   %eax,%eax
801053c3:	78 2b                	js     801053f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801053c5:	e8 26 e4 ff ff       	call   801037f0 <myproc>
801053ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053d0:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
801053d7:	00 
  fileclose(f);
801053d8:	ff 75 f4             	pushl  -0xc(%ebp)
801053db:	e8 90 ba ff ff       	call   80100e70 <fileclose>
  return 0;
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	31 c0                	xor    %eax,%eax
}
801053e5:	c9                   	leave  
801053e6:	c3                   	ret    
801053e7:	89 f6                	mov    %esi,%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801053f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053f5:	c9                   	leave  
801053f6:	c3                   	ret    
801053f7:	89 f6                	mov    %esi,%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <sys_fstat>:
{
80105400:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105401:	31 c0                	xor    %eax,%eax
{
80105403:	89 e5                	mov    %esp,%ebp
80105405:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105408:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010540b:	e8 00 fe ff ff       	call   80105210 <argfd.constprop.0>
80105410:	85 c0                	test   %eax,%eax
80105412:	78 2c                	js     80105440 <sys_fstat+0x40>
80105414:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105417:	83 ec 04             	sub    $0x4,%esp
8010541a:	6a 14                	push   $0x14
8010541c:	50                   	push   %eax
8010541d:	6a 01                	push   $0x1
8010541f:	e8 4c fb ff ff       	call   80104f70 <argptr>
80105424:	83 c4 10             	add    $0x10,%esp
80105427:	85 c0                	test   %eax,%eax
80105429:	78 15                	js     80105440 <sys_fstat+0x40>
  return filestat(f, st);
8010542b:	83 ec 08             	sub    $0x8,%esp
8010542e:	ff 75 f4             	pushl  -0xc(%ebp)
80105431:	ff 75 f0             	pushl  -0x10(%ebp)
80105434:	e8 07 bb ff ff       	call   80100f40 <filestat>
80105439:	83 c4 10             	add    $0x10,%esp
}
8010543c:	c9                   	leave  
8010543d:	c3                   	ret    
8010543e:	66 90                	xchg   %ax,%ax
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_link>:
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105456:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105459:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010545c:	50                   	push   %eax
8010545d:	6a 00                	push   $0x0
8010545f:	e8 6c fb ff ff       	call   80104fd0 <argstr>
80105464:	83 c4 10             	add    $0x10,%esp
80105467:	85 c0                	test   %eax,%eax
80105469:	0f 88 fb 00 00 00    	js     8010556a <sys_link+0x11a>
8010546f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105472:	83 ec 08             	sub    $0x8,%esp
80105475:	50                   	push   %eax
80105476:	6a 01                	push   $0x1
80105478:	e8 53 fb ff ff       	call   80104fd0 <argstr>
8010547d:	83 c4 10             	add    $0x10,%esp
80105480:	85 c0                	test   %eax,%eax
80105482:	0f 88 e2 00 00 00    	js     8010556a <sys_link+0x11a>
  begin_op();
80105488:	e8 53 d7 ff ff       	call   80102be0 <begin_op>
  if((ip = namei(old)) == 0){
8010548d:	83 ec 0c             	sub    $0xc,%esp
80105490:	ff 75 d4             	pushl  -0x2c(%ebp)
80105493:	e8 78 ca ff ff       	call   80101f10 <namei>
80105498:	83 c4 10             	add    $0x10,%esp
8010549b:	85 c0                	test   %eax,%eax
8010549d:	89 c3                	mov    %eax,%ebx
8010549f:	0f 84 ea 00 00 00    	je     8010558f <sys_link+0x13f>
  ilock(ip);
801054a5:	83 ec 0c             	sub    $0xc,%esp
801054a8:	50                   	push   %eax
801054a9:	e8 02 c2 ff ff       	call   801016b0 <ilock>
  if(ip->type == T_DIR){
801054ae:	83 c4 10             	add    $0x10,%esp
801054b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054b6:	0f 84 bb 00 00 00    	je     80105577 <sys_link+0x127>
  ip->nlink++;
801054bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801054c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801054c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054c7:	53                   	push   %ebx
801054c8:	e8 33 c1 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
801054cd:	89 1c 24             	mov    %ebx,(%esp)
801054d0:	e8 bb c2 ff ff       	call   80101790 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054d5:	58                   	pop    %eax
801054d6:	5a                   	pop    %edx
801054d7:	57                   	push   %edi
801054d8:	ff 75 d0             	pushl  -0x30(%ebp)
801054db:	e8 50 ca ff ff       	call   80101f30 <nameiparent>
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	85 c0                	test   %eax,%eax
801054e5:	89 c6                	mov    %eax,%esi
801054e7:	74 5b                	je     80105544 <sys_link+0xf4>
  ilock(dp);
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	50                   	push   %eax
801054ed:	e8 be c1 ff ff       	call   801016b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	8b 03                	mov    (%ebx),%eax
801054f7:	39 06                	cmp    %eax,(%esi)
801054f9:	75 3d                	jne    80105538 <sys_link+0xe8>
801054fb:	83 ec 04             	sub    $0x4,%esp
801054fe:	ff 73 04             	pushl  0x4(%ebx)
80105501:	57                   	push   %edi
80105502:	56                   	push   %esi
80105503:	e8 48 c9 ff ff       	call   80101e50 <dirlink>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	78 29                	js     80105538 <sys_link+0xe8>
  iunlockput(dp);
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	56                   	push   %esi
80105513:	e8 28 c4 ff ff       	call   80101940 <iunlockput>
  iput(ip);
80105518:	89 1c 24             	mov    %ebx,(%esp)
8010551b:	e8 c0 c2 ff ff       	call   801017e0 <iput>
  end_op();
80105520:	e8 2b d7 ff ff       	call   80102c50 <end_op>
  return 0;
80105525:	83 c4 10             	add    $0x10,%esp
80105528:	31 c0                	xor    %eax,%eax
}
8010552a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552d:	5b                   	pop    %ebx
8010552e:	5e                   	pop    %esi
8010552f:	5f                   	pop    %edi
80105530:	5d                   	pop    %ebp
80105531:	c3                   	ret    
80105532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	56                   	push   %esi
8010553c:	e8 ff c3 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105541:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105544:	83 ec 0c             	sub    $0xc,%esp
80105547:	53                   	push   %ebx
80105548:	e8 63 c1 ff ff       	call   801016b0 <ilock>
  ip->nlink--;
8010554d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105552:	89 1c 24             	mov    %ebx,(%esp)
80105555:	e8 a6 c0 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010555a:	89 1c 24             	mov    %ebx,(%esp)
8010555d:	e8 de c3 ff ff       	call   80101940 <iunlockput>
  end_op();
80105562:	e8 e9 d6 ff ff       	call   80102c50 <end_op>
  return -1;
80105567:	83 c4 10             	add    $0x10,%esp
}
8010556a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010556d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5f                   	pop    %edi
80105575:	5d                   	pop    %ebp
80105576:	c3                   	ret    
    iunlockput(ip);
80105577:	83 ec 0c             	sub    $0xc,%esp
8010557a:	53                   	push   %ebx
8010557b:	e8 c0 c3 ff ff       	call   80101940 <iunlockput>
    end_op();
80105580:	e8 cb d6 ff ff       	call   80102c50 <end_op>
    return -1;
80105585:	83 c4 10             	add    $0x10,%esp
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	eb 9b                	jmp    8010552a <sys_link+0xda>
    end_op();
8010558f:	e8 bc d6 ff ff       	call   80102c50 <end_op>
    return -1;
80105594:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105599:	eb 8f                	jmp    8010552a <sys_link+0xda>
8010559b:	90                   	nop
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_unlink>:
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
801055a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801055a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801055a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801055ac:	50                   	push   %eax
801055ad:	6a 00                	push   $0x0
801055af:	e8 1c fa ff ff       	call   80104fd0 <argstr>
801055b4:	83 c4 10             	add    $0x10,%esp
801055b7:	85 c0                	test   %eax,%eax
801055b9:	0f 88 77 01 00 00    	js     80105736 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801055bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801055c2:	e8 19 d6 ff ff       	call   80102be0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055c7:	83 ec 08             	sub    $0x8,%esp
801055ca:	53                   	push   %ebx
801055cb:	ff 75 c0             	pushl  -0x40(%ebp)
801055ce:	e8 5d c9 ff ff       	call   80101f30 <nameiparent>
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	89 c6                	mov    %eax,%esi
801055da:	0f 84 60 01 00 00    	je     80105740 <sys_unlink+0x1a0>
  ilock(dp);
801055e0:	83 ec 0c             	sub    $0xc,%esp
801055e3:	50                   	push   %eax
801055e4:	e8 c7 c0 ff ff       	call   801016b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055e9:	58                   	pop    %eax
801055ea:	5a                   	pop    %edx
801055eb:	68 40 7f 10 80       	push   $0x80107f40
801055f0:	53                   	push   %ebx
801055f1:	e8 ca c5 ff ff       	call   80101bc0 <namecmp>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	0f 84 03 01 00 00    	je     80105704 <sys_unlink+0x164>
80105601:	83 ec 08             	sub    $0x8,%esp
80105604:	68 3f 7f 10 80       	push   $0x80107f3f
80105609:	53                   	push   %ebx
8010560a:	e8 b1 c5 ff ff       	call   80101bc0 <namecmp>
8010560f:	83 c4 10             	add    $0x10,%esp
80105612:	85 c0                	test   %eax,%eax
80105614:	0f 84 ea 00 00 00    	je     80105704 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010561a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010561d:	83 ec 04             	sub    $0x4,%esp
80105620:	50                   	push   %eax
80105621:	53                   	push   %ebx
80105622:	56                   	push   %esi
80105623:	e8 b8 c5 ff ff       	call   80101be0 <dirlookup>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	85 c0                	test   %eax,%eax
8010562d:	89 c3                	mov    %eax,%ebx
8010562f:	0f 84 cf 00 00 00    	je     80105704 <sys_unlink+0x164>
  ilock(ip);
80105635:	83 ec 0c             	sub    $0xc,%esp
80105638:	50                   	push   %eax
80105639:	e8 72 c0 ff ff       	call   801016b0 <ilock>
  if(ip->nlink < 1)
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105646:	0f 8e 10 01 00 00    	jle    8010575c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010564c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105651:	74 6d                	je     801056c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105653:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105656:	83 ec 04             	sub    $0x4,%esp
80105659:	6a 10                	push   $0x10
8010565b:	6a 00                	push   $0x0
8010565d:	50                   	push   %eax
8010565e:	e8 bd f5 ff ff       	call   80104c20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105663:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105666:	6a 10                	push   $0x10
80105668:	ff 75 c4             	pushl  -0x3c(%ebp)
8010566b:	50                   	push   %eax
8010566c:	56                   	push   %esi
8010566d:	e8 1e c4 ff ff       	call   80101a90 <writei>
80105672:	83 c4 20             	add    $0x20,%esp
80105675:	83 f8 10             	cmp    $0x10,%eax
80105678:	0f 85 eb 00 00 00    	jne    80105769 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010567e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105683:	0f 84 97 00 00 00    	je     80105720 <sys_unlink+0x180>
  iunlockput(dp);
80105689:	83 ec 0c             	sub    $0xc,%esp
8010568c:	56                   	push   %esi
8010568d:	e8 ae c2 ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80105692:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105697:	89 1c 24             	mov    %ebx,(%esp)
8010569a:	e8 61 bf ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010569f:	89 1c 24             	mov    %ebx,(%esp)
801056a2:	e8 99 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
801056a7:	e8 a4 d5 ff ff       	call   80102c50 <end_op>
  return 0;
801056ac:	83 c4 10             	add    $0x10,%esp
801056af:	31 c0                	xor    %eax,%eax
}
801056b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b4:	5b                   	pop    %ebx
801056b5:	5e                   	pop    %esi
801056b6:	5f                   	pop    %edi
801056b7:	5d                   	pop    %ebp
801056b8:	c3                   	ret    
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056c4:	76 8d                	jbe    80105653 <sys_unlink+0xb3>
801056c6:	bf 20 00 00 00       	mov    $0x20,%edi
801056cb:	eb 0f                	jmp    801056dc <sys_unlink+0x13c>
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
801056d0:	83 c7 10             	add    $0x10,%edi
801056d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801056d6:	0f 83 77 ff ff ff    	jae    80105653 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056df:	6a 10                	push   $0x10
801056e1:	57                   	push   %edi
801056e2:	50                   	push   %eax
801056e3:	53                   	push   %ebx
801056e4:	e8 a7 c2 ff ff       	call   80101990 <readi>
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	83 f8 10             	cmp    $0x10,%eax
801056ef:	75 5e                	jne    8010574f <sys_unlink+0x1af>
    if(de.inum != 0)
801056f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056f6:	74 d8                	je     801056d0 <sys_unlink+0x130>
    iunlockput(ip);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	53                   	push   %ebx
801056fc:	e8 3f c2 ff ff       	call   80101940 <iunlockput>
    goto bad;
80105701:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	56                   	push   %esi
80105708:	e8 33 c2 ff ff       	call   80101940 <iunlockput>
  end_op();
8010570d:	e8 3e d5 ff ff       	call   80102c50 <end_op>
  return -1;
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010571a:	eb 95                	jmp    801056b1 <sys_unlink+0x111>
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105720:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105725:	83 ec 0c             	sub    $0xc,%esp
80105728:	56                   	push   %esi
80105729:	e8 d2 be ff ff       	call   80101600 <iupdate>
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	e9 53 ff ff ff       	jmp    80105689 <sys_unlink+0xe9>
    return -1;
80105736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573b:	e9 71 ff ff ff       	jmp    801056b1 <sys_unlink+0x111>
    end_op();
80105740:	e8 0b d5 ff ff       	call   80102c50 <end_op>
    return -1;
80105745:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574a:	e9 62 ff ff ff       	jmp    801056b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010574f:	83 ec 0c             	sub    $0xc,%esp
80105752:	68 64 7f 10 80       	push   $0x80107f64
80105757:	e8 34 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	68 52 7f 10 80       	push   $0x80107f52
80105764:	e8 27 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105769:	83 ec 0c             	sub    $0xc,%esp
8010576c:	68 76 7f 10 80       	push   $0x80107f76
80105771:	e8 1a ac ff ff       	call   80100390 <panic>
80105776:	8d 76 00             	lea    0x0(%esi),%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105780 <sys_open>:

int
sys_open(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	57                   	push   %edi
80105784:	56                   	push   %esi
80105785:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105786:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105789:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010578c:	50                   	push   %eax
8010578d:	6a 00                	push   $0x0
8010578f:	e8 3c f8 ff ff       	call   80104fd0 <argstr>
80105794:	83 c4 10             	add    $0x10,%esp
80105797:	85 c0                	test   %eax,%eax
80105799:	0f 88 1d 01 00 00    	js     801058bc <sys_open+0x13c>
8010579f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057a2:	83 ec 08             	sub    $0x8,%esp
801057a5:	50                   	push   %eax
801057a6:	6a 01                	push   $0x1
801057a8:	e8 73 f7 ff ff       	call   80104f20 <argint>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	0f 88 04 01 00 00    	js     801058bc <sys_open+0x13c>
    return -1;

  begin_op();
801057b8:	e8 23 d4 ff ff       	call   80102be0 <begin_op>

  if(omode & O_CREATE){
801057bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057c1:	0f 85 a9 00 00 00    	jne    80105870 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057c7:	83 ec 0c             	sub    $0xc,%esp
801057ca:	ff 75 e0             	pushl  -0x20(%ebp)
801057cd:	e8 3e c7 ff ff       	call   80101f10 <namei>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	89 c6                	mov    %eax,%esi
801057d9:	0f 84 b2 00 00 00    	je     80105891 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801057df:	83 ec 0c             	sub    $0xc,%esp
801057e2:	50                   	push   %eax
801057e3:	e8 c8 be ff ff       	call   801016b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057f0:	0f 84 aa 00 00 00    	je     801058a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057f6:	e8 b5 b5 ff ff       	call   80100db0 <filealloc>
801057fb:	85 c0                	test   %eax,%eax
801057fd:	89 c7                	mov    %eax,%edi
801057ff:	0f 84 a6 00 00 00    	je     801058ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105805:	e8 e6 df ff ff       	call   801037f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010580a:	31 db                	xor    %ebx,%ebx
8010580c:	eb 0e                	jmp    8010581c <sys_open+0x9c>
8010580e:	66 90                	xchg   %ax,%ax
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	0f 84 ac 00 00 00    	je     801058c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010581c:	8b 54 98 2c          	mov    0x2c(%eax,%ebx,4),%edx
80105820:	85 d2                	test   %edx,%edx
80105822:	75 ec                	jne    80105810 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105824:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105827:	89 7c 98 2c          	mov    %edi,0x2c(%eax,%ebx,4)
  iunlock(ip);
8010582b:	56                   	push   %esi
8010582c:	e8 5f bf ff ff       	call   80101790 <iunlock>
  end_op();
80105831:	e8 1a d4 ff ff       	call   80102c50 <end_op>

  f->type = FD_INODE;
80105836:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010583c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010583f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105842:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105845:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010584c:	89 d0                	mov    %edx,%eax
8010584e:	f7 d0                	not    %eax
80105850:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105853:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105856:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105859:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010585d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105860:	89 d8                	mov    %ebx,%eax
80105862:	5b                   	pop    %ebx
80105863:	5e                   	pop    %esi
80105864:	5f                   	pop    %edi
80105865:	5d                   	pop    %ebp
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105876:	31 c9                	xor    %ecx,%ecx
80105878:	6a 00                	push   $0x0
8010587a:	ba 02 00 00 00       	mov    $0x2,%edx
8010587f:	e8 ec f7 ff ff       	call   80105070 <create>
    if(ip == 0){
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105889:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010588b:	0f 85 65 ff ff ff    	jne    801057f6 <sys_open+0x76>
      end_op();
80105891:	e8 ba d3 ff ff       	call   80102c50 <end_op>
      return -1;
80105896:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010589b:	eb c0                	jmp    8010585d <sys_open+0xdd>
8010589d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801058a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801058a3:	85 c9                	test   %ecx,%ecx
801058a5:	0f 84 4b ff ff ff    	je     801057f6 <sys_open+0x76>
    iunlockput(ip);
801058ab:	83 ec 0c             	sub    $0xc,%esp
801058ae:	56                   	push   %esi
801058af:	e8 8c c0 ff ff       	call   80101940 <iunlockput>
    end_op();
801058b4:	e8 97 d3 ff ff       	call   80102c50 <end_op>
    return -1;
801058b9:	83 c4 10             	add    $0x10,%esp
801058bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c1:	eb 9a                	jmp    8010585d <sys_open+0xdd>
801058c3:	90                   	nop
801058c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801058c8:	83 ec 0c             	sub    $0xc,%esp
801058cb:	57                   	push   %edi
801058cc:	e8 9f b5 ff ff       	call   80100e70 <fileclose>
801058d1:	83 c4 10             	add    $0x10,%esp
801058d4:	eb d5                	jmp    801058ab <sys_open+0x12b>
801058d6:	8d 76 00             	lea    0x0(%esi),%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058e6:	e8 f5 d2 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ee:	83 ec 08             	sub    $0x8,%esp
801058f1:	50                   	push   %eax
801058f2:	6a 00                	push   $0x0
801058f4:	e8 d7 f6 ff ff       	call   80104fd0 <argstr>
801058f9:	83 c4 10             	add    $0x10,%esp
801058fc:	85 c0                	test   %eax,%eax
801058fe:	78 30                	js     80105930 <sys_mkdir+0x50>
80105900:	83 ec 0c             	sub    $0xc,%esp
80105903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105906:	31 c9                	xor    %ecx,%ecx
80105908:	6a 00                	push   $0x0
8010590a:	ba 01 00 00 00       	mov    $0x1,%edx
8010590f:	e8 5c f7 ff ff       	call   80105070 <create>
80105914:	83 c4 10             	add    $0x10,%esp
80105917:	85 c0                	test   %eax,%eax
80105919:	74 15                	je     80105930 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010591b:	83 ec 0c             	sub    $0xc,%esp
8010591e:	50                   	push   %eax
8010591f:	e8 1c c0 ff ff       	call   80101940 <iunlockput>
  end_op();
80105924:	e8 27 d3 ff ff       	call   80102c50 <end_op>
  return 0;
80105929:	83 c4 10             	add    $0x10,%esp
8010592c:	31 c0                	xor    %eax,%eax
}
8010592e:	c9                   	leave  
8010592f:	c3                   	ret    
    end_op();
80105930:	e8 1b d3 ff ff       	call   80102c50 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010593a:	c9                   	leave  
8010593b:	c3                   	ret    
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_mknod>:

int
sys_mknod(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105946:	e8 95 d2 ff ff       	call   80102be0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010594b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010594e:	83 ec 08             	sub    $0x8,%esp
80105951:	50                   	push   %eax
80105952:	6a 00                	push   $0x0
80105954:	e8 77 f6 ff ff       	call   80104fd0 <argstr>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	85 c0                	test   %eax,%eax
8010595e:	78 60                	js     801059c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105960:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105963:	83 ec 08             	sub    $0x8,%esp
80105966:	50                   	push   %eax
80105967:	6a 01                	push   $0x1
80105969:	e8 b2 f5 ff ff       	call   80104f20 <argint>
  if((argstr(0, &path)) < 0 ||
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	85 c0                	test   %eax,%eax
80105973:	78 4b                	js     801059c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105975:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105978:	83 ec 08             	sub    $0x8,%esp
8010597b:	50                   	push   %eax
8010597c:	6a 02                	push   $0x2
8010597e:	e8 9d f5 ff ff       	call   80104f20 <argint>
     argint(1, &major) < 0 ||
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	85 c0                	test   %eax,%eax
80105988:	78 36                	js     801059c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010598a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010598e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105991:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105995:	ba 03 00 00 00       	mov    $0x3,%edx
8010599a:	50                   	push   %eax
8010599b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010599e:	e8 cd f6 ff ff       	call   80105070 <create>
801059a3:	83 c4 10             	add    $0x10,%esp
801059a6:	85 c0                	test   %eax,%eax
801059a8:	74 16                	je     801059c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059aa:	83 ec 0c             	sub    $0xc,%esp
801059ad:	50                   	push   %eax
801059ae:	e8 8d bf ff ff       	call   80101940 <iunlockput>
  end_op();
801059b3:	e8 98 d2 ff ff       	call   80102c50 <end_op>
  return 0;
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	31 c0                	xor    %eax,%eax
}
801059bd:	c9                   	leave  
801059be:	c3                   	ret    
801059bf:	90                   	nop
    end_op();
801059c0:	e8 8b d2 ff ff       	call   80102c50 <end_op>
    return -1;
801059c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059ca:	c9                   	leave  
801059cb:	c3                   	ret    
801059cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059d0 <sys_chdir>:

int
sys_chdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
801059d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059d8:	e8 13 de ff ff       	call   801037f0 <myproc>
801059dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059df:	e8 fc d1 ff ff       	call   80102be0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059e7:	83 ec 08             	sub    $0x8,%esp
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 de f5 ff ff       	call   80104fd0 <argstr>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 77                	js     80105a70 <sys_chdir+0xa0>
801059f9:	83 ec 0c             	sub    $0xc,%esp
801059fc:	ff 75 f4             	pushl  -0xc(%ebp)
801059ff:	e8 0c c5 ff ff       	call   80101f10 <namei>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	89 c3                	mov    %eax,%ebx
80105a0b:	74 63                	je     80105a70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	50                   	push   %eax
80105a11:	e8 9a bc ff ff       	call   801016b0 <ilock>
  if(ip->type != T_DIR){
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a1e:	75 30                	jne    80105a50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	53                   	push   %ebx
80105a24:	e8 67 bd ff ff       	call   80101790 <iunlock>
  iput(curproc->cwd);
80105a29:	58                   	pop    %eax
80105a2a:	ff 76 6c             	pushl  0x6c(%esi)
80105a2d:	e8 ae bd ff ff       	call   801017e0 <iput>
  end_op();
80105a32:	e8 19 d2 ff ff       	call   80102c50 <end_op>
  curproc->cwd = ip;
80105a37:	89 5e 6c             	mov    %ebx,0x6c(%esi)
  return 0;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	31 c0                	xor    %eax,%eax
}
80105a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a42:	5b                   	pop    %ebx
80105a43:	5e                   	pop    %esi
80105a44:	5d                   	pop    %ebp
80105a45:	c3                   	ret    
80105a46:	8d 76 00             	lea    0x0(%esi),%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105a50:	83 ec 0c             	sub    $0xc,%esp
80105a53:	53                   	push   %ebx
80105a54:	e8 e7 be ff ff       	call   80101940 <iunlockput>
    end_op();
80105a59:	e8 f2 d1 ff ff       	call   80102c50 <end_op>
    return -1;
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a66:	eb d7                	jmp    80105a3f <sys_chdir+0x6f>
80105a68:	90                   	nop
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105a70:	e8 db d1 ff ff       	call   80102c50 <end_op>
    return -1;
80105a75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7a:	eb c3                	jmp    80105a3f <sys_chdir+0x6f>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <sys_exec>:

int
sys_exec(void)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
80105a85:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a86:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a92:	50                   	push   %eax
80105a93:	6a 00                	push   $0x0
80105a95:	e8 36 f5 ff ff       	call   80104fd0 <argstr>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	0f 88 87 00 00 00    	js     80105b2c <sys_exec+0xac>
80105aa5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105aab:	83 ec 08             	sub    $0x8,%esp
80105aae:	50                   	push   %eax
80105aaf:	6a 01                	push   $0x1
80105ab1:	e8 6a f4 ff ff       	call   80104f20 <argint>
80105ab6:	83 c4 10             	add    $0x10,%esp
80105ab9:	85 c0                	test   %eax,%eax
80105abb:	78 6f                	js     80105b2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105abd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ac3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ac6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ac8:	68 80 00 00 00       	push   $0x80
80105acd:	6a 00                	push   $0x0
80105acf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ad5:	50                   	push   %eax
80105ad6:	e8 45 f1 ff ff       	call   80104c20 <memset>
80105adb:	83 c4 10             	add    $0x10,%esp
80105ade:	eb 2c                	jmp    80105b0c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105ae0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105ae6:	85 c0                	test   %eax,%eax
80105ae8:	74 56                	je     80105b40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105aea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105af0:	83 ec 08             	sub    $0x8,%esp
80105af3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105af6:	52                   	push   %edx
80105af7:	50                   	push   %eax
80105af8:	e8 b3 f3 ff ff       	call   80104eb0 <fetchstr>
80105afd:	83 c4 10             	add    $0x10,%esp
80105b00:	85 c0                	test   %eax,%eax
80105b02:	78 28                	js     80105b2c <sys_exec+0xac>
  for(i=0;; i++){
80105b04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b07:	83 fb 20             	cmp    $0x20,%ebx
80105b0a:	74 20                	je     80105b2c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b0c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b12:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105b19:	83 ec 08             	sub    $0x8,%esp
80105b1c:	57                   	push   %edi
80105b1d:	01 f0                	add    %esi,%eax
80105b1f:	50                   	push   %eax
80105b20:	e8 4b f3 ff ff       	call   80104e70 <fetchint>
80105b25:	83 c4 10             	add    $0x10,%esp
80105b28:	85 c0                	test   %eax,%eax
80105b2a:	79 b4                	jns    80105ae0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b34:	5b                   	pop    %ebx
80105b35:	5e                   	pop    %esi
80105b36:	5f                   	pop    %edi
80105b37:	5d                   	pop    %ebp
80105b38:	c3                   	ret    
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b46:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105b49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b50:	00 00 00 00 
  return exec(path, argv);
80105b54:	50                   	push   %eax
80105b55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b5b:	e8 b0 ae ff ff       	call   80100a10 <exec>
80105b60:	83 c4 10             	add    $0x10,%esp
}
80105b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	90                   	nop
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_pipe>:

int
sys_pipe(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b76:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b7c:	6a 08                	push   $0x8
80105b7e:	50                   	push   %eax
80105b7f:	6a 00                	push   $0x0
80105b81:	e8 ea f3 ff ff       	call   80104f70 <argptr>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	0f 88 ae 00 00 00    	js     80105c3f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b94:	83 ec 08             	sub    $0x8,%esp
80105b97:	50                   	push   %eax
80105b98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b9b:	50                   	push   %eax
80105b9c:	e8 df d6 ff ff       	call   80103280 <pipealloc>
80105ba1:	83 c4 10             	add    $0x10,%esp
80105ba4:	85 c0                	test   %eax,%eax
80105ba6:	0f 88 93 00 00 00    	js     80105c3f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105baf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105bb1:	e8 3a dc ff ff       	call   801037f0 <myproc>
80105bb6:	eb 10                	jmp    80105bc8 <sys_pipe+0x58>
80105bb8:	90                   	nop
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105bc0:	83 c3 01             	add    $0x1,%ebx
80105bc3:	83 fb 10             	cmp    $0x10,%ebx
80105bc6:	74 60                	je     80105c28 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105bc8:	8b 74 98 2c          	mov    0x2c(%eax,%ebx,4),%esi
80105bcc:	85 f6                	test   %esi,%esi
80105bce:	75 f0                	jne    80105bc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105bd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105bd3:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bda:	e8 11 dc ff ff       	call   801037f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bdf:	31 d2                	xor    %edx,%edx
80105be1:	eb 0d                	jmp    80105bf0 <sys_pipe+0x80>
80105be3:	90                   	nop
80105be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be8:	83 c2 01             	add    $0x1,%edx
80105beb:	83 fa 10             	cmp    $0x10,%edx
80105bee:	74 28                	je     80105c18 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105bf0:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80105bf4:	85 c9                	test   %ecx,%ecx
80105bf6:	75 f0                	jne    80105be8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105bf8:	89 7c 90 2c          	mov    %edi,0x2c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105bfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105bff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c07:	31 c0                	xor    %eax,%eax
}
80105c09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c0c:	5b                   	pop    %ebx
80105c0d:	5e                   	pop    %esi
80105c0e:	5f                   	pop    %edi
80105c0f:	5d                   	pop    %ebp
80105c10:	c3                   	ret    
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105c18:	e8 d3 db ff ff       	call   801037f0 <myproc>
80105c1d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105c24:	00 
80105c25:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105c2e:	e8 3d b2 ff ff       	call   80100e70 <fileclose>
    fileclose(wf);
80105c33:	58                   	pop    %eax
80105c34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c37:	e8 34 b2 ff ff       	call   80100e70 <fileclose>
    return -1;
80105c3c:	83 c4 10             	add    $0x10,%esp
80105c3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c44:	eb c3                	jmp    80105c09 <sys_pipe+0x99>
80105c46:	66 90                	xchg   %ax,%ax
80105c48:	66 90                	xchg   %ax,%ax
80105c4a:	66 90                	xchg   %ax,%ax
80105c4c:	66 90                	xchg   %ax,%ax
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105c53:	5d                   	pop    %ebp
  return fork();
80105c54:	e9 77 de ff ff       	jmp    80103ad0 <fork>
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_exit>:

int
sys_exit(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c66:	e8 85 e0 ff ff       	call   80103cf0 <exit>
  return 0;  // not reached
}
80105c6b:	31 c0                	xor    %eax,%eax
80105c6d:	c9                   	leave  
80105c6e:	c3                   	ret    
80105c6f:	90                   	nop

80105c70 <sys_wait>:

int
sys_wait(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105c73:	5d                   	pop    %ebp
  return wait();
80105c74:	e9 97 e1 ff ff       	jmp    80103e10 <wait>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_kill>:

int
sys_kill(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
80105c86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 8f f2 ff ff       	call   80104f20 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 28                	js     80105cc0 <sys_kill+0x40>
    return -1;
  if(argint(1, &signum) < 0)
80105c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9b:	83 ec 08             	sub    $0x8,%esp
80105c9e:	50                   	push   %eax
80105c9f:	6a 01                	push   $0x1
80105ca1:	e8 7a f2 ff ff       	call   80104f20 <argint>
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	78 13                	js     80105cc0 <sys_kill+0x40>
    return -1;
  return kill(pid,signum);
80105cad:	83 ec 08             	sub    $0x8,%esp
80105cb0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cb3:	ff 75 f0             	pushl  -0x10(%ebp)
80105cb6:	e8 75 e4 ff ff       	call   80104130 <kill>
80105cbb:	83 c4 10             	add    $0x10,%esp
}
80105cbe:	c9                   	leave  
80105cbf:	c3                   	ret    
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
80105cc7:	89 f6                	mov    %esi,%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cd0 <sys_getpid>:

int
sys_getpid(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cd6:	e8 15 db ff ff       	call   801037f0 <myproc>
80105cdb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cde:	c9                   	leave  
80105cdf:	c3                   	ret    

80105ce0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ce7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cea:	50                   	push   %eax
80105ceb:	6a 00                	push   $0x0
80105ced:	e8 2e f2 ff ff       	call   80104f20 <argint>
80105cf2:	83 c4 10             	add    $0x10,%esp
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	78 27                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cf9:	e8 f2 da ff ff       	call   801037f0 <myproc>
  if(growproc(n) < 0)
80105cfe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d03:	ff 75 f4             	pushl  -0xc(%ebp)
80105d06:	e8 45 dd ff ff       	call   80103a50 <growproc>
80105d0b:	83 c4 10             	add    $0x10,%esp
80105d0e:	85 c0                	test   %eax,%eax
80105d10:	78 0e                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d12:	89 d8                	mov    %ebx,%eax
80105d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d17:	c9                   	leave  
80105d18:	c3                   	ret    
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d25:	eb eb                	jmp    80105d12 <sys_sbrk+0x32>
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d30 <sys_sleep>:

int
sys_sleep(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d3a:	50                   	push   %eax
80105d3b:	6a 00                	push   $0x0
80105d3d:	e8 de f1 ff ff       	call   80104f20 <argint>
80105d42:	83 c4 10             	add    $0x10,%esp
80105d45:	85 c0                	test   %eax,%eax
80105d47:	0f 88 8a 00 00 00    	js     80105dd7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 60 a1 11 80       	push   $0x8011a160
80105d55:	e8 b6 ed ff ff       	call   80104b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d5d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105d60:	8b 1d a0 a9 11 80    	mov    0x8011a9a0,%ebx
  while(ticks - ticks0 < n){
80105d66:	85 d2                	test   %edx,%edx
80105d68:	75 27                	jne    80105d91 <sys_sleep+0x61>
80105d6a:	eb 54                	jmp    80105dc0 <sys_sleep+0x90>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	68 60 a1 11 80       	push   $0x8011a160
80105d78:	68 a0 a9 11 80       	push   $0x8011a9a0
80105d7d:	e8 ae e2 ff ff       	call   80104030 <sleep>
  while(ticks - ticks0 < n){
80105d82:	a1 a0 a9 11 80       	mov    0x8011a9a0,%eax
80105d87:	83 c4 10             	add    $0x10,%esp
80105d8a:	29 d8                	sub    %ebx,%eax
80105d8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d8f:	73 2f                	jae    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d91:	e8 5a da ff ff       	call   801037f0 <myproc>
80105d96:	8b 40 24             	mov    0x24(%eax),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 d3                	je     80105d70 <sys_sleep+0x40>
      release(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 60 a1 11 80       	push   $0x8011a160
80105da5:	e8 26 ee ff ff       	call   80104bd0 <release>
      return -1;
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
80105db7:	89 f6                	mov    %esi,%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	68 60 a1 11 80       	push   $0x8011a160
80105dc8:	e8 03 ee ff ff       	call   80104bd0 <release>
  return 0;
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	31 c0                	xor    %eax,%eax
}
80105dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb f4                	jmp    80105dd2 <sys_sleep+0xa2>
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	53                   	push   %ebx
80105de4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105de7:	68 60 a1 11 80       	push   $0x8011a160
80105dec:	e8 1f ed ff ff       	call   80104b10 <acquire>
  xticks = ticks;
80105df1:	8b 1d a0 a9 11 80    	mov    0x8011a9a0,%ebx
  release(&tickslock);
80105df7:	c7 04 24 60 a1 11 80 	movl   $0x8011a160,(%esp)
80105dfe:	e8 cd ed ff ff       	call   80104bd0 <release>
  return xticks;
}
80105e03:	89 d8                	mov    %ebx,%eax
80105e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e08:	c9                   	leave  
80105e09:	c3                   	ret    
80105e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e10 <sys_sigprocmask>:

int
sys_sigprocmask(void){
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	83 ec 20             	sub    $0x20,%esp
  int sigmask;
  if(argint(0, &sigmask) < 0)
80105e16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e19:	50                   	push   %eax
80105e1a:	6a 00                	push   $0x0
80105e1c:	e8 ff f0 ff ff       	call   80104f20 <argint>
80105e21:	83 c4 10             	add    $0x10,%esp
80105e24:	85 c0                	test   %eax,%eax
80105e26:	78 18                	js     80105e40 <sys_sigprocmask+0x30>
    return -1;
  return sigprocmask((uint)sigmask);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	ff 75 f4             	pushl  -0xc(%ebp)
80105e2e:	e8 bd e4 ff ff       	call   801042f0 <sigprocmask>
80105e33:	83 c4 10             	add    $0x10,%esp
}
80105e36:	c9                   	leave  
80105e37:	c3                   	ret    
80105e38:	90                   	nop
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e45:	c9                   	leave  
80105e46:	c3                   	ret    
80105e47:	89 f6                	mov    %esi,%esi
80105e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e50 <sys_sigaction>:

int
sys_sigaction(void){
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 20             	sub    $0x20,%esp
  int signum;
  struct sigaction* act;
  struct sigaction* oldact;

  if(argint(0, &signum) < 0)
80105e56:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e59:	50                   	push   %eax
80105e5a:	6a 00                	push   $0x0
80105e5c:	e8 bf f0 ff ff       	call   80104f20 <argint>
80105e61:	83 c4 10             	add    $0x10,%esp
80105e64:	85 c0                	test   %eax,%eax
80105e66:	78 58                	js     80105ec0 <sys_sigaction+0x70>
    return -1;
    
  if(signum==SIGKILL||signum==SIGSTOP||signum<0||signum>=SIGNAL_HANDLERS_SIZE)
80105e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e6b:	8d 50 f7             	lea    -0x9(%eax),%edx
80105e6e:	83 e2 f7             	and    $0xfffffff7,%edx
80105e71:	74 4d                	je     80105ec0 <sys_sigaction+0x70>
80105e73:	83 f8 1f             	cmp    $0x1f,%eax
80105e76:	77 48                	ja     80105ec0 <sys_sigaction+0x70>
    return -1;

  if(argptr(1 , (void*)&act ,sizeof(*sigaction)) < 0){
80105e78:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e7b:	83 ec 04             	sub    $0x4,%esp
80105e7e:	6a 01                	push   $0x1
80105e80:	50                   	push   %eax
80105e81:	6a 01                	push   $0x1
80105e83:	e8 e8 f0 ff ff       	call   80104f70 <argptr>
80105e88:	83 c4 10             	add    $0x10,%esp
80105e8b:	85 c0                	test   %eax,%eax
80105e8d:	78 31                	js     80105ec0 <sys_sigaction+0x70>
    return -1;
  }
  if(argptr(2 , (void*)&oldact ,sizeof(*sigaction)) < 0){
80105e8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e92:	83 ec 04             	sub    $0x4,%esp
80105e95:	6a 01                	push   $0x1
80105e97:	50                   	push   %eax
80105e98:	6a 02                	push   $0x2
80105e9a:	e8 d1 f0 ff ff       	call   80104f70 <argptr>
80105e9f:	83 c4 10             	add    $0x10,%esp
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	78 1a                	js     80105ec0 <sys_sigaction+0x70>
    return -1;
  }

  return sigaction(signum, act, oldact);
80105ea6:	83 ec 04             	sub    $0x4,%esp
80105ea9:	ff 75 f4             	pushl  -0xc(%ebp)
80105eac:	ff 75 f0             	pushl  -0x10(%ebp)
80105eaf:	ff 75 ec             	pushl  -0x14(%ebp)
80105eb2:	e8 89 e4 ff ff       	call   80104340 <sigaction>
80105eb7:	83 c4 10             	add    $0x10,%esp
}
80105eba:	c9                   	leave  
80105ebb:	c3                   	ret    
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ec5:	c9                   	leave  
80105ec6:	c3                   	ret    
80105ec7:	89 f6                	mov    %esi,%esi
80105ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ed0 <sys_sigret>:

int 
sys_sigret(void){
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 08             	sub    $0x8,%esp
  sigret();
80105ed6:	e8 65 e7 ff ff       	call   80104640 <sigret>
  return 0;
80105edb:	31 c0                	xor    %eax,%eax
80105edd:	c9                   	leave  
80105ede:	c3                   	ret    

80105edf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105edf:	1e                   	push   %ds
  pushl %es
80105ee0:	06                   	push   %es
  pushl %fs
80105ee1:	0f a0                	push   %fs
  pushl %gs
80105ee3:	0f a8                	push   %gs
  pushal
80105ee5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105ee6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105eea:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105eec:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105eee:	54                   	push   %esp
  call trap
80105eef:	e8 cc 00 00 00       	call   80105fc0 <trap>
  addl $4, %esp
80105ef4:	83 c4 04             	add    $0x4,%esp

80105ef7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  pushl %esp
80105ef7:	54                   	push   %esp
  call handle_signals
80105ef8:	e8 d3 e7 ff ff       	call   801046d0 <handle_signals>
  addl $4, %esp
80105efd:	83 c4 04             	add    $0x4,%esp
  popal
80105f00:	61                   	popa   
  popl %gs
80105f01:	0f a9                	pop    %gs
  popl %fs
80105f03:	0f a1                	pop    %fs
  popl %es
80105f05:	07                   	pop    %es
  popl %ds
80105f06:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f07:	83 c4 08             	add    $0x8,%esp
  iret
80105f0a:	cf                   	iret   
80105f0b:	66 90                	xchg   %ax,%ax
80105f0d:	66 90                	xchg   %ax,%ax
80105f0f:	90                   	nop

80105f10 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f10:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f11:	31 c0                	xor    %eax,%eax
{
80105f13:	89 e5                	mov    %esp,%ebp
80105f15:	83 ec 08             	sub    $0x8,%esp
80105f18:	90                   	nop
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f20:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f27:	c7 04 c5 a2 a1 11 80 	movl   $0x8e000008,-0x7fee5e5e(,%eax,8)
80105f2e:	08 00 00 8e 
80105f32:	66 89 14 c5 a0 a1 11 	mov    %dx,-0x7fee5e60(,%eax,8)
80105f39:	80 
80105f3a:	c1 ea 10             	shr    $0x10,%edx
80105f3d:	66 89 14 c5 a6 a1 11 	mov    %dx,-0x7fee5e5a(,%eax,8)
80105f44:	80 
  for(i = 0; i < 256; i++)
80105f45:	83 c0 01             	add    $0x1,%eax
80105f48:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f4d:	75 d1                	jne    80105f20 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f4f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f54:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f57:	c7 05 a2 a3 11 80 08 	movl   $0xef000008,0x8011a3a2
80105f5e:	00 00 ef 
  initlock(&tickslock, "time");
80105f61:	68 85 7f 10 80       	push   $0x80107f85
80105f66:	68 60 a1 11 80       	push   $0x8011a160
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f6b:	66 a3 a0 a3 11 80    	mov    %ax,0x8011a3a0
80105f71:	c1 e8 10             	shr    $0x10,%eax
80105f74:	66 a3 a6 a3 11 80    	mov    %ax,0x8011a3a6
  initlock(&tickslock, "time");
80105f7a:	e8 51 ea ff ff       	call   801049d0 <initlock>
}
80105f7f:	83 c4 10             	add    $0x10,%esp
80105f82:	c9                   	leave  
80105f83:	c3                   	ret    
80105f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105f90 <idtinit>:

void
idtinit(void)
{
80105f90:	55                   	push   %ebp
  pd[0] = size-1;
80105f91:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f96:	89 e5                	mov    %esp,%ebp
80105f98:	83 ec 10             	sub    $0x10,%esp
80105f9b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f9f:	b8 a0 a1 11 80       	mov    $0x8011a1a0,%eax
80105fa4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fa8:	c1 e8 10             	shr    $0x10,%eax
80105fab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105faf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fb2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fb5:	c9                   	leave  
80105fb6:	c3                   	ret    
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fc0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	57                   	push   %edi
80105fc4:	56                   	push   %esi
80105fc5:	53                   	push   %ebx
80105fc6:	83 ec 1c             	sub    $0x1c,%esp
80105fc9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105fcc:	8b 47 30             	mov    0x30(%edi),%eax
80105fcf:	83 f8 40             	cmp    $0x40,%eax
80105fd2:	0f 84 f0 00 00 00    	je     801060c8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105fd8:	83 e8 20             	sub    $0x20,%eax
80105fdb:	83 f8 1f             	cmp    $0x1f,%eax
80105fde:	77 10                	ja     80105ff0 <trap+0x30>
80105fe0:	ff 24 85 2c 80 10 80 	jmp    *-0x7fef7fd4(,%eax,4)
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ff0:	e8 fb d7 ff ff       	call   801037f0 <myproc>
80105ff5:	85 c0                	test   %eax,%eax
80105ff7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105ffa:	0f 84 14 02 00 00    	je     80106214 <trap+0x254>
80106000:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106004:	0f 84 0a 02 00 00    	je     80106214 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010600a:	0f 20 d1             	mov    %cr2,%ecx
8010600d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106010:	e8 bb d7 ff ff       	call   801037d0 <cpuid>
80106015:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106018:	8b 47 34             	mov    0x34(%edi),%eax
8010601b:	8b 77 30             	mov    0x30(%edi),%esi
8010601e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106021:	e8 ca d7 ff ff       	call   801037f0 <myproc>
80106026:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106029:	e8 c2 d7 ff ff       	call   801037f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010602e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106031:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106034:	51                   	push   %ecx
80106035:	53                   	push   %ebx
80106036:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106037:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010603a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010603d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010603e:	83 c2 70             	add    $0x70,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106041:	52                   	push   %edx
80106042:	ff 70 10             	pushl  0x10(%eax)
80106045:	68 e8 7f 10 80       	push   $0x80107fe8
8010604a:	e8 11 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010604f:	83 c4 20             	add    $0x20,%esp
80106052:	e8 99 d7 ff ff       	call   801037f0 <myproc>
80106057:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010605e:	e8 8d d7 ff ff       	call   801037f0 <myproc>
80106063:	85 c0                	test   %eax,%eax
80106065:	74 1d                	je     80106084 <trap+0xc4>
80106067:	e8 84 d7 ff ff       	call   801037f0 <myproc>
8010606c:	8b 50 24             	mov    0x24(%eax),%edx
8010606f:	85 d2                	test   %edx,%edx
80106071:	74 11                	je     80106084 <trap+0xc4>
80106073:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106077:	83 e0 03             	and    $0x3,%eax
8010607a:	66 83 f8 03          	cmp    $0x3,%ax
8010607e:	0f 84 4c 01 00 00    	je     801061d0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106084:	e8 67 d7 ff ff       	call   801037f0 <myproc>
80106089:	85 c0                	test   %eax,%eax
8010608b:	74 0d                	je     8010609a <trap+0xda>
8010608d:	e8 5e d7 ff ff       	call   801037f0 <myproc>
80106092:	8b 40 0c             	mov    0xc(%eax),%eax
80106095:	83 f8 04             	cmp    $0x4,%eax
80106098:	74 66                	je     80106100 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010609a:	e8 51 d7 ff ff       	call   801037f0 <myproc>
8010609f:	85 c0                	test   %eax,%eax
801060a1:	74 19                	je     801060bc <trap+0xfc>
801060a3:	e8 48 d7 ff ff       	call   801037f0 <myproc>
801060a8:	8b 40 24             	mov    0x24(%eax),%eax
801060ab:	85 c0                	test   %eax,%eax
801060ad:	74 0d                	je     801060bc <trap+0xfc>
801060af:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060b3:	83 e0 03             	and    $0x3,%eax
801060b6:	66 83 f8 03          	cmp    $0x3,%ax
801060ba:	74 35                	je     801060f1 <trap+0x131>
    exit();
}
801060bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060bf:	5b                   	pop    %ebx
801060c0:	5e                   	pop    %esi
801060c1:	5f                   	pop    %edi
801060c2:	5d                   	pop    %ebp
801060c3:	c3                   	ret    
801060c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801060c8:	e8 23 d7 ff ff       	call   801037f0 <myproc>
801060cd:	8b 58 24             	mov    0x24(%eax),%ebx
801060d0:	85 db                	test   %ebx,%ebx
801060d2:	0f 85 e8 00 00 00    	jne    801061c0 <trap+0x200>
    myproc()->tf = tf;
801060d8:	e8 13 d7 ff ff       	call   801037f0 <myproc>
801060dd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801060e0:	e8 2b ef ff ff       	call   80105010 <syscall>
    if(myproc()->killed)
801060e5:	e8 06 d7 ff ff       	call   801037f0 <myproc>
801060ea:	8b 48 24             	mov    0x24(%eax),%ecx
801060ed:	85 c9                	test   %ecx,%ecx
801060ef:	74 cb                	je     801060bc <trap+0xfc>
}
801060f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060f4:	5b                   	pop    %ebx
801060f5:	5e                   	pop    %esi
801060f6:	5f                   	pop    %edi
801060f7:	5d                   	pop    %ebp
      exit();
801060f8:	e9 f3 db ff ff       	jmp    80103cf0 <exit>
801060fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106100:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106104:	75 94                	jne    8010609a <trap+0xda>
    yield();
80106106:	e8 c5 de ff ff       	call   80103fd0 <yield>
8010610b:	eb 8d                	jmp    8010609a <trap+0xda>
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106110:	e8 bb d6 ff ff       	call   801037d0 <cpuid>
80106115:	85 c0                	test   %eax,%eax
80106117:	0f 84 c3 00 00 00    	je     801061e0 <trap+0x220>
    lapiceoi();
8010611d:	e8 6e c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106122:	e8 c9 d6 ff ff       	call   801037f0 <myproc>
80106127:	85 c0                	test   %eax,%eax
80106129:	0f 85 38 ff ff ff    	jne    80106067 <trap+0xa7>
8010612f:	e9 50 ff ff ff       	jmp    80106084 <trap+0xc4>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106138:	e8 13 c5 ff ff       	call   80102650 <kbdintr>
    lapiceoi();
8010613d:	e8 4e c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106142:	e8 a9 d6 ff ff       	call   801037f0 <myproc>
80106147:	85 c0                	test   %eax,%eax
80106149:	0f 85 18 ff ff ff    	jne    80106067 <trap+0xa7>
8010614f:	e9 30 ff ff ff       	jmp    80106084 <trap+0xc4>
80106154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106158:	e8 53 02 00 00       	call   801063b0 <uartintr>
    lapiceoi();
8010615d:	e8 2e c6 ff ff       	call   80102790 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106162:	e8 89 d6 ff ff       	call   801037f0 <myproc>
80106167:	85 c0                	test   %eax,%eax
80106169:	0f 85 f8 fe ff ff    	jne    80106067 <trap+0xa7>
8010616f:	e9 10 ff ff ff       	jmp    80106084 <trap+0xc4>
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106178:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
8010617c:	8b 77 38             	mov    0x38(%edi),%esi
8010617f:	e8 4c d6 ff ff       	call   801037d0 <cpuid>
80106184:	56                   	push   %esi
80106185:	53                   	push   %ebx
80106186:	50                   	push   %eax
80106187:	68 90 7f 10 80       	push   $0x80107f90
8010618c:	e8 cf a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106191:	e8 fa c5 ff ff       	call   80102790 <lapiceoi>
    break;
80106196:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106199:	e8 52 d6 ff ff       	call   801037f0 <myproc>
8010619e:	85 c0                	test   %eax,%eax
801061a0:	0f 85 c1 fe ff ff    	jne    80106067 <trap+0xa7>
801061a6:	e9 d9 fe ff ff       	jmp    80106084 <trap+0xc4>
801061ab:	90                   	nop
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801061b0:	e8 fb be ff ff       	call   801020b0 <ideintr>
801061b5:	e9 63 ff ff ff       	jmp    8010611d <trap+0x15d>
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801061c0:	e8 2b db ff ff       	call   80103cf0 <exit>
801061c5:	e9 0e ff ff ff       	jmp    801060d8 <trap+0x118>
801061ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801061d0:	e8 1b db ff ff       	call   80103cf0 <exit>
801061d5:	e9 aa fe ff ff       	jmp    80106084 <trap+0xc4>
801061da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801061e0:	83 ec 0c             	sub    $0xc,%esp
801061e3:	68 60 a1 11 80       	push   $0x8011a160
801061e8:	e8 23 e9 ff ff       	call   80104b10 <acquire>
      wakeup(&ticks);
801061ed:	c7 04 24 a0 a9 11 80 	movl   $0x8011a9a0,(%esp)
      ticks++;
801061f4:	83 05 a0 a9 11 80 01 	addl   $0x1,0x8011a9a0
      wakeup(&ticks);
801061fb:	e8 10 df ff ff       	call   80104110 <wakeup>
      release(&tickslock);
80106200:	c7 04 24 60 a1 11 80 	movl   $0x8011a160,(%esp)
80106207:	e8 c4 e9 ff ff       	call   80104bd0 <release>
8010620c:	83 c4 10             	add    $0x10,%esp
8010620f:	e9 09 ff ff ff       	jmp    8010611d <trap+0x15d>
80106214:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106217:	e8 b4 d5 ff ff       	call   801037d0 <cpuid>
8010621c:	83 ec 0c             	sub    $0xc,%esp
8010621f:	56                   	push   %esi
80106220:	53                   	push   %ebx
80106221:	50                   	push   %eax
80106222:	ff 77 30             	pushl  0x30(%edi)
80106225:	68 b4 7f 10 80       	push   $0x80107fb4
8010622a:	e8 31 a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010622f:	83 c4 14             	add    $0x14,%esp
80106232:	68 8a 7f 10 80       	push   $0x80107f8a
80106237:	e8 54 a1 ff ff       	call   80100390 <panic>
8010623c:	66 90                	xchg   %ax,%ax
8010623e:	66 90                	xchg   %ax,%ax

80106240 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106240:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106245:	55                   	push   %ebp
80106246:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106248:	85 c0                	test   %eax,%eax
8010624a:	74 1c                	je     80106268 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010624c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106251:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106252:	a8 01                	test   $0x1,%al
80106254:	74 12                	je     80106268 <uartgetc+0x28>
80106256:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010625b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010625c:	0f b6 c0             	movzbl %al,%eax
}
8010625f:	5d                   	pop    %ebp
80106260:	c3                   	ret    
80106261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010626d:	5d                   	pop    %ebp
8010626e:	c3                   	ret    
8010626f:	90                   	nop

80106270 <uartputc.part.0>:
uartputc(int c)
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	57                   	push   %edi
80106274:	56                   	push   %esi
80106275:	53                   	push   %ebx
80106276:	89 c7                	mov    %eax,%edi
80106278:	bb 80 00 00 00       	mov    $0x80,%ebx
8010627d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106282:	83 ec 0c             	sub    $0xc,%esp
80106285:	eb 1b                	jmp    801062a2 <uartputc.part.0+0x32>
80106287:	89 f6                	mov    %esi,%esi
80106289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	6a 0a                	push   $0xa
80106295:	e8 16 c5 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010629a:	83 c4 10             	add    $0x10,%esp
8010629d:	83 eb 01             	sub    $0x1,%ebx
801062a0:	74 07                	je     801062a9 <uartputc.part.0+0x39>
801062a2:	89 f2                	mov    %esi,%edx
801062a4:	ec                   	in     (%dx),%al
801062a5:	a8 20                	test   $0x20,%al
801062a7:	74 e7                	je     80106290 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ae:	89 f8                	mov    %edi,%eax
801062b0:	ee                   	out    %al,(%dx)
}
801062b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b4:	5b                   	pop    %ebx
801062b5:	5e                   	pop    %esi
801062b6:	5f                   	pop    %edi
801062b7:	5d                   	pop    %ebp
801062b8:	c3                   	ret    
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062c0 <uartinit>:
{
801062c0:	55                   	push   %ebp
801062c1:	31 c9                	xor    %ecx,%ecx
801062c3:	89 c8                	mov    %ecx,%eax
801062c5:	89 e5                	mov    %esp,%ebp
801062c7:	57                   	push   %edi
801062c8:	56                   	push   %esi
801062c9:	53                   	push   %ebx
801062ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062cf:	89 da                	mov    %ebx,%edx
801062d1:	83 ec 0c             	sub    $0xc,%esp
801062d4:	ee                   	out    %al,(%dx)
801062d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062df:	89 fa                	mov    %edi,%edx
801062e1:	ee                   	out    %al,(%dx)
801062e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ec:	ee                   	out    %al,(%dx)
801062ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801062f2:	89 c8                	mov    %ecx,%eax
801062f4:	89 f2                	mov    %esi,%edx
801062f6:	ee                   	out    %al,(%dx)
801062f7:	b8 03 00 00 00       	mov    $0x3,%eax
801062fc:	89 fa                	mov    %edi,%edx
801062fe:	ee                   	out    %al,(%dx)
801062ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106304:	89 c8                	mov    %ecx,%eax
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 01 00 00 00       	mov    $0x1,%eax
8010630c:	89 f2                	mov    %esi,%edx
8010630e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010630f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106314:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106315:	3c ff                	cmp    $0xff,%al
80106317:	74 5a                	je     80106373 <uartinit+0xb3>
  uart = 1;
80106319:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106320:	00 00 00 
80106323:	89 da                	mov    %ebx,%edx
80106325:	ec                   	in     (%dx),%al
80106326:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010632b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010632c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010632f:	bb ac 80 10 80       	mov    $0x801080ac,%ebx
  ioapicenable(IRQ_COM1, 0);
80106334:	6a 00                	push   $0x0
80106336:	6a 04                	push   $0x4
80106338:	e8 d3 bf ff ff       	call   80102310 <ioapicenable>
8010633d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106340:	b8 78 00 00 00       	mov    $0x78,%eax
80106345:	eb 13                	jmp    8010635a <uartinit+0x9a>
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106350:	83 c3 01             	add    $0x1,%ebx
80106353:	0f be 03             	movsbl (%ebx),%eax
80106356:	84 c0                	test   %al,%al
80106358:	74 19                	je     80106373 <uartinit+0xb3>
  if(!uart)
8010635a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106360:	85 d2                	test   %edx,%edx
80106362:	74 ec                	je     80106350 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106364:	83 c3 01             	add    $0x1,%ebx
80106367:	e8 04 ff ff ff       	call   80106270 <uartputc.part.0>
8010636c:	0f be 03             	movsbl (%ebx),%eax
8010636f:	84 c0                	test   %al,%al
80106371:	75 e7                	jne    8010635a <uartinit+0x9a>
}
80106373:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106376:	5b                   	pop    %ebx
80106377:	5e                   	pop    %esi
80106378:	5f                   	pop    %edi
80106379:	5d                   	pop    %ebp
8010637a:	c3                   	ret    
8010637b:	90                   	nop
8010637c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106380 <uartputc>:
  if(!uart)
80106380:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106386:	55                   	push   %ebp
80106387:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106389:	85 d2                	test   %edx,%edx
{
8010638b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010638e:	74 10                	je     801063a0 <uartputc+0x20>
}
80106390:	5d                   	pop    %ebp
80106391:	e9 da fe ff ff       	jmp    80106270 <uartputc.part.0>
80106396:	8d 76 00             	lea    0x0(%esi),%esi
80106399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063a0:	5d                   	pop    %ebp
801063a1:	c3                   	ret    
801063a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063b0 <uartintr>:

void
uartintr(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063b6:	68 40 62 10 80       	push   $0x80106240
801063bb:	e8 50 a4 ff ff       	call   80100810 <consoleintr>
}
801063c0:	83 c4 10             	add    $0x10,%esp
801063c3:	c9                   	leave  
801063c4:	c3                   	ret    

801063c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063c5:	6a 00                	push   $0x0
  pushl $0
801063c7:	6a 00                	push   $0x0
  jmp alltraps
801063c9:	e9 11 fb ff ff       	jmp    80105edf <alltraps>

801063ce <vector1>:
.globl vector1
vector1:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $1
801063d0:	6a 01                	push   $0x1
  jmp alltraps
801063d2:	e9 08 fb ff ff       	jmp    80105edf <alltraps>

801063d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $2
801063d9:	6a 02                	push   $0x2
  jmp alltraps
801063db:	e9 ff fa ff ff       	jmp    80105edf <alltraps>

801063e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063e0:	6a 00                	push   $0x0
  pushl $3
801063e2:	6a 03                	push   $0x3
  jmp alltraps
801063e4:	e9 f6 fa ff ff       	jmp    80105edf <alltraps>

801063e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063e9:	6a 00                	push   $0x0
  pushl $4
801063eb:	6a 04                	push   $0x4
  jmp alltraps
801063ed:	e9 ed fa ff ff       	jmp    80105edf <alltraps>

801063f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $5
801063f4:	6a 05                	push   $0x5
  jmp alltraps
801063f6:	e9 e4 fa ff ff       	jmp    80105edf <alltraps>

801063fb <vector6>:
.globl vector6
vector6:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $6
801063fd:	6a 06                	push   $0x6
  jmp alltraps
801063ff:	e9 db fa ff ff       	jmp    80105edf <alltraps>

80106404 <vector7>:
.globl vector7
vector7:
  pushl $0
80106404:	6a 00                	push   $0x0
  pushl $7
80106406:	6a 07                	push   $0x7
  jmp alltraps
80106408:	e9 d2 fa ff ff       	jmp    80105edf <alltraps>

8010640d <vector8>:
.globl vector8
vector8:
  pushl $8
8010640d:	6a 08                	push   $0x8
  jmp alltraps
8010640f:	e9 cb fa ff ff       	jmp    80105edf <alltraps>

80106414 <vector9>:
.globl vector9
vector9:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $9
80106416:	6a 09                	push   $0x9
  jmp alltraps
80106418:	e9 c2 fa ff ff       	jmp    80105edf <alltraps>

8010641d <vector10>:
.globl vector10
vector10:
  pushl $10
8010641d:	6a 0a                	push   $0xa
  jmp alltraps
8010641f:	e9 bb fa ff ff       	jmp    80105edf <alltraps>

80106424 <vector11>:
.globl vector11
vector11:
  pushl $11
80106424:	6a 0b                	push   $0xb
  jmp alltraps
80106426:	e9 b4 fa ff ff       	jmp    80105edf <alltraps>

8010642b <vector12>:
.globl vector12
vector12:
  pushl $12
8010642b:	6a 0c                	push   $0xc
  jmp alltraps
8010642d:	e9 ad fa ff ff       	jmp    80105edf <alltraps>

80106432 <vector13>:
.globl vector13
vector13:
  pushl $13
80106432:	6a 0d                	push   $0xd
  jmp alltraps
80106434:	e9 a6 fa ff ff       	jmp    80105edf <alltraps>

80106439 <vector14>:
.globl vector14
vector14:
  pushl $14
80106439:	6a 0e                	push   $0xe
  jmp alltraps
8010643b:	e9 9f fa ff ff       	jmp    80105edf <alltraps>

80106440 <vector15>:
.globl vector15
vector15:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $15
80106442:	6a 0f                	push   $0xf
  jmp alltraps
80106444:	e9 96 fa ff ff       	jmp    80105edf <alltraps>

80106449 <vector16>:
.globl vector16
vector16:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $16
8010644b:	6a 10                	push   $0x10
  jmp alltraps
8010644d:	e9 8d fa ff ff       	jmp    80105edf <alltraps>

80106452 <vector17>:
.globl vector17
vector17:
  pushl $17
80106452:	6a 11                	push   $0x11
  jmp alltraps
80106454:	e9 86 fa ff ff       	jmp    80105edf <alltraps>

80106459 <vector18>:
.globl vector18
vector18:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $18
8010645b:	6a 12                	push   $0x12
  jmp alltraps
8010645d:	e9 7d fa ff ff       	jmp    80105edf <alltraps>

80106462 <vector19>:
.globl vector19
vector19:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $19
80106464:	6a 13                	push   $0x13
  jmp alltraps
80106466:	e9 74 fa ff ff       	jmp    80105edf <alltraps>

8010646b <vector20>:
.globl vector20
vector20:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $20
8010646d:	6a 14                	push   $0x14
  jmp alltraps
8010646f:	e9 6b fa ff ff       	jmp    80105edf <alltraps>

80106474 <vector21>:
.globl vector21
vector21:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $21
80106476:	6a 15                	push   $0x15
  jmp alltraps
80106478:	e9 62 fa ff ff       	jmp    80105edf <alltraps>

8010647d <vector22>:
.globl vector22
vector22:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $22
8010647f:	6a 16                	push   $0x16
  jmp alltraps
80106481:	e9 59 fa ff ff       	jmp    80105edf <alltraps>

80106486 <vector23>:
.globl vector23
vector23:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $23
80106488:	6a 17                	push   $0x17
  jmp alltraps
8010648a:	e9 50 fa ff ff       	jmp    80105edf <alltraps>

8010648f <vector24>:
.globl vector24
vector24:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $24
80106491:	6a 18                	push   $0x18
  jmp alltraps
80106493:	e9 47 fa ff ff       	jmp    80105edf <alltraps>

80106498 <vector25>:
.globl vector25
vector25:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $25
8010649a:	6a 19                	push   $0x19
  jmp alltraps
8010649c:	e9 3e fa ff ff       	jmp    80105edf <alltraps>

801064a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $26
801064a3:	6a 1a                	push   $0x1a
  jmp alltraps
801064a5:	e9 35 fa ff ff       	jmp    80105edf <alltraps>

801064aa <vector27>:
.globl vector27
vector27:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $27
801064ac:	6a 1b                	push   $0x1b
  jmp alltraps
801064ae:	e9 2c fa ff ff       	jmp    80105edf <alltraps>

801064b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $28
801064b5:	6a 1c                	push   $0x1c
  jmp alltraps
801064b7:	e9 23 fa ff ff       	jmp    80105edf <alltraps>

801064bc <vector29>:
.globl vector29
vector29:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $29
801064be:	6a 1d                	push   $0x1d
  jmp alltraps
801064c0:	e9 1a fa ff ff       	jmp    80105edf <alltraps>

801064c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $30
801064c7:	6a 1e                	push   $0x1e
  jmp alltraps
801064c9:	e9 11 fa ff ff       	jmp    80105edf <alltraps>

801064ce <vector31>:
.globl vector31
vector31:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $31
801064d0:	6a 1f                	push   $0x1f
  jmp alltraps
801064d2:	e9 08 fa ff ff       	jmp    80105edf <alltraps>

801064d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $32
801064d9:	6a 20                	push   $0x20
  jmp alltraps
801064db:	e9 ff f9 ff ff       	jmp    80105edf <alltraps>

801064e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $33
801064e2:	6a 21                	push   $0x21
  jmp alltraps
801064e4:	e9 f6 f9 ff ff       	jmp    80105edf <alltraps>

801064e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $34
801064eb:	6a 22                	push   $0x22
  jmp alltraps
801064ed:	e9 ed f9 ff ff       	jmp    80105edf <alltraps>

801064f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $35
801064f4:	6a 23                	push   $0x23
  jmp alltraps
801064f6:	e9 e4 f9 ff ff       	jmp    80105edf <alltraps>

801064fb <vector36>:
.globl vector36
vector36:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $36
801064fd:	6a 24                	push   $0x24
  jmp alltraps
801064ff:	e9 db f9 ff ff       	jmp    80105edf <alltraps>

80106504 <vector37>:
.globl vector37
vector37:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $37
80106506:	6a 25                	push   $0x25
  jmp alltraps
80106508:	e9 d2 f9 ff ff       	jmp    80105edf <alltraps>

8010650d <vector38>:
.globl vector38
vector38:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $38
8010650f:	6a 26                	push   $0x26
  jmp alltraps
80106511:	e9 c9 f9 ff ff       	jmp    80105edf <alltraps>

80106516 <vector39>:
.globl vector39
vector39:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $39
80106518:	6a 27                	push   $0x27
  jmp alltraps
8010651a:	e9 c0 f9 ff ff       	jmp    80105edf <alltraps>

8010651f <vector40>:
.globl vector40
vector40:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $40
80106521:	6a 28                	push   $0x28
  jmp alltraps
80106523:	e9 b7 f9 ff ff       	jmp    80105edf <alltraps>

80106528 <vector41>:
.globl vector41
vector41:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $41
8010652a:	6a 29                	push   $0x29
  jmp alltraps
8010652c:	e9 ae f9 ff ff       	jmp    80105edf <alltraps>

80106531 <vector42>:
.globl vector42
vector42:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $42
80106533:	6a 2a                	push   $0x2a
  jmp alltraps
80106535:	e9 a5 f9 ff ff       	jmp    80105edf <alltraps>

8010653a <vector43>:
.globl vector43
vector43:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $43
8010653c:	6a 2b                	push   $0x2b
  jmp alltraps
8010653e:	e9 9c f9 ff ff       	jmp    80105edf <alltraps>

80106543 <vector44>:
.globl vector44
vector44:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $44
80106545:	6a 2c                	push   $0x2c
  jmp alltraps
80106547:	e9 93 f9 ff ff       	jmp    80105edf <alltraps>

8010654c <vector45>:
.globl vector45
vector45:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $45
8010654e:	6a 2d                	push   $0x2d
  jmp alltraps
80106550:	e9 8a f9 ff ff       	jmp    80105edf <alltraps>

80106555 <vector46>:
.globl vector46
vector46:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $46
80106557:	6a 2e                	push   $0x2e
  jmp alltraps
80106559:	e9 81 f9 ff ff       	jmp    80105edf <alltraps>

8010655e <vector47>:
.globl vector47
vector47:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $47
80106560:	6a 2f                	push   $0x2f
  jmp alltraps
80106562:	e9 78 f9 ff ff       	jmp    80105edf <alltraps>

80106567 <vector48>:
.globl vector48
vector48:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $48
80106569:	6a 30                	push   $0x30
  jmp alltraps
8010656b:	e9 6f f9 ff ff       	jmp    80105edf <alltraps>

80106570 <vector49>:
.globl vector49
vector49:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $49
80106572:	6a 31                	push   $0x31
  jmp alltraps
80106574:	e9 66 f9 ff ff       	jmp    80105edf <alltraps>

80106579 <vector50>:
.globl vector50
vector50:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $50
8010657b:	6a 32                	push   $0x32
  jmp alltraps
8010657d:	e9 5d f9 ff ff       	jmp    80105edf <alltraps>

80106582 <vector51>:
.globl vector51
vector51:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $51
80106584:	6a 33                	push   $0x33
  jmp alltraps
80106586:	e9 54 f9 ff ff       	jmp    80105edf <alltraps>

8010658b <vector52>:
.globl vector52
vector52:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $52
8010658d:	6a 34                	push   $0x34
  jmp alltraps
8010658f:	e9 4b f9 ff ff       	jmp    80105edf <alltraps>

80106594 <vector53>:
.globl vector53
vector53:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $53
80106596:	6a 35                	push   $0x35
  jmp alltraps
80106598:	e9 42 f9 ff ff       	jmp    80105edf <alltraps>

8010659d <vector54>:
.globl vector54
vector54:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $54
8010659f:	6a 36                	push   $0x36
  jmp alltraps
801065a1:	e9 39 f9 ff ff       	jmp    80105edf <alltraps>

801065a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $55
801065a8:	6a 37                	push   $0x37
  jmp alltraps
801065aa:	e9 30 f9 ff ff       	jmp    80105edf <alltraps>

801065af <vector56>:
.globl vector56
vector56:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $56
801065b1:	6a 38                	push   $0x38
  jmp alltraps
801065b3:	e9 27 f9 ff ff       	jmp    80105edf <alltraps>

801065b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $57
801065ba:	6a 39                	push   $0x39
  jmp alltraps
801065bc:	e9 1e f9 ff ff       	jmp    80105edf <alltraps>

801065c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $58
801065c3:	6a 3a                	push   $0x3a
  jmp alltraps
801065c5:	e9 15 f9 ff ff       	jmp    80105edf <alltraps>

801065ca <vector59>:
.globl vector59
vector59:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $59
801065cc:	6a 3b                	push   $0x3b
  jmp alltraps
801065ce:	e9 0c f9 ff ff       	jmp    80105edf <alltraps>

801065d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $60
801065d5:	6a 3c                	push   $0x3c
  jmp alltraps
801065d7:	e9 03 f9 ff ff       	jmp    80105edf <alltraps>

801065dc <vector61>:
.globl vector61
vector61:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $61
801065de:	6a 3d                	push   $0x3d
  jmp alltraps
801065e0:	e9 fa f8 ff ff       	jmp    80105edf <alltraps>

801065e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $62
801065e7:	6a 3e                	push   $0x3e
  jmp alltraps
801065e9:	e9 f1 f8 ff ff       	jmp    80105edf <alltraps>

801065ee <vector63>:
.globl vector63
vector63:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $63
801065f0:	6a 3f                	push   $0x3f
  jmp alltraps
801065f2:	e9 e8 f8 ff ff       	jmp    80105edf <alltraps>

801065f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $64
801065f9:	6a 40                	push   $0x40
  jmp alltraps
801065fb:	e9 df f8 ff ff       	jmp    80105edf <alltraps>

80106600 <vector65>:
.globl vector65
vector65:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $65
80106602:	6a 41                	push   $0x41
  jmp alltraps
80106604:	e9 d6 f8 ff ff       	jmp    80105edf <alltraps>

80106609 <vector66>:
.globl vector66
vector66:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $66
8010660b:	6a 42                	push   $0x42
  jmp alltraps
8010660d:	e9 cd f8 ff ff       	jmp    80105edf <alltraps>

80106612 <vector67>:
.globl vector67
vector67:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $67
80106614:	6a 43                	push   $0x43
  jmp alltraps
80106616:	e9 c4 f8 ff ff       	jmp    80105edf <alltraps>

8010661b <vector68>:
.globl vector68
vector68:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $68
8010661d:	6a 44                	push   $0x44
  jmp alltraps
8010661f:	e9 bb f8 ff ff       	jmp    80105edf <alltraps>

80106624 <vector69>:
.globl vector69
vector69:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $69
80106626:	6a 45                	push   $0x45
  jmp alltraps
80106628:	e9 b2 f8 ff ff       	jmp    80105edf <alltraps>

8010662d <vector70>:
.globl vector70
vector70:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $70
8010662f:	6a 46                	push   $0x46
  jmp alltraps
80106631:	e9 a9 f8 ff ff       	jmp    80105edf <alltraps>

80106636 <vector71>:
.globl vector71
vector71:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $71
80106638:	6a 47                	push   $0x47
  jmp alltraps
8010663a:	e9 a0 f8 ff ff       	jmp    80105edf <alltraps>

8010663f <vector72>:
.globl vector72
vector72:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $72
80106641:	6a 48                	push   $0x48
  jmp alltraps
80106643:	e9 97 f8 ff ff       	jmp    80105edf <alltraps>

80106648 <vector73>:
.globl vector73
vector73:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $73
8010664a:	6a 49                	push   $0x49
  jmp alltraps
8010664c:	e9 8e f8 ff ff       	jmp    80105edf <alltraps>

80106651 <vector74>:
.globl vector74
vector74:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $74
80106653:	6a 4a                	push   $0x4a
  jmp alltraps
80106655:	e9 85 f8 ff ff       	jmp    80105edf <alltraps>

8010665a <vector75>:
.globl vector75
vector75:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $75
8010665c:	6a 4b                	push   $0x4b
  jmp alltraps
8010665e:	e9 7c f8 ff ff       	jmp    80105edf <alltraps>

80106663 <vector76>:
.globl vector76
vector76:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $76
80106665:	6a 4c                	push   $0x4c
  jmp alltraps
80106667:	e9 73 f8 ff ff       	jmp    80105edf <alltraps>

8010666c <vector77>:
.globl vector77
vector77:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $77
8010666e:	6a 4d                	push   $0x4d
  jmp alltraps
80106670:	e9 6a f8 ff ff       	jmp    80105edf <alltraps>

80106675 <vector78>:
.globl vector78
vector78:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $78
80106677:	6a 4e                	push   $0x4e
  jmp alltraps
80106679:	e9 61 f8 ff ff       	jmp    80105edf <alltraps>

8010667e <vector79>:
.globl vector79
vector79:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $79
80106680:	6a 4f                	push   $0x4f
  jmp alltraps
80106682:	e9 58 f8 ff ff       	jmp    80105edf <alltraps>

80106687 <vector80>:
.globl vector80
vector80:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $80
80106689:	6a 50                	push   $0x50
  jmp alltraps
8010668b:	e9 4f f8 ff ff       	jmp    80105edf <alltraps>

80106690 <vector81>:
.globl vector81
vector81:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $81
80106692:	6a 51                	push   $0x51
  jmp alltraps
80106694:	e9 46 f8 ff ff       	jmp    80105edf <alltraps>

80106699 <vector82>:
.globl vector82
vector82:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $82
8010669b:	6a 52                	push   $0x52
  jmp alltraps
8010669d:	e9 3d f8 ff ff       	jmp    80105edf <alltraps>

801066a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $83
801066a4:	6a 53                	push   $0x53
  jmp alltraps
801066a6:	e9 34 f8 ff ff       	jmp    80105edf <alltraps>

801066ab <vector84>:
.globl vector84
vector84:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $84
801066ad:	6a 54                	push   $0x54
  jmp alltraps
801066af:	e9 2b f8 ff ff       	jmp    80105edf <alltraps>

801066b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $85
801066b6:	6a 55                	push   $0x55
  jmp alltraps
801066b8:	e9 22 f8 ff ff       	jmp    80105edf <alltraps>

801066bd <vector86>:
.globl vector86
vector86:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $86
801066bf:	6a 56                	push   $0x56
  jmp alltraps
801066c1:	e9 19 f8 ff ff       	jmp    80105edf <alltraps>

801066c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $87
801066c8:	6a 57                	push   $0x57
  jmp alltraps
801066ca:	e9 10 f8 ff ff       	jmp    80105edf <alltraps>

801066cf <vector88>:
.globl vector88
vector88:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $88
801066d1:	6a 58                	push   $0x58
  jmp alltraps
801066d3:	e9 07 f8 ff ff       	jmp    80105edf <alltraps>

801066d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $89
801066da:	6a 59                	push   $0x59
  jmp alltraps
801066dc:	e9 fe f7 ff ff       	jmp    80105edf <alltraps>

801066e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $90
801066e3:	6a 5a                	push   $0x5a
  jmp alltraps
801066e5:	e9 f5 f7 ff ff       	jmp    80105edf <alltraps>

801066ea <vector91>:
.globl vector91
vector91:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $91
801066ec:	6a 5b                	push   $0x5b
  jmp alltraps
801066ee:	e9 ec f7 ff ff       	jmp    80105edf <alltraps>

801066f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $92
801066f5:	6a 5c                	push   $0x5c
  jmp alltraps
801066f7:	e9 e3 f7 ff ff       	jmp    80105edf <alltraps>

801066fc <vector93>:
.globl vector93
vector93:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $93
801066fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106700:	e9 da f7 ff ff       	jmp    80105edf <alltraps>

80106705 <vector94>:
.globl vector94
vector94:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $94
80106707:	6a 5e                	push   $0x5e
  jmp alltraps
80106709:	e9 d1 f7 ff ff       	jmp    80105edf <alltraps>

8010670e <vector95>:
.globl vector95
vector95:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $95
80106710:	6a 5f                	push   $0x5f
  jmp alltraps
80106712:	e9 c8 f7 ff ff       	jmp    80105edf <alltraps>

80106717 <vector96>:
.globl vector96
vector96:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $96
80106719:	6a 60                	push   $0x60
  jmp alltraps
8010671b:	e9 bf f7 ff ff       	jmp    80105edf <alltraps>

80106720 <vector97>:
.globl vector97
vector97:
  pushl $0
80106720:	6a 00                	push   $0x0
  pushl $97
80106722:	6a 61                	push   $0x61
  jmp alltraps
80106724:	e9 b6 f7 ff ff       	jmp    80105edf <alltraps>

80106729 <vector98>:
.globl vector98
vector98:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $98
8010672b:	6a 62                	push   $0x62
  jmp alltraps
8010672d:	e9 ad f7 ff ff       	jmp    80105edf <alltraps>

80106732 <vector99>:
.globl vector99
vector99:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $99
80106734:	6a 63                	push   $0x63
  jmp alltraps
80106736:	e9 a4 f7 ff ff       	jmp    80105edf <alltraps>

8010673b <vector100>:
.globl vector100
vector100:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $100
8010673d:	6a 64                	push   $0x64
  jmp alltraps
8010673f:	e9 9b f7 ff ff       	jmp    80105edf <alltraps>

80106744 <vector101>:
.globl vector101
vector101:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $101
80106746:	6a 65                	push   $0x65
  jmp alltraps
80106748:	e9 92 f7 ff ff       	jmp    80105edf <alltraps>

8010674d <vector102>:
.globl vector102
vector102:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $102
8010674f:	6a 66                	push   $0x66
  jmp alltraps
80106751:	e9 89 f7 ff ff       	jmp    80105edf <alltraps>

80106756 <vector103>:
.globl vector103
vector103:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $103
80106758:	6a 67                	push   $0x67
  jmp alltraps
8010675a:	e9 80 f7 ff ff       	jmp    80105edf <alltraps>

8010675f <vector104>:
.globl vector104
vector104:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $104
80106761:	6a 68                	push   $0x68
  jmp alltraps
80106763:	e9 77 f7 ff ff       	jmp    80105edf <alltraps>

80106768 <vector105>:
.globl vector105
vector105:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $105
8010676a:	6a 69                	push   $0x69
  jmp alltraps
8010676c:	e9 6e f7 ff ff       	jmp    80105edf <alltraps>

80106771 <vector106>:
.globl vector106
vector106:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $106
80106773:	6a 6a                	push   $0x6a
  jmp alltraps
80106775:	e9 65 f7 ff ff       	jmp    80105edf <alltraps>

8010677a <vector107>:
.globl vector107
vector107:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $107
8010677c:	6a 6b                	push   $0x6b
  jmp alltraps
8010677e:	e9 5c f7 ff ff       	jmp    80105edf <alltraps>

80106783 <vector108>:
.globl vector108
vector108:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $108
80106785:	6a 6c                	push   $0x6c
  jmp alltraps
80106787:	e9 53 f7 ff ff       	jmp    80105edf <alltraps>

8010678c <vector109>:
.globl vector109
vector109:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $109
8010678e:	6a 6d                	push   $0x6d
  jmp alltraps
80106790:	e9 4a f7 ff ff       	jmp    80105edf <alltraps>

80106795 <vector110>:
.globl vector110
vector110:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $110
80106797:	6a 6e                	push   $0x6e
  jmp alltraps
80106799:	e9 41 f7 ff ff       	jmp    80105edf <alltraps>

8010679e <vector111>:
.globl vector111
vector111:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $111
801067a0:	6a 6f                	push   $0x6f
  jmp alltraps
801067a2:	e9 38 f7 ff ff       	jmp    80105edf <alltraps>

801067a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $112
801067a9:	6a 70                	push   $0x70
  jmp alltraps
801067ab:	e9 2f f7 ff ff       	jmp    80105edf <alltraps>

801067b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $113
801067b2:	6a 71                	push   $0x71
  jmp alltraps
801067b4:	e9 26 f7 ff ff       	jmp    80105edf <alltraps>

801067b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $114
801067bb:	6a 72                	push   $0x72
  jmp alltraps
801067bd:	e9 1d f7 ff ff       	jmp    80105edf <alltraps>

801067c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $115
801067c4:	6a 73                	push   $0x73
  jmp alltraps
801067c6:	e9 14 f7 ff ff       	jmp    80105edf <alltraps>

801067cb <vector116>:
.globl vector116
vector116:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $116
801067cd:	6a 74                	push   $0x74
  jmp alltraps
801067cf:	e9 0b f7 ff ff       	jmp    80105edf <alltraps>

801067d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $117
801067d6:	6a 75                	push   $0x75
  jmp alltraps
801067d8:	e9 02 f7 ff ff       	jmp    80105edf <alltraps>

801067dd <vector118>:
.globl vector118
vector118:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $118
801067df:	6a 76                	push   $0x76
  jmp alltraps
801067e1:	e9 f9 f6 ff ff       	jmp    80105edf <alltraps>

801067e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $119
801067e8:	6a 77                	push   $0x77
  jmp alltraps
801067ea:	e9 f0 f6 ff ff       	jmp    80105edf <alltraps>

801067ef <vector120>:
.globl vector120
vector120:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $120
801067f1:	6a 78                	push   $0x78
  jmp alltraps
801067f3:	e9 e7 f6 ff ff       	jmp    80105edf <alltraps>

801067f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $121
801067fa:	6a 79                	push   $0x79
  jmp alltraps
801067fc:	e9 de f6 ff ff       	jmp    80105edf <alltraps>

80106801 <vector122>:
.globl vector122
vector122:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $122
80106803:	6a 7a                	push   $0x7a
  jmp alltraps
80106805:	e9 d5 f6 ff ff       	jmp    80105edf <alltraps>

8010680a <vector123>:
.globl vector123
vector123:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $123
8010680c:	6a 7b                	push   $0x7b
  jmp alltraps
8010680e:	e9 cc f6 ff ff       	jmp    80105edf <alltraps>

80106813 <vector124>:
.globl vector124
vector124:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $124
80106815:	6a 7c                	push   $0x7c
  jmp alltraps
80106817:	e9 c3 f6 ff ff       	jmp    80105edf <alltraps>

8010681c <vector125>:
.globl vector125
vector125:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $125
8010681e:	6a 7d                	push   $0x7d
  jmp alltraps
80106820:	e9 ba f6 ff ff       	jmp    80105edf <alltraps>

80106825 <vector126>:
.globl vector126
vector126:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $126
80106827:	6a 7e                	push   $0x7e
  jmp alltraps
80106829:	e9 b1 f6 ff ff       	jmp    80105edf <alltraps>

8010682e <vector127>:
.globl vector127
vector127:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $127
80106830:	6a 7f                	push   $0x7f
  jmp alltraps
80106832:	e9 a8 f6 ff ff       	jmp    80105edf <alltraps>

80106837 <vector128>:
.globl vector128
vector128:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $128
80106839:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010683e:	e9 9c f6 ff ff       	jmp    80105edf <alltraps>

80106843 <vector129>:
.globl vector129
vector129:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $129
80106845:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010684a:	e9 90 f6 ff ff       	jmp    80105edf <alltraps>

8010684f <vector130>:
.globl vector130
vector130:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $130
80106851:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106856:	e9 84 f6 ff ff       	jmp    80105edf <alltraps>

8010685b <vector131>:
.globl vector131
vector131:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $131
8010685d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106862:	e9 78 f6 ff ff       	jmp    80105edf <alltraps>

80106867 <vector132>:
.globl vector132
vector132:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $132
80106869:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010686e:	e9 6c f6 ff ff       	jmp    80105edf <alltraps>

80106873 <vector133>:
.globl vector133
vector133:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $133
80106875:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010687a:	e9 60 f6 ff ff       	jmp    80105edf <alltraps>

8010687f <vector134>:
.globl vector134
vector134:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $134
80106881:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106886:	e9 54 f6 ff ff       	jmp    80105edf <alltraps>

8010688b <vector135>:
.globl vector135
vector135:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $135
8010688d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106892:	e9 48 f6 ff ff       	jmp    80105edf <alltraps>

80106897 <vector136>:
.globl vector136
vector136:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $136
80106899:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010689e:	e9 3c f6 ff ff       	jmp    80105edf <alltraps>

801068a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $137
801068a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068aa:	e9 30 f6 ff ff       	jmp    80105edf <alltraps>

801068af <vector138>:
.globl vector138
vector138:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $138
801068b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068b6:	e9 24 f6 ff ff       	jmp    80105edf <alltraps>

801068bb <vector139>:
.globl vector139
vector139:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $139
801068bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068c2:	e9 18 f6 ff ff       	jmp    80105edf <alltraps>

801068c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $140
801068c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068ce:	e9 0c f6 ff ff       	jmp    80105edf <alltraps>

801068d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $141
801068d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068da:	e9 00 f6 ff ff       	jmp    80105edf <alltraps>

801068df <vector142>:
.globl vector142
vector142:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $142
801068e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068e6:	e9 f4 f5 ff ff       	jmp    80105edf <alltraps>

801068eb <vector143>:
.globl vector143
vector143:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $143
801068ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068f2:	e9 e8 f5 ff ff       	jmp    80105edf <alltraps>

801068f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $144
801068f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068fe:	e9 dc f5 ff ff       	jmp    80105edf <alltraps>

80106903 <vector145>:
.globl vector145
vector145:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $145
80106905:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010690a:	e9 d0 f5 ff ff       	jmp    80105edf <alltraps>

8010690f <vector146>:
.globl vector146
vector146:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $146
80106911:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106916:	e9 c4 f5 ff ff       	jmp    80105edf <alltraps>

8010691b <vector147>:
.globl vector147
vector147:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $147
8010691d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106922:	e9 b8 f5 ff ff       	jmp    80105edf <alltraps>

80106927 <vector148>:
.globl vector148
vector148:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $148
80106929:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010692e:	e9 ac f5 ff ff       	jmp    80105edf <alltraps>

80106933 <vector149>:
.globl vector149
vector149:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $149
80106935:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010693a:	e9 a0 f5 ff ff       	jmp    80105edf <alltraps>

8010693f <vector150>:
.globl vector150
vector150:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $150
80106941:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106946:	e9 94 f5 ff ff       	jmp    80105edf <alltraps>

8010694b <vector151>:
.globl vector151
vector151:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $151
8010694d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106952:	e9 88 f5 ff ff       	jmp    80105edf <alltraps>

80106957 <vector152>:
.globl vector152
vector152:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $152
80106959:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010695e:	e9 7c f5 ff ff       	jmp    80105edf <alltraps>

80106963 <vector153>:
.globl vector153
vector153:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $153
80106965:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010696a:	e9 70 f5 ff ff       	jmp    80105edf <alltraps>

8010696f <vector154>:
.globl vector154
vector154:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $154
80106971:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106976:	e9 64 f5 ff ff       	jmp    80105edf <alltraps>

8010697b <vector155>:
.globl vector155
vector155:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $155
8010697d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106982:	e9 58 f5 ff ff       	jmp    80105edf <alltraps>

80106987 <vector156>:
.globl vector156
vector156:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $156
80106989:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010698e:	e9 4c f5 ff ff       	jmp    80105edf <alltraps>

80106993 <vector157>:
.globl vector157
vector157:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $157
80106995:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010699a:	e9 40 f5 ff ff       	jmp    80105edf <alltraps>

8010699f <vector158>:
.globl vector158
vector158:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $158
801069a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069a6:	e9 34 f5 ff ff       	jmp    80105edf <alltraps>

801069ab <vector159>:
.globl vector159
vector159:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $159
801069ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069b2:	e9 28 f5 ff ff       	jmp    80105edf <alltraps>

801069b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $160
801069b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069be:	e9 1c f5 ff ff       	jmp    80105edf <alltraps>

801069c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $161
801069c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069ca:	e9 10 f5 ff ff       	jmp    80105edf <alltraps>

801069cf <vector162>:
.globl vector162
vector162:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $162
801069d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069d6:	e9 04 f5 ff ff       	jmp    80105edf <alltraps>

801069db <vector163>:
.globl vector163
vector163:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $163
801069dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069e2:	e9 f8 f4 ff ff       	jmp    80105edf <alltraps>

801069e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $164
801069e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069ee:	e9 ec f4 ff ff       	jmp    80105edf <alltraps>

801069f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $165
801069f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069fa:	e9 e0 f4 ff ff       	jmp    80105edf <alltraps>

801069ff <vector166>:
.globl vector166
vector166:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $166
80106a01:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a06:	e9 d4 f4 ff ff       	jmp    80105edf <alltraps>

80106a0b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $167
80106a0d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a12:	e9 c8 f4 ff ff       	jmp    80105edf <alltraps>

80106a17 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $168
80106a19:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a1e:	e9 bc f4 ff ff       	jmp    80105edf <alltraps>

80106a23 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $169
80106a25:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a2a:	e9 b0 f4 ff ff       	jmp    80105edf <alltraps>

80106a2f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $170
80106a31:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a36:	e9 a4 f4 ff ff       	jmp    80105edf <alltraps>

80106a3b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $171
80106a3d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a42:	e9 98 f4 ff ff       	jmp    80105edf <alltraps>

80106a47 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $172
80106a49:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a4e:	e9 8c f4 ff ff       	jmp    80105edf <alltraps>

80106a53 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $173
80106a55:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a5a:	e9 80 f4 ff ff       	jmp    80105edf <alltraps>

80106a5f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $174
80106a61:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a66:	e9 74 f4 ff ff       	jmp    80105edf <alltraps>

80106a6b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $175
80106a6d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a72:	e9 68 f4 ff ff       	jmp    80105edf <alltraps>

80106a77 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $176
80106a79:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a7e:	e9 5c f4 ff ff       	jmp    80105edf <alltraps>

80106a83 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $177
80106a85:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a8a:	e9 50 f4 ff ff       	jmp    80105edf <alltraps>

80106a8f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $178
80106a91:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a96:	e9 44 f4 ff ff       	jmp    80105edf <alltraps>

80106a9b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $179
80106a9d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106aa2:	e9 38 f4 ff ff       	jmp    80105edf <alltraps>

80106aa7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $180
80106aa9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106aae:	e9 2c f4 ff ff       	jmp    80105edf <alltraps>

80106ab3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $181
80106ab5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106aba:	e9 20 f4 ff ff       	jmp    80105edf <alltraps>

80106abf <vector182>:
.globl vector182
vector182:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $182
80106ac1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ac6:	e9 14 f4 ff ff       	jmp    80105edf <alltraps>

80106acb <vector183>:
.globl vector183
vector183:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $183
80106acd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ad2:	e9 08 f4 ff ff       	jmp    80105edf <alltraps>

80106ad7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $184
80106ad9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ade:	e9 fc f3 ff ff       	jmp    80105edf <alltraps>

80106ae3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $185
80106ae5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aea:	e9 f0 f3 ff ff       	jmp    80105edf <alltraps>

80106aef <vector186>:
.globl vector186
vector186:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $186
80106af1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106af6:	e9 e4 f3 ff ff       	jmp    80105edf <alltraps>

80106afb <vector187>:
.globl vector187
vector187:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $187
80106afd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b02:	e9 d8 f3 ff ff       	jmp    80105edf <alltraps>

80106b07 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $188
80106b09:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b0e:	e9 cc f3 ff ff       	jmp    80105edf <alltraps>

80106b13 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $189
80106b15:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b1a:	e9 c0 f3 ff ff       	jmp    80105edf <alltraps>

80106b1f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $190
80106b21:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b26:	e9 b4 f3 ff ff       	jmp    80105edf <alltraps>

80106b2b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $191
80106b2d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b32:	e9 a8 f3 ff ff       	jmp    80105edf <alltraps>

80106b37 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $192
80106b39:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b3e:	e9 9c f3 ff ff       	jmp    80105edf <alltraps>

80106b43 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $193
80106b45:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b4a:	e9 90 f3 ff ff       	jmp    80105edf <alltraps>

80106b4f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $194
80106b51:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b56:	e9 84 f3 ff ff       	jmp    80105edf <alltraps>

80106b5b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $195
80106b5d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b62:	e9 78 f3 ff ff       	jmp    80105edf <alltraps>

80106b67 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $196
80106b69:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b6e:	e9 6c f3 ff ff       	jmp    80105edf <alltraps>

80106b73 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $197
80106b75:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b7a:	e9 60 f3 ff ff       	jmp    80105edf <alltraps>

80106b7f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $198
80106b81:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b86:	e9 54 f3 ff ff       	jmp    80105edf <alltraps>

80106b8b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $199
80106b8d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b92:	e9 48 f3 ff ff       	jmp    80105edf <alltraps>

80106b97 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $200
80106b99:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b9e:	e9 3c f3 ff ff       	jmp    80105edf <alltraps>

80106ba3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $201
80106ba5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106baa:	e9 30 f3 ff ff       	jmp    80105edf <alltraps>

80106baf <vector202>:
.globl vector202
vector202:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $202
80106bb1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bb6:	e9 24 f3 ff ff       	jmp    80105edf <alltraps>

80106bbb <vector203>:
.globl vector203
vector203:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $203
80106bbd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bc2:	e9 18 f3 ff ff       	jmp    80105edf <alltraps>

80106bc7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $204
80106bc9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bce:	e9 0c f3 ff ff       	jmp    80105edf <alltraps>

80106bd3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $205
80106bd5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bda:	e9 00 f3 ff ff       	jmp    80105edf <alltraps>

80106bdf <vector206>:
.globl vector206
vector206:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $206
80106be1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106be6:	e9 f4 f2 ff ff       	jmp    80105edf <alltraps>

80106beb <vector207>:
.globl vector207
vector207:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $207
80106bed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bf2:	e9 e8 f2 ff ff       	jmp    80105edf <alltraps>

80106bf7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $208
80106bf9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bfe:	e9 dc f2 ff ff       	jmp    80105edf <alltraps>

80106c03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $209
80106c05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c0a:	e9 d0 f2 ff ff       	jmp    80105edf <alltraps>

80106c0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $210
80106c11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c16:	e9 c4 f2 ff ff       	jmp    80105edf <alltraps>

80106c1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $211
80106c1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c22:	e9 b8 f2 ff ff       	jmp    80105edf <alltraps>

80106c27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $212
80106c29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c2e:	e9 ac f2 ff ff       	jmp    80105edf <alltraps>

80106c33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $213
80106c35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c3a:	e9 a0 f2 ff ff       	jmp    80105edf <alltraps>

80106c3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $214
80106c41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c46:	e9 94 f2 ff ff       	jmp    80105edf <alltraps>

80106c4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $215
80106c4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c52:	e9 88 f2 ff ff       	jmp    80105edf <alltraps>

80106c57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $216
80106c59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c5e:	e9 7c f2 ff ff       	jmp    80105edf <alltraps>

80106c63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $217
80106c65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c6a:	e9 70 f2 ff ff       	jmp    80105edf <alltraps>

80106c6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $218
80106c71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c76:	e9 64 f2 ff ff       	jmp    80105edf <alltraps>

80106c7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $219
80106c7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c82:	e9 58 f2 ff ff       	jmp    80105edf <alltraps>

80106c87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $220
80106c89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c8e:	e9 4c f2 ff ff       	jmp    80105edf <alltraps>

80106c93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $221
80106c95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c9a:	e9 40 f2 ff ff       	jmp    80105edf <alltraps>

80106c9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $222
80106ca1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ca6:	e9 34 f2 ff ff       	jmp    80105edf <alltraps>

80106cab <vector223>:
.globl vector223
vector223:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $223
80106cad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cb2:	e9 28 f2 ff ff       	jmp    80105edf <alltraps>

80106cb7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $224
80106cb9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cbe:	e9 1c f2 ff ff       	jmp    80105edf <alltraps>

80106cc3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $225
80106cc5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cca:	e9 10 f2 ff ff       	jmp    80105edf <alltraps>

80106ccf <vector226>:
.globl vector226
vector226:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $226
80106cd1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106cd6:	e9 04 f2 ff ff       	jmp    80105edf <alltraps>

80106cdb <vector227>:
.globl vector227
vector227:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $227
80106cdd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ce2:	e9 f8 f1 ff ff       	jmp    80105edf <alltraps>

80106ce7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $228
80106ce9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cee:	e9 ec f1 ff ff       	jmp    80105edf <alltraps>

80106cf3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $229
80106cf5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cfa:	e9 e0 f1 ff ff       	jmp    80105edf <alltraps>

80106cff <vector230>:
.globl vector230
vector230:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $230
80106d01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d06:	e9 d4 f1 ff ff       	jmp    80105edf <alltraps>

80106d0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $231
80106d0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d12:	e9 c8 f1 ff ff       	jmp    80105edf <alltraps>

80106d17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $232
80106d19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d1e:	e9 bc f1 ff ff       	jmp    80105edf <alltraps>

80106d23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $233
80106d25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d2a:	e9 b0 f1 ff ff       	jmp    80105edf <alltraps>

80106d2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $234
80106d31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d36:	e9 a4 f1 ff ff       	jmp    80105edf <alltraps>

80106d3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $235
80106d3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d42:	e9 98 f1 ff ff       	jmp    80105edf <alltraps>

80106d47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $236
80106d49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d4e:	e9 8c f1 ff ff       	jmp    80105edf <alltraps>

80106d53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $237
80106d55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d5a:	e9 80 f1 ff ff       	jmp    80105edf <alltraps>

80106d5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $238
80106d61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d66:	e9 74 f1 ff ff       	jmp    80105edf <alltraps>

80106d6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $239
80106d6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d72:	e9 68 f1 ff ff       	jmp    80105edf <alltraps>

80106d77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $240
80106d79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d7e:	e9 5c f1 ff ff       	jmp    80105edf <alltraps>

80106d83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $241
80106d85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d8a:	e9 50 f1 ff ff       	jmp    80105edf <alltraps>

80106d8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $242
80106d91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d96:	e9 44 f1 ff ff       	jmp    80105edf <alltraps>

80106d9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $243
80106d9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106da2:	e9 38 f1 ff ff       	jmp    80105edf <alltraps>

80106da7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $244
80106da9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dae:	e9 2c f1 ff ff       	jmp    80105edf <alltraps>

80106db3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $245
80106db5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dba:	e9 20 f1 ff ff       	jmp    80105edf <alltraps>

80106dbf <vector246>:
.globl vector246
vector246:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $246
80106dc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106dc6:	e9 14 f1 ff ff       	jmp    80105edf <alltraps>

80106dcb <vector247>:
.globl vector247
vector247:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $247
80106dcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106dd2:	e9 08 f1 ff ff       	jmp    80105edf <alltraps>

80106dd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $248
80106dd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dde:	e9 fc f0 ff ff       	jmp    80105edf <alltraps>

80106de3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $249
80106de5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dea:	e9 f0 f0 ff ff       	jmp    80105edf <alltraps>

80106def <vector250>:
.globl vector250
vector250:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $250
80106df1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106df6:	e9 e4 f0 ff ff       	jmp    80105edf <alltraps>

80106dfb <vector251>:
.globl vector251
vector251:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $251
80106dfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e02:	e9 d8 f0 ff ff       	jmp    80105edf <alltraps>

80106e07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $252
80106e09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e0e:	e9 cc f0 ff ff       	jmp    80105edf <alltraps>

80106e13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $253
80106e15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e1a:	e9 c0 f0 ff ff       	jmp    80105edf <alltraps>

80106e1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $254
80106e21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e26:	e9 b4 f0 ff ff       	jmp    80105edf <alltraps>

80106e2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $255
80106e2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e32:	e9 a8 f0 ff ff       	jmp    80105edf <alltraps>
80106e37:	66 90                	xchg   %ax,%ax
80106e39:	66 90                	xchg   %ax,%ax
80106e3b:	66 90                	xchg   %ax,%ax
80106e3d:	66 90                	xchg   %ax,%ax
80106e3f:	90                   	nop

80106e40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e46:	89 d3                	mov    %edx,%ebx
{
80106e48:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e4a:	c1 eb 16             	shr    $0x16,%ebx
80106e4d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e50:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e53:	8b 06                	mov    (%esi),%eax
80106e55:	a8 01                	test   $0x1,%al
80106e57:	74 27                	je     80106e80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e5e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e64:	c1 ef 0a             	shr    $0xa,%edi
}
80106e67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e6a:	89 fa                	mov    %edi,%edx
80106e6c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e72:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e75:	5b                   	pop    %ebx
80106e76:	5e                   	pop    %esi
80106e77:	5f                   	pop    %edi
80106e78:	5d                   	pop    %ebp
80106e79:	c3                   	ret    
80106e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e80:	85 c9                	test   %ecx,%ecx
80106e82:	74 2c                	je     80106eb0 <walkpgdir+0x70>
80106e84:	e8 77 b6 ff ff       	call   80102500 <kalloc>
80106e89:	85 c0                	test   %eax,%eax
80106e8b:	89 c3                	mov    %eax,%ebx
80106e8d:	74 21                	je     80106eb0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e8f:	83 ec 04             	sub    $0x4,%esp
80106e92:	68 00 10 00 00       	push   $0x1000
80106e97:	6a 00                	push   $0x0
80106e99:	50                   	push   %eax
80106e9a:	e8 81 dd ff ff       	call   80104c20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e9f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ea5:	83 c4 10             	add    $0x10,%esp
80106ea8:	83 c8 07             	or     $0x7,%eax
80106eab:	89 06                	mov    %eax,(%esi)
80106ead:	eb b5                	jmp    80106e64 <walkpgdir+0x24>
80106eaf:	90                   	nop
}
80106eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106eb3:	31 c0                	xor    %eax,%eax
}
80106eb5:	5b                   	pop    %ebx
80106eb6:	5e                   	pop    %esi
80106eb7:	5f                   	pop    %edi
80106eb8:	5d                   	pop    %ebp
80106eb9:	c3                   	ret    
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ec0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ec6:	89 d3                	mov    %edx,%ebx
80106ec8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ece:	83 ec 1c             	sub    $0x1c,%esp
80106ed1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ed4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ed8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106edb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ee0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee6:	29 df                	sub    %ebx,%edi
80106ee8:	83 c8 01             	or     $0x1,%eax
80106eeb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106eee:	eb 15                	jmp    80106f05 <mappages+0x45>
    if(*pte & PTE_P)
80106ef0:	f6 00 01             	testb  $0x1,(%eax)
80106ef3:	75 45                	jne    80106f3a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ef5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ef8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106efb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106efd:	74 31                	je     80106f30 <mappages+0x70>
      break;
    a += PGSIZE;
80106eff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f08:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f0d:	89 da                	mov    %ebx,%edx
80106f0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f12:	e8 29 ff ff ff       	call   80106e40 <walkpgdir>
80106f17:	85 c0                	test   %eax,%eax
80106f19:	75 d5                	jne    80106ef0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f23:	5b                   	pop    %ebx
80106f24:	5e                   	pop    %esi
80106f25:	5f                   	pop    %edi
80106f26:	5d                   	pop    %ebp
80106f27:	c3                   	ret    
80106f28:	90                   	nop
80106f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f33:	31 c0                	xor    %eax,%eax
}
80106f35:	5b                   	pop    %ebx
80106f36:	5e                   	pop    %esi
80106f37:	5f                   	pop    %edi
80106f38:	5d                   	pop    %ebp
80106f39:	c3                   	ret    
      panic("remap");
80106f3a:	83 ec 0c             	sub    $0xc,%esp
80106f3d:	68 b4 80 10 80       	push   $0x801080b4
80106f42:	e8 49 94 ff ff       	call   80100390 <panic>
80106f47:	89 f6                	mov    %esi,%esi
80106f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f50 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	57                   	push   %edi
80106f54:	56                   	push   %esi
80106f55:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f56:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f5c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106f5e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f64:	83 ec 1c             	sub    $0x1c,%esp
80106f67:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f6a:	39 d3                	cmp    %edx,%ebx
80106f6c:	73 66                	jae    80106fd4 <deallocuvm.part.0+0x84>
80106f6e:	89 d6                	mov    %edx,%esi
80106f70:	eb 3d                	jmp    80106faf <deallocuvm.part.0+0x5f>
80106f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f78:	8b 10                	mov    (%eax),%edx
80106f7a:	f6 c2 01             	test   $0x1,%dl
80106f7d:	74 26                	je     80106fa5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f7f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106f85:	74 58                	je     80106fdf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f8a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106f90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106f93:	52                   	push   %edx
80106f94:	e8 b7 b3 ff ff       	call   80102350 <kfree>
      *pte = 0;
80106f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f9c:	83 c4 10             	add    $0x10,%esp
80106f9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106fa5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fab:	39 f3                	cmp    %esi,%ebx
80106fad:	73 25                	jae    80106fd4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106faf:	31 c9                	xor    %ecx,%ecx
80106fb1:	89 da                	mov    %ebx,%edx
80106fb3:	89 f8                	mov    %edi,%eax
80106fb5:	e8 86 fe ff ff       	call   80106e40 <walkpgdir>
    if(!pte)
80106fba:	85 c0                	test   %eax,%eax
80106fbc:	75 ba                	jne    80106f78 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106fbe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106fc4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106fca:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fd0:	39 f3                	cmp    %esi,%ebx
80106fd2:	72 db                	jb     80106faf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106fd4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fda:	5b                   	pop    %ebx
80106fdb:	5e                   	pop    %esi
80106fdc:	5f                   	pop    %edi
80106fdd:	5d                   	pop    %ebp
80106fde:	c3                   	ret    
        panic("kfree");
80106fdf:	83 ec 0c             	sub    $0xc,%esp
80106fe2:	68 e6 79 10 80       	push   $0x801079e6
80106fe7:	e8 a4 93 ff ff       	call   80100390 <panic>
80106fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <seginit>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ff6:	e8 d5 c7 ff ff       	call   801037d0 <cpuid>
80106ffb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107001:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107006:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010700a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107011:	ff 00 00 
80107014:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010701b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010701e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107025:	ff 00 00 
80107028:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
8010702f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107032:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80107039:	ff 00 00 
8010703c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107043:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107046:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
8010704d:	ff 00 00 
80107050:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80107057:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010705a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
8010705f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107063:	c1 e8 10             	shr    $0x10,%eax
80107066:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010706a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010706d:	0f 01 10             	lgdtl  (%eax)
}
80107070:	c9                   	leave  
80107071:	c3                   	ret    
80107072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107080:	a1 a4 a9 11 80       	mov    0x8011a9a4,%eax
{
80107085:	55                   	push   %ebp
80107086:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107088:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010708d:	0f 22 d8             	mov    %eax,%cr3
}
80107090:	5d                   	pop    %ebp
80107091:	c3                   	ret    
80107092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <switchuvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
801070a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801070ac:	85 db                	test   %ebx,%ebx
801070ae:	0f 84 cb 00 00 00    	je     8010717f <switchuvm+0xdf>
  if(p->kstack == 0)
801070b4:	8b 43 08             	mov    0x8(%ebx),%eax
801070b7:	85 c0                	test   %eax,%eax
801070b9:	0f 84 da 00 00 00    	je     80107199 <switchuvm+0xf9>
  if(p->pgdir == 0)
801070bf:	8b 43 04             	mov    0x4(%ebx),%eax
801070c2:	85 c0                	test   %eax,%eax
801070c4:	0f 84 c2 00 00 00    	je     8010718c <switchuvm+0xec>
  pushcli();
801070ca:	e8 71 d9 ff ff       	call   80104a40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070cf:	e8 7c c6 ff ff       	call   80103750 <mycpu>
801070d4:	89 c6                	mov    %eax,%esi
801070d6:	e8 75 c6 ff ff       	call   80103750 <mycpu>
801070db:	89 c7                	mov    %eax,%edi
801070dd:	e8 6e c6 ff ff       	call   80103750 <mycpu>
801070e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070e5:	83 c7 08             	add    $0x8,%edi
801070e8:	e8 63 c6 ff ff       	call   80103750 <mycpu>
801070ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801070f0:	83 c0 08             	add    $0x8,%eax
801070f3:	ba 67 00 00 00       	mov    $0x67,%edx
801070f8:	c1 e8 18             	shr    $0x18,%eax
801070fb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107102:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107109:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010710f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107114:	83 c1 08             	add    $0x8,%ecx
80107117:	c1 e9 10             	shr    $0x10,%ecx
8010711a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107120:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107125:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010712c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107131:	e8 1a c6 ff ff       	call   80103750 <mycpu>
80107136:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010713d:	e8 0e c6 ff ff       	call   80103750 <mycpu>
80107142:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107146:	8b 73 08             	mov    0x8(%ebx),%esi
80107149:	e8 02 c6 ff ff       	call   80103750 <mycpu>
8010714e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107154:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107157:	e8 f4 c5 ff ff       	call   80103750 <mycpu>
8010715c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107160:	b8 28 00 00 00       	mov    $0x28,%eax
80107165:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107168:	8b 43 04             	mov    0x4(%ebx),%eax
8010716b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107170:	0f 22 d8             	mov    %eax,%cr3
}
80107173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107176:	5b                   	pop    %ebx
80107177:	5e                   	pop    %esi
80107178:	5f                   	pop    %edi
80107179:	5d                   	pop    %ebp
  popcli();
8010717a:	e9 01 d9 ff ff       	jmp    80104a80 <popcli>
    panic("switchuvm: no process");
8010717f:	83 ec 0c             	sub    $0xc,%esp
80107182:	68 ba 80 10 80       	push   $0x801080ba
80107187:	e8 04 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010718c:	83 ec 0c             	sub    $0xc,%esp
8010718f:	68 e5 80 10 80       	push   $0x801080e5
80107194:	e8 f7 91 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107199:	83 ec 0c             	sub    $0xc,%esp
8010719c:	68 d0 80 10 80       	push   $0x801080d0
801071a1:	e8 ea 91 ff ff       	call   80100390 <panic>
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <inituvm>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
801071b9:	8b 75 10             	mov    0x10(%ebp),%esi
801071bc:	8b 45 08             	mov    0x8(%ebp),%eax
801071bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801071c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801071c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801071cb:	77 49                	ja     80107216 <inituvm+0x66>
  mem = kalloc();
801071cd:	e8 2e b3 ff ff       	call   80102500 <kalloc>
  memset(mem, 0, PGSIZE);
801071d2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801071d5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801071d7:	68 00 10 00 00       	push   $0x1000
801071dc:	6a 00                	push   $0x0
801071de:	50                   	push   %eax
801071df:	e8 3c da ff ff       	call   80104c20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801071e4:	58                   	pop    %eax
801071e5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801071eb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801071f0:	5a                   	pop    %edx
801071f1:	6a 06                	push   $0x6
801071f3:	50                   	push   %eax
801071f4:	31 d2                	xor    %edx,%edx
801071f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f9:	e8 c2 fc ff ff       	call   80106ec0 <mappages>
  memmove(mem, init, sz);
801071fe:	89 75 10             	mov    %esi,0x10(%ebp)
80107201:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107204:	83 c4 10             	add    $0x10,%esp
80107207:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010720a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010720d:	5b                   	pop    %ebx
8010720e:	5e                   	pop    %esi
8010720f:	5f                   	pop    %edi
80107210:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107211:	e9 ba da ff ff       	jmp    80104cd0 <memmove>
    panic("inituvm: more than a page");
80107216:	83 ec 0c             	sub    $0xc,%esp
80107219:	68 f9 80 10 80       	push   $0x801080f9
8010721e:	e8 6d 91 ff ff       	call   80100390 <panic>
80107223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107230 <loaduvm>:
{
80107230:	55                   	push   %ebp
80107231:	89 e5                	mov    %esp,%ebp
80107233:	57                   	push   %edi
80107234:	56                   	push   %esi
80107235:	53                   	push   %ebx
80107236:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107239:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107240:	0f 85 91 00 00 00    	jne    801072d7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107246:	8b 75 18             	mov    0x18(%ebp),%esi
80107249:	31 db                	xor    %ebx,%ebx
8010724b:	85 f6                	test   %esi,%esi
8010724d:	75 1a                	jne    80107269 <loaduvm+0x39>
8010724f:	eb 6f                	jmp    801072c0 <loaduvm+0x90>
80107251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107258:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010725e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107264:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107267:	76 57                	jbe    801072c0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107269:	8b 55 0c             	mov    0xc(%ebp),%edx
8010726c:	8b 45 08             	mov    0x8(%ebp),%eax
8010726f:	31 c9                	xor    %ecx,%ecx
80107271:	01 da                	add    %ebx,%edx
80107273:	e8 c8 fb ff ff       	call   80106e40 <walkpgdir>
80107278:	85 c0                	test   %eax,%eax
8010727a:	74 4e                	je     801072ca <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010727c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010727e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107281:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107286:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010728b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107291:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107294:	01 d9                	add    %ebx,%ecx
80107296:	05 00 00 00 80       	add    $0x80000000,%eax
8010729b:	57                   	push   %edi
8010729c:	51                   	push   %ecx
8010729d:	50                   	push   %eax
8010729e:	ff 75 10             	pushl  0x10(%ebp)
801072a1:	e8 ea a6 ff ff       	call   80101990 <readi>
801072a6:	83 c4 10             	add    $0x10,%esp
801072a9:	39 f8                	cmp    %edi,%eax
801072ab:	74 ab                	je     80107258 <loaduvm+0x28>
}
801072ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072c3:	31 c0                	xor    %eax,%eax
}
801072c5:	5b                   	pop    %ebx
801072c6:	5e                   	pop    %esi
801072c7:	5f                   	pop    %edi
801072c8:	5d                   	pop    %ebp
801072c9:	c3                   	ret    
      panic("loaduvm: address should exist");
801072ca:	83 ec 0c             	sub    $0xc,%esp
801072cd:	68 13 81 10 80       	push   $0x80108113
801072d2:	e8 b9 90 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801072d7:	83 ec 0c             	sub    $0xc,%esp
801072da:	68 b4 81 10 80       	push   $0x801081b4
801072df:	e8 ac 90 ff ff       	call   80100390 <panic>
801072e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801072ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072f0 <allocuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801072f9:	8b 7d 10             	mov    0x10(%ebp),%edi
801072fc:	85 ff                	test   %edi,%edi
801072fe:	0f 88 8e 00 00 00    	js     80107392 <allocuvm+0xa2>
  if(newsz < oldsz)
80107304:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107307:	0f 82 93 00 00 00    	jb     801073a0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010730d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107310:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107316:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010731c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010731f:	0f 86 7e 00 00 00    	jbe    801073a3 <allocuvm+0xb3>
80107325:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107328:	8b 7d 08             	mov    0x8(%ebp),%edi
8010732b:	eb 42                	jmp    8010736f <allocuvm+0x7f>
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107330:	83 ec 04             	sub    $0x4,%esp
80107333:	68 00 10 00 00       	push   $0x1000
80107338:	6a 00                	push   $0x0
8010733a:	50                   	push   %eax
8010733b:	e8 e0 d8 ff ff       	call   80104c20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107340:	58                   	pop    %eax
80107341:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107347:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010734c:	5a                   	pop    %edx
8010734d:	6a 06                	push   $0x6
8010734f:	50                   	push   %eax
80107350:	89 da                	mov    %ebx,%edx
80107352:	89 f8                	mov    %edi,%eax
80107354:	e8 67 fb ff ff       	call   80106ec0 <mappages>
80107359:	83 c4 10             	add    $0x10,%esp
8010735c:	85 c0                	test   %eax,%eax
8010735e:	78 50                	js     801073b0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107360:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107366:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107369:	0f 86 81 00 00 00    	jbe    801073f0 <allocuvm+0x100>
    mem = kalloc();
8010736f:	e8 8c b1 ff ff       	call   80102500 <kalloc>
    if(mem == 0){
80107374:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107376:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107378:	75 b6                	jne    80107330 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010737a:	83 ec 0c             	sub    $0xc,%esp
8010737d:	68 31 81 10 80       	push   $0x80108131
80107382:	e8 d9 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107387:	83 c4 10             	add    $0x10,%esp
8010738a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010738d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107390:	77 6e                	ja     80107400 <allocuvm+0x110>
}
80107392:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107395:	31 ff                	xor    %edi,%edi
}
80107397:	89 f8                	mov    %edi,%eax
80107399:	5b                   	pop    %ebx
8010739a:	5e                   	pop    %esi
8010739b:	5f                   	pop    %edi
8010739c:	5d                   	pop    %ebp
8010739d:	c3                   	ret    
8010739e:	66 90                	xchg   %ax,%ax
    return oldsz;
801073a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801073a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a6:	89 f8                	mov    %edi,%eax
801073a8:	5b                   	pop    %ebx
801073a9:	5e                   	pop    %esi
801073aa:	5f                   	pop    %edi
801073ab:	5d                   	pop    %ebp
801073ac:	c3                   	ret    
801073ad:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801073b0:	83 ec 0c             	sub    $0xc,%esp
801073b3:	68 49 81 10 80       	push   $0x80108149
801073b8:	e8 a3 92 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801073bd:	83 c4 10             	add    $0x10,%esp
801073c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c3:	39 45 10             	cmp    %eax,0x10(%ebp)
801073c6:	76 0d                	jbe    801073d5 <allocuvm+0xe5>
801073c8:	89 c1                	mov    %eax,%ecx
801073ca:	8b 55 10             	mov    0x10(%ebp),%edx
801073cd:	8b 45 08             	mov    0x8(%ebp),%eax
801073d0:	e8 7b fb ff ff       	call   80106f50 <deallocuvm.part.0>
      kfree(mem);
801073d5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801073d8:	31 ff                	xor    %edi,%edi
      kfree(mem);
801073da:	56                   	push   %esi
801073db:	e8 70 af ff ff       	call   80102350 <kfree>
      return 0;
801073e0:	83 c4 10             	add    $0x10,%esp
}
801073e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e6:	89 f8                	mov    %edi,%eax
801073e8:	5b                   	pop    %ebx
801073e9:	5e                   	pop    %esi
801073ea:	5f                   	pop    %edi
801073eb:	5d                   	pop    %ebp
801073ec:	c3                   	ret    
801073ed:	8d 76 00             	lea    0x0(%esi),%esi
801073f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801073f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073f6:	5b                   	pop    %ebx
801073f7:	89 f8                	mov    %edi,%eax
801073f9:	5e                   	pop    %esi
801073fa:	5f                   	pop    %edi
801073fb:	5d                   	pop    %ebp
801073fc:	c3                   	ret    
801073fd:	8d 76 00             	lea    0x0(%esi),%esi
80107400:	89 c1                	mov    %eax,%ecx
80107402:	8b 55 10             	mov    0x10(%ebp),%edx
80107405:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107408:	31 ff                	xor    %edi,%edi
8010740a:	e8 41 fb ff ff       	call   80106f50 <deallocuvm.part.0>
8010740f:	eb 92                	jmp    801073a3 <allocuvm+0xb3>
80107411:	eb 0d                	jmp    80107420 <deallocuvm>
80107413:	90                   	nop
80107414:	90                   	nop
80107415:	90                   	nop
80107416:	90                   	nop
80107417:	90                   	nop
80107418:	90                   	nop
80107419:	90                   	nop
8010741a:	90                   	nop
8010741b:	90                   	nop
8010741c:	90                   	nop
8010741d:	90                   	nop
8010741e:	90                   	nop
8010741f:	90                   	nop

80107420 <deallocuvm>:
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	8b 55 0c             	mov    0xc(%ebp),%edx
80107426:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107429:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010742c:	39 d1                	cmp    %edx,%ecx
8010742e:	73 10                	jae    80107440 <deallocuvm+0x20>
}
80107430:	5d                   	pop    %ebp
80107431:	e9 1a fb ff ff       	jmp    80106f50 <deallocuvm.part.0>
80107436:	8d 76 00             	lea    0x0(%esi),%esi
80107439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107440:	89 d0                	mov    %edx,%eax
80107442:	5d                   	pop    %ebp
80107443:	c3                   	ret    
80107444:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010744a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107450 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010745c:	85 f6                	test   %esi,%esi
8010745e:	74 59                	je     801074b9 <freevm+0x69>
80107460:	31 c9                	xor    %ecx,%ecx
80107462:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107467:	89 f0                	mov    %esi,%eax
80107469:	e8 e2 fa ff ff       	call   80106f50 <deallocuvm.part.0>
8010746e:	89 f3                	mov    %esi,%ebx
80107470:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107476:	eb 0f                	jmp    80107487 <freevm+0x37>
80107478:	90                   	nop
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107480:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107483:	39 fb                	cmp    %edi,%ebx
80107485:	74 23                	je     801074aa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107487:	8b 03                	mov    (%ebx),%eax
80107489:	a8 01                	test   $0x1,%al
8010748b:	74 f3                	je     80107480 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010748d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107492:	83 ec 0c             	sub    $0xc,%esp
80107495:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107498:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010749d:	50                   	push   %eax
8010749e:	e8 ad ae ff ff       	call   80102350 <kfree>
801074a3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801074a6:	39 fb                	cmp    %edi,%ebx
801074a8:	75 dd                	jne    80107487 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801074aa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074b0:	5b                   	pop    %ebx
801074b1:	5e                   	pop    %esi
801074b2:	5f                   	pop    %edi
801074b3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801074b4:	e9 97 ae ff ff       	jmp    80102350 <kfree>
    panic("freevm: no pgdir");
801074b9:	83 ec 0c             	sub    $0xc,%esp
801074bc:	68 65 81 10 80       	push   $0x80108165
801074c1:	e8 ca 8e ff ff       	call   80100390 <panic>
801074c6:	8d 76 00             	lea    0x0(%esi),%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <setupkvm>:
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	56                   	push   %esi
801074d4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801074d5:	e8 26 b0 ff ff       	call   80102500 <kalloc>
801074da:	85 c0                	test   %eax,%eax
801074dc:	89 c6                	mov    %eax,%esi
801074de:	74 42                	je     80107522 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801074e0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074e3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801074e8:	68 00 10 00 00       	push   $0x1000
801074ed:	6a 00                	push   $0x0
801074ef:	50                   	push   %eax
801074f0:	e8 2b d7 ff ff       	call   80104c20 <memset>
801074f5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801074f8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801074fb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801074fe:	83 ec 08             	sub    $0x8,%esp
80107501:	8b 13                	mov    (%ebx),%edx
80107503:	ff 73 0c             	pushl  0xc(%ebx)
80107506:	50                   	push   %eax
80107507:	29 c1                	sub    %eax,%ecx
80107509:	89 f0                	mov    %esi,%eax
8010750b:	e8 b0 f9 ff ff       	call   80106ec0 <mappages>
80107510:	83 c4 10             	add    $0x10,%esp
80107513:	85 c0                	test   %eax,%eax
80107515:	78 19                	js     80107530 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107517:	83 c3 10             	add    $0x10,%ebx
8010751a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107520:	75 d6                	jne    801074f8 <setupkvm+0x28>
}
80107522:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107525:	89 f0                	mov    %esi,%eax
80107527:	5b                   	pop    %ebx
80107528:	5e                   	pop    %esi
80107529:	5d                   	pop    %ebp
8010752a:	c3                   	ret    
8010752b:	90                   	nop
8010752c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107530:	83 ec 0c             	sub    $0xc,%esp
80107533:	56                   	push   %esi
      return 0;
80107534:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107536:	e8 15 ff ff ff       	call   80107450 <freevm>
      return 0;
8010753b:	83 c4 10             	add    $0x10,%esp
}
8010753e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107541:	89 f0                	mov    %esi,%eax
80107543:	5b                   	pop    %ebx
80107544:	5e                   	pop    %esi
80107545:	5d                   	pop    %ebp
80107546:	c3                   	ret    
80107547:	89 f6                	mov    %esi,%esi
80107549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107550 <kvmalloc>:
{
80107550:	55                   	push   %ebp
80107551:	89 e5                	mov    %esp,%ebp
80107553:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107556:	e8 75 ff ff ff       	call   801074d0 <setupkvm>
8010755b:	a3 a4 a9 11 80       	mov    %eax,0x8011a9a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107560:	05 00 00 00 80       	add    $0x80000000,%eax
80107565:	0f 22 d8             	mov    %eax,%cr3
}
80107568:	c9                   	leave  
80107569:	c3                   	ret    
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107570:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107571:	31 c9                	xor    %ecx,%ecx
{
80107573:	89 e5                	mov    %esp,%ebp
80107575:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107578:	8b 55 0c             	mov    0xc(%ebp),%edx
8010757b:	8b 45 08             	mov    0x8(%ebp),%eax
8010757e:	e8 bd f8 ff ff       	call   80106e40 <walkpgdir>
  if(pte == 0)
80107583:	85 c0                	test   %eax,%eax
80107585:	74 05                	je     8010758c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107587:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010758a:	c9                   	leave  
8010758b:	c3                   	ret    
    panic("clearpteu");
8010758c:	83 ec 0c             	sub    $0xc,%esp
8010758f:	68 76 81 10 80       	push   $0x80108176
80107594:	e8 f7 8d ff ff       	call   80100390 <panic>
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075a9:	e8 22 ff ff ff       	call   801074d0 <setupkvm>
801075ae:	85 c0                	test   %eax,%eax
801075b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075b3:	0f 84 9f 00 00 00    	je     80107658 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075bc:	85 c9                	test   %ecx,%ecx
801075be:	0f 84 94 00 00 00    	je     80107658 <copyuvm+0xb8>
801075c4:	31 ff                	xor    %edi,%edi
801075c6:	eb 4a                	jmp    80107612 <copyuvm+0x72>
801075c8:	90                   	nop
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801075d0:	83 ec 04             	sub    $0x4,%esp
801075d3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801075d9:	68 00 10 00 00       	push   $0x1000
801075de:	53                   	push   %ebx
801075df:	50                   	push   %eax
801075e0:	e8 eb d6 ff ff       	call   80104cd0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801075e5:	58                   	pop    %eax
801075e6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801075ec:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075f1:	5a                   	pop    %edx
801075f2:	ff 75 e4             	pushl  -0x1c(%ebp)
801075f5:	50                   	push   %eax
801075f6:	89 fa                	mov    %edi,%edx
801075f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075fb:	e8 c0 f8 ff ff       	call   80106ec0 <mappages>
80107600:	83 c4 10             	add    $0x10,%esp
80107603:	85 c0                	test   %eax,%eax
80107605:	78 61                	js     80107668 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107607:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010760d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107610:	76 46                	jbe    80107658 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107612:	8b 45 08             	mov    0x8(%ebp),%eax
80107615:	31 c9                	xor    %ecx,%ecx
80107617:	89 fa                	mov    %edi,%edx
80107619:	e8 22 f8 ff ff       	call   80106e40 <walkpgdir>
8010761e:	85 c0                	test   %eax,%eax
80107620:	74 61                	je     80107683 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107622:	8b 00                	mov    (%eax),%eax
80107624:	a8 01                	test   $0x1,%al
80107626:	74 4e                	je     80107676 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107628:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010762a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010762f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107638:	e8 c3 ae ff ff       	call   80102500 <kalloc>
8010763d:	85 c0                	test   %eax,%eax
8010763f:	89 c6                	mov    %eax,%esi
80107641:	75 8d                	jne    801075d0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107643:	83 ec 0c             	sub    $0xc,%esp
80107646:	ff 75 e0             	pushl  -0x20(%ebp)
80107649:	e8 02 fe ff ff       	call   80107450 <freevm>
  return 0;
8010764e:	83 c4 10             	add    $0x10,%esp
80107651:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107658:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010765b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010765e:	5b                   	pop    %ebx
8010765f:	5e                   	pop    %esi
80107660:	5f                   	pop    %edi
80107661:	5d                   	pop    %ebp
80107662:	c3                   	ret    
80107663:	90                   	nop
80107664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	56                   	push   %esi
8010766c:	e8 df ac ff ff       	call   80102350 <kfree>
      goto bad;
80107671:	83 c4 10             	add    $0x10,%esp
80107674:	eb cd                	jmp    80107643 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107676:	83 ec 0c             	sub    $0xc,%esp
80107679:	68 9a 81 10 80       	push   $0x8010819a
8010767e:	e8 0d 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107683:	83 ec 0c             	sub    $0xc,%esp
80107686:	68 80 81 10 80       	push   $0x80108180
8010768b:	e8 00 8d ff ff       	call   80100390 <panic>

80107690 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107690:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107691:	31 c9                	xor    %ecx,%ecx
{
80107693:	89 e5                	mov    %esp,%ebp
80107695:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107698:	8b 55 0c             	mov    0xc(%ebp),%edx
8010769b:	8b 45 08             	mov    0x8(%ebp),%eax
8010769e:	e8 9d f7 ff ff       	call   80106e40 <walkpgdir>
  if((*pte & PTE_P) == 0)
801076a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801076a5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801076a6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801076ad:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801076b0:	05 00 00 00 80       	add    $0x80000000,%eax
801076b5:	83 fa 05             	cmp    $0x5,%edx
801076b8:	ba 00 00 00 00       	mov    $0x0,%edx
801076bd:	0f 45 c2             	cmovne %edx,%eax
}
801076c0:	c3                   	ret    
801076c1:	eb 0d                	jmp    801076d0 <copyout>
801076c3:	90                   	nop
801076c4:	90                   	nop
801076c5:	90                   	nop
801076c6:	90                   	nop
801076c7:	90                   	nop
801076c8:	90                   	nop
801076c9:	90                   	nop
801076ca:	90                   	nop
801076cb:	90                   	nop
801076cc:	90                   	nop
801076cd:	90                   	nop
801076ce:	90                   	nop
801076cf:	90                   	nop

801076d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 1c             	sub    $0x1c,%esp
801076d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801076dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801076df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801076e2:	85 db                	test   %ebx,%ebx
801076e4:	75 40                	jne    80107726 <copyout+0x56>
801076e6:	eb 70                	jmp    80107758 <copyout+0x88>
801076e8:	90                   	nop
801076e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801076f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076f3:	89 f1                	mov    %esi,%ecx
801076f5:	29 d1                	sub    %edx,%ecx
801076f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801076fd:	39 d9                	cmp    %ebx,%ecx
801076ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107702:	29 f2                	sub    %esi,%edx
80107704:	83 ec 04             	sub    $0x4,%esp
80107707:	01 d0                	add    %edx,%eax
80107709:	51                   	push   %ecx
8010770a:	57                   	push   %edi
8010770b:	50                   	push   %eax
8010770c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010770f:	e8 bc d5 ff ff       	call   80104cd0 <memmove>
    len -= n;
    buf += n;
80107714:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107717:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010771a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107720:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107722:	29 cb                	sub    %ecx,%ebx
80107724:	74 32                	je     80107758 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107726:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107728:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010772b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010772e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107734:	56                   	push   %esi
80107735:	ff 75 08             	pushl  0x8(%ebp)
80107738:	e8 53 ff ff ff       	call   80107690 <uva2ka>
    if(pa0 == 0)
8010773d:	83 c4 10             	add    $0x10,%esp
80107740:	85 c0                	test   %eax,%eax
80107742:	75 ac                	jne    801076f0 <copyout+0x20>
  }
  return 0;
}
80107744:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010774c:	5b                   	pop    %ebx
8010774d:	5e                   	pop    %esi
8010774e:	5f                   	pop    %edi
8010774f:	5d                   	pop    %ebp
80107750:	c3                   	ret    
80107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010775b:	31 c0                	xor    %eax,%eax
}
8010775d:	5b                   	pop    %ebx
8010775e:	5e                   	pop    %esi
8010775f:	5f                   	pop    %edi
80107760:	5d                   	pop    %ebp
80107761:	c3                   	ret    
