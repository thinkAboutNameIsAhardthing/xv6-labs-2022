// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUCKET 13

struct {
  struct spinlock bucket_locks[NBUCKET];
  struct buf buf[NBUF];

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  struct buf heads[NBUCKET];
} bcache;

char names[NBUCKET][10] = {"bcache0", "bcache1", "bcache2", "bcache3", "bcache4", "bcache5", "bcache6", "bcache7", "bcache8", "bcache9", "bcache10", "bcache11", "bcache12"};

void
binit(void)
{
  struct buf *b;

  int i;
  for(i = 0; i < NBUCKET; ++i) {
    initlock(&bcache.bucket_locks[i], names[i]);
    // Create linked list of buffers
    bcache.heads[i].prev = &bcache.heads[i];
    bcache.heads[i].next = &bcache.heads[i];
    for(b = bcache.buf+i; b < bcache.buf+NBUF; b+=NBUCKET){
      b->next = bcache.heads[i].next;
      b->prev = &bcache.heads[i];
      initsleeplock(&b->lock, "buffer");
      bcache.heads[i].next->prev = b;
      bcache.heads[i].next = b;
    }
  }
}

// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;
  int bucketno = blockno % NBUCKET;

  acquire(&bcache.bucket_locks[bucketno]);
  // Is the block already cached?
  for(b = bcache.heads[bucketno].next; b != &bcache.heads[bucketno]; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      b->refcnt++;
      release(&bcache.bucket_locks[bucketno]);
      acquiresleep(&b->lock);
      return b;
    }
  }

  // Not cached.
  // Recycle the least recently used (LRU) unused buffer.
  for(b = bcache.heads[bucketno].next; b != &bcache.heads[bucketno]; b = b->next){
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      release(&bcache.bucket_locks[bucketno]);
      acquiresleep(&b->lock);
      return b;
    }
  }
  for(b = bcache.buf; b < bcache.buf+NBUF; ++b){
    int replace_bucketno = (b - bcache.buf) % NBUCKET;
    if (bucketno != replace_bucketno)
      acquire(&bcache.bucket_locks[replace_bucketno]);
    if(b->refcnt == 0) {
      b->dev = dev;
      b->blockno = blockno;
      b->valid = 0;
      b->refcnt = 1;
      b->prev->next = b->next;
      b->next->prev = b->prev;
      b->next = bcache.heads[bucketno].next;
      b->prev = &bcache.heads[bucketno];
      bcache.heads[bucketno].next = b;
      b->next->prev = b;
      if (bucketno != replace_bucketno)
        release(&bcache.bucket_locks[replace_bucketno]);
      release(&bcache.bucket_locks[bucketno]);
      acquiresleep(&b->lock);
      return b;
    }
    if (bucketno != replace_bucketno)
      release(&bcache.bucket_locks[replace_bucketno]);
  }
  panic("bget: no buffers");
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
  
  int bucketno = b->blockno % NBUCKET;

  releasesleep(&b->lock);

  acquire(&bcache.bucket_locks[bucketno]);
  b->refcnt--;
  release(&bcache.bucket_locks[bucketno]);
}

void
bpin(struct buf *b) {
  int bucketno = b->blockno % NBUCKET;
  acquire(&bcache.bucket_locks[bucketno]);
  b->refcnt++;
  release(&bcache.bucket_locks[bucketno]);
}

void
bunpin(struct buf *b) {
  int bucketno = b->blockno % NBUCKET;
  acquire(&bcache.bucket_locks[bucketno]);
  b->refcnt--;
  release(&bcache.bucket_locks[bucketno]);
}


