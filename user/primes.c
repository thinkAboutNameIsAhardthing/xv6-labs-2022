#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void primes(int in){
  //printf("process: %d\n", getpid());
  int prime, number;
  if(read(in, &prime, 4)==0)
    return;
  printf("prime %d\n", prime);
  int p[2];
  pipe(p);
  if(fork()==0){
    //printf("child: %d\n", getpid());
    close(p[1]);
    primes(p[0]);
    close(p[0]);
  }else{
    //printf("parent: %d\n", getpid());
    close(p[0]);
    while(read(in, &number, 4)){
      if(number % prime != 0){
        write(p[1], &number, 4);
      }
    }
    close(p[1]);
  }
  wait(0);
  //printf("process: %d end\n", getpid());
}

int
main(int argc, char *argv[])
{
  int p[2];
  pipe(p);
  for(int i=2;i<=35;++i){
    write(p[1], &i, 4);
  }
  close(p[1]);
  primes(p[0]);
  close(p[0]);

  exit(0);
}

