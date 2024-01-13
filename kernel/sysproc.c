#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  backtrace();
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_sigalarm(void)
{
  int ticks;
  uint64 handler;
  struct proc* p = myproc();

  argint(0, &ticks);
  argaddr(1, &handler);

  if(ticks != 0) {
    p->nticks = ticks;
    p->alarm_handler = handler;
    p->ticks_left = ticks;
  } else {
    p->nticks = 0;
    p->alarm_handler = 0;
    p->ticks_left = 0;
  }
  return 0;
}

uint64
sys_sigreturn(void)
{
  struct proc* p = myproc();

  // memmove(p->trapframe, p->resume_trapframe, PGSIZE);

  p->trapframe->epc = p->resume_epc;
  p->trapframe->ra = p->resume_ra;
  p->trapframe->sp = p->resume_sp;
  p->trapframe->a0 = p->resume_a0;
  p->trapframe->a1 = p->resume_a1;
  p->trapframe->a2 = p->resume_a2;
  p->trapframe->a3 = p->resume_a3;
  p->trapframe->a4 = p->resume_a4;
  p->trapframe->a5 = p->resume_a5;
  p->trapframe->s0 = p->resume_s0;
  p->trapframe->s1 = p->resume_s1;
  p->trapframe->s2 = p->resume_s2;
  p->trapframe->s3 = p->resume_s3;
  p->trapframe->s4 = p->resume_s4;
  p->trapframe->s5 = p->resume_s5;

  p->in_handler = 0;
  return 0;
}
