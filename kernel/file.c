//
// Support functions for system calls that involve file descriptors.
//

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"
#include "stat.h"
#include "proc.h"
#include "fcntl.h"

struct devsw devsw[NDEV];
struct {
  struct spinlock lock;
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
  initlock(&ftable.lock, "ftable");
}

// Allocate a file structure.
struct file*
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE){
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
  struct proc *p = myproc();
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    ilock(f->ip);
    stati(f->ip, &st);
    iunlock(f->ip);
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
      return -1;
    return 0;
  }
  return -1;
}

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
  int r = 0;

  if(f->readable == 0)
    return -1;

  if(f->type == FD_PIPE){
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
  } else {
    panic("fileread");
  }

  return r;
}

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    return -1;

  if(f->type == FD_PIPE){
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    // write a few blocks at a time to avoid exceeding
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r != n1){
        // error from writei
        break;
      }
      i += r;
    }
    ret = (i == n ? n : -1);
  } else {
    panic("filewrite");
  }

  return ret;
}

int
vma_map_page(pagetable_t pagetable, struct vma* v, uint64 addr)
{
  void* pa;
  if((pa = kalloc()) == 0)
    return -1;
  memset(pa, 0, PGSIZE);

  uint64 va = PGROUNDDOWN(addr);
  // printf("mem allocated: %p for %p\n", pa, va);
  // printf("permission: %d, mode: %d\n", v->permission, v->mode);
  if(mappages(pagetable, va, PGSIZE, (uint64)pa, (v->permission << 1) | PTE_V | PTE_U) != 0){
    panic("fail to map page for vma");
    return -1;
  }
  //vmprint(pagetable);

  // printf("read inode: %p %d\n", va, va - v->addr);
  int size = v->file->ip->size - (va - v->addr);
  if(size > PGSIZE)
    size = PGSIZE;
  if(readi(v->file->ip, 1, va, va - v->addr, size) != size){
    return -1;
  }
  return 0;
}


int
vma_unmap(pagetable_t pagetable, struct vma* v, uint64 addr, int length)
{
  //printf("vma unmap: %p %d %d %d %p %d\n", v->addr, v->length, v->mode, v->permission, addr, length);
  //printf("permission: %d, mode: %d %d\n", v->permission, v->mode, MAP_SHARED);
  int size = v->file->ip->size - v->file->off;
  if(size > length)
    size = length;
  
  //printf("permission: %d, mode: %d\n", v->permission, v->mode);
  if(size >0 && v->mode == MAP_SHARED && (v->permission & PROT_WRITE) != 0 && filewrite(v->file, addr, size) != size)
    return -1;
  
  //uvmunmap(pagetable, addr, PGROUNDUP(length)/PGSIZE, 1);
  pte_t *pte;
  for(uint64 i = addr; i < addr + length; i += PGSIZE){
    if((pte = walk(pagetable, i, 0)) == 0)
      panic("vma unmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
      panic("uvmunmap: not a leaf");
    uint64 pa = PTE2PA(*pte);
    kfree((void*)pa);
    *pte = 0;
  }
  
  if(v->addr == addr && v->length == length){
    //printf("vma unmap free\n");
    v->addr = 0;
    fileclose(v->file);
  } else {
    if(v->addr == addr){
      v->addr += length;
      v->file->off += length;
      v->length -= length;
    }
    else if (addr + length == v->addr + v->length)
      v->length -= length;
  }
  return 0;
}