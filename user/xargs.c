#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc < 2) {
    fprintf(2, "xargs need at least 1 argument");
    exit(1);
  }
  char buf[512], arg[512];
  char* p = buf;
  char* argv1[argc];
  for(int i = 1; i < argc; ++i){
    //printf("%s\n", argv[i]);
    argv1[i-1] = argv[i];
  }
  while (read(0, p, 1))
  {
    //printf("%c\n", *p);
    if(*p == '\n'){
      *p = '\0';
      //printf("%s\n", buf);
      memcpy(arg, buf, sizeof(buf));
      if(fork() == 0){
        argv1[argc-1] = buf;
        // printf("%s\n", argv[0]);
        // for(int i = 0; i < argc; ++i)
        //   printf("%s\n", argv1[i]);
        exec(argv[1], argv1);
        exit(0);
      } else{
        wait(0);
        p = buf;
      }
    } else {
      ++p;
    }
  }

  exit(0);
}
