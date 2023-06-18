
user/_pingpong：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  char buf[1];
  int p[2];
  pipe(p);
   8:	fe040513          	addi	a0,s0,-32
   c:	00000097          	auipc	ra,0x0
  10:	352080e7          	jalr	850(ra) # 35e <pipe>
  int pid = fork();
  14:	00000097          	auipc	ra,0x0
  18:	332080e7          	jalr	818(ra) # 346 <fork>
  if(pid==0){
  1c:	e12d                	bnez	a0,7e <main+0x7e>
    read(p[1], buf, 1);
  1e:	4605                	li	a2,1
  20:	fe840593          	addi	a1,s0,-24
  24:	fe442503          	lw	a0,-28(s0)
  28:	00000097          	auipc	ra,0x0
  2c:	33e080e7          	jalr	830(ra) # 366 <read>
    printf("%d: received ping\n", getpid());
  30:	00000097          	auipc	ra,0x0
  34:	39e080e7          	jalr	926(ra) # 3ce <getpid>
  38:	85aa                	mv	a1,a0
  3a:	00001517          	auipc	a0,0x1
  3e:	83650513          	addi	a0,a0,-1994 # 870 <malloc+0xf0>
  42:	00000097          	auipc	ra,0x0
  46:	686080e7          	jalr	1670(ra) # 6c8 <printf>
    write(p[0], buf, 1);
  4a:	4605                	li	a2,1
  4c:	fe840593          	addi	a1,s0,-24
  50:	fe042503          	lw	a0,-32(s0)
  54:	00000097          	auipc	ra,0x0
  58:	31a080e7          	jalr	794(ra) # 36e <write>
    write(p[0], buf, 1);
    wait(0);
    read(p[1], buf, 1);
    printf("%d: received pong\n", getpid());
  }
  close(p[0]);
  5c:	fe042503          	lw	a0,-32(s0)
  60:	00000097          	auipc	ra,0x0
  64:	316080e7          	jalr	790(ra) # 376 <close>
  close(p[1]);
  68:	fe442503          	lw	a0,-28(s0)
  6c:	00000097          	auipc	ra,0x0
  70:	30a080e7          	jalr	778(ra) # 376 <close>
  exit(0);
  74:	4501                	li	a0,0
  76:	00000097          	auipc	ra,0x0
  7a:	2d8080e7          	jalr	728(ra) # 34e <exit>
    write(p[0], buf, 1);
  7e:	4605                	li	a2,1
  80:	fe840593          	addi	a1,s0,-24
  84:	fe042503          	lw	a0,-32(s0)
  88:	00000097          	auipc	ra,0x0
  8c:	2e6080e7          	jalr	742(ra) # 36e <write>
    wait(0);
  90:	4501                	li	a0,0
  92:	00000097          	auipc	ra,0x0
  96:	2c4080e7          	jalr	708(ra) # 356 <wait>
    read(p[1], buf, 1);
  9a:	4605                	li	a2,1
  9c:	fe840593          	addi	a1,s0,-24
  a0:	fe442503          	lw	a0,-28(s0)
  a4:	00000097          	auipc	ra,0x0
  a8:	2c2080e7          	jalr	706(ra) # 366 <read>
    printf("%d: received pong\n", getpid());
  ac:	00000097          	auipc	ra,0x0
  b0:	322080e7          	jalr	802(ra) # 3ce <getpid>
  b4:	85aa                	mv	a1,a0
  b6:	00000517          	auipc	a0,0x0
  ba:	7d250513          	addi	a0,a0,2002 # 888 <malloc+0x108>
  be:	00000097          	auipc	ra,0x0
  c2:	60a080e7          	jalr	1546(ra) # 6c8 <printf>
  c6:	bf59                	j	5c <main+0x5c>

00000000000000c8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  extern int main();
  main();
  d0:	00000097          	auipc	ra,0x0
  d4:	f30080e7          	jalr	-208(ra) # 0 <main>
  exit(0);
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	274080e7          	jalr	628(ra) # 34e <exit>

00000000000000e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	87aa                	mv	a5,a0
  ea:	0585                	addi	a1,a1,1
  ec:	0785                	addi	a5,a5,1
  ee:	fff5c703          	lbu	a4,-1(a1)
  f2:	fee78fa3          	sb	a4,-1(a5)
  f6:	fb75                	bnez	a4,ea <strcpy+0x8>
    ;
  return os;
}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 104:	00054783          	lbu	a5,0(a0)
 108:	cb91                	beqz	a5,11c <strcmp+0x1e>
 10a:	0005c703          	lbu	a4,0(a1)
 10e:	00f71763          	bne	a4,a5,11c <strcmp+0x1e>
    p++, q++;
 112:	0505                	addi	a0,a0,1
 114:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbe5                	bnez	a5,10a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 11c:	0005c503          	lbu	a0,0(a1)
}
 120:	40a7853b          	subw	a0,a5,a0
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strlen>:

uint
strlen(const char *s)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cf91                	beqz	a5,150 <strlen+0x26>
 136:	0505                	addi	a0,a0,1
 138:	87aa                	mv	a5,a0
 13a:	4685                	li	a3,1
 13c:	9e89                	subw	a3,a3,a0
 13e:	00f6853b          	addw	a0,a3,a5
 142:	0785                	addi	a5,a5,1
 144:	fff7c703          	lbu	a4,-1(a5)
 148:	fb7d                	bnez	a4,13e <strlen+0x14>
    ;
  return n;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for(n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strlen+0x20>

0000000000000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15a:	ca19                	beqz	a2,170 <memset+0x1c>
 15c:	87aa                	mv	a5,a0
 15e:	1602                	slli	a2,a2,0x20
 160:	9201                	srli	a2,a2,0x20
 162:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 166:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16a:	0785                	addi	a5,a5,1
 16c:	fee79de3          	bne	a5,a4,166 <memset+0x12>
  }
  return dst;
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strchr>:

char*
strchr(const char *s, char c)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	cb99                	beqz	a5,196 <strchr+0x20>
    if(*s == c)
 182:	00f58763          	beq	a1,a5,190 <strchr+0x1a>
  for(; *s; s++)
 186:	0505                	addi	a0,a0,1
 188:	00054783          	lbu	a5,0(a0)
 18c:	fbfd                	bnez	a5,182 <strchr+0xc>
      return (char*)s;
  return 0;
 18e:	4501                	li	a0,0
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  return 0;
 196:	4501                	li	a0,0
 198:	bfe5                	j	190 <strchr+0x1a>

000000000000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	711d                	addi	sp,sp,-96
 19c:	ec86                	sd	ra,88(sp)
 19e:	e8a2                	sd	s0,80(sp)
 1a0:	e4a6                	sd	s1,72(sp)
 1a2:	e0ca                	sd	s2,64(sp)
 1a4:	fc4e                	sd	s3,56(sp)
 1a6:	f852                	sd	s4,48(sp)
 1a8:	f456                	sd	s5,40(sp)
 1aa:	f05a                	sd	s6,32(sp)
 1ac:	ec5e                	sd	s7,24(sp)
 1ae:	1080                	addi	s0,sp,96
 1b0:	8baa                	mv	s7,a0
 1b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	892a                	mv	s2,a0
 1b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b8:	4aa9                	li	s5,10
 1ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1bc:	89a6                	mv	s3,s1
 1be:	2485                	addiw	s1,s1,1
 1c0:	0344d863          	bge	s1,s4,1f0 <gets+0x56>
    cc = read(0, &c, 1);
 1c4:	4605                	li	a2,1
 1c6:	faf40593          	addi	a1,s0,-81
 1ca:	4501                	li	a0,0
 1cc:	00000097          	auipc	ra,0x0
 1d0:	19a080e7          	jalr	410(ra) # 366 <read>
    if(cc < 1)
 1d4:	00a05e63          	blez	a0,1f0 <gets+0x56>
    buf[i++] = c;
 1d8:	faf44783          	lbu	a5,-81(s0)
 1dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e0:	01578763          	beq	a5,s5,1ee <gets+0x54>
 1e4:	0905                	addi	s2,s2,1
 1e6:	fd679be3          	bne	a5,s6,1bc <gets+0x22>
  for(i=0; i+1 < max; ){
 1ea:	89a6                	mv	s3,s1
 1ec:	a011                	j	1f0 <gets+0x56>
 1ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f0:	99de                	add	s3,s3,s7
 1f2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f6:	855e                	mv	a0,s7
 1f8:	60e6                	ld	ra,88(sp)
 1fa:	6446                	ld	s0,80(sp)
 1fc:	64a6                	ld	s1,72(sp)
 1fe:	6906                	ld	s2,64(sp)
 200:	79e2                	ld	s3,56(sp)
 202:	7a42                	ld	s4,48(sp)
 204:	7aa2                	ld	s5,40(sp)
 206:	7b02                	ld	s6,32(sp)
 208:	6be2                	ld	s7,24(sp)
 20a:	6125                	addi	sp,sp,96
 20c:	8082                	ret

000000000000020e <stat>:

int
stat(const char *n, struct stat *st)
{
 20e:	1101                	addi	sp,sp,-32
 210:	ec06                	sd	ra,24(sp)
 212:	e822                	sd	s0,16(sp)
 214:	e426                	sd	s1,8(sp)
 216:	e04a                	sd	s2,0(sp)
 218:	1000                	addi	s0,sp,32
 21a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21c:	4581                	li	a1,0
 21e:	00000097          	auipc	ra,0x0
 222:	170080e7          	jalr	368(ra) # 38e <open>
  if(fd < 0)
 226:	02054563          	bltz	a0,250 <stat+0x42>
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	00000097          	auipc	ra,0x0
 232:	178080e7          	jalr	376(ra) # 3a6 <fstat>
 236:	892a                	mv	s2,a0
  close(fd);
 238:	8526                	mv	a0,s1
 23a:	00000097          	auipc	ra,0x0
 23e:	13c080e7          	jalr	316(ra) # 376 <close>
  return r;
}
 242:	854a                	mv	a0,s2
 244:	60e2                	ld	ra,24(sp)
 246:	6442                	ld	s0,16(sp)
 248:	64a2                	ld	s1,8(sp)
 24a:	6902                	ld	s2,0(sp)
 24c:	6105                	addi	sp,sp,32
 24e:	8082                	ret
    return -1;
 250:	597d                	li	s2,-1
 252:	bfc5                	j	242 <stat+0x34>

0000000000000254 <atoi>:

int
atoi(const char *s)
{
 254:	1141                	addi	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25a:	00054683          	lbu	a3,0(a0)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	4625                	li	a2,9
 268:	02f66863          	bltu	a2,a5,298 <atoi+0x44>
 26c:	872a                	mv	a4,a0
  n = 0;
 26e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 270:	0705                	addi	a4,a4,1
 272:	0025179b          	slliw	a5,a0,0x2
 276:	9fa9                	addw	a5,a5,a0
 278:	0017979b          	slliw	a5,a5,0x1
 27c:	9fb5                	addw	a5,a5,a3
 27e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 282:	00074683          	lbu	a3,0(a4)
 286:	fd06879b          	addiw	a5,a3,-48
 28a:	0ff7f793          	zext.b	a5,a5
 28e:	fef671e3          	bgeu	a2,a5,270 <atoi+0x1c>
  return n;
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  n = 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <atoi+0x3e>

000000000000029c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e422                	sd	s0,8(sp)
 2a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a2:	02b57463          	bgeu	a0,a1,2ca <memmove+0x2e>
    while(n-- > 0)
 2a6:	00c05f63          	blez	a2,2c4 <memmove+0x28>
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b4:	0585                	addi	a1,a1,1
 2b6:	0705                	addi	a4,a4,1
 2b8:	fff5c683          	lbu	a3,-1(a1)
 2bc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
    dst += n;
 2ca:	00c50733          	add	a4,a0,a2
    src += n;
 2ce:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d0:	fec05ae3          	blez	a2,2c4 <memmove+0x28>
 2d4:	fff6079b          	addiw	a5,a2,-1
 2d8:	1782                	slli	a5,a5,0x20
 2da:	9381                	srli	a5,a5,0x20
 2dc:	fff7c793          	not	a5,a5
 2e0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e2:	15fd                	addi	a1,a1,-1
 2e4:	177d                	addi	a4,a4,-1
 2e6:	0005c683          	lbu	a3,0(a1)
 2ea:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ee:	fee79ae3          	bne	a5,a4,2e2 <memmove+0x46>
 2f2:	bfc9                	j	2c4 <memmove+0x28>

00000000000002f4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fa:	ca05                	beqz	a2,32a <memcmp+0x36>
 2fc:	fff6069b          	addiw	a3,a2,-1
 300:	1682                	slli	a3,a3,0x20
 302:	9281                	srli	a3,a3,0x20
 304:	0685                	addi	a3,a3,1
 306:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 308:	00054783          	lbu	a5,0(a0)
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00e79863          	bne	a5,a4,320 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 314:	0505                	addi	a0,a0,1
    p2++;
 316:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 318:	fed518e3          	bne	a0,a3,308 <memcmp+0x14>
  }
  return 0;
 31c:	4501                	li	a0,0
 31e:	a019                	j	324 <memcmp+0x30>
      return *p1 - *p2;
 320:	40e7853b          	subw	a0,a5,a4
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  return 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <memcmp+0x30>

000000000000032e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 336:	00000097          	auipc	ra,0x0
 33a:	f66080e7          	jalr	-154(ra) # 29c <memmove>
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret

0000000000000346 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 346:	4885                	li	a7,1
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exit>:
.global exit
exit:
 li a7, SYS_exit
 34e:	4889                	li	a7,2
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <wait>:
.global wait
wait:
 li a7, SYS_wait
 356:	488d                	li	a7,3
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 35e:	4891                	li	a7,4
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <read>:
.global read
read:
 li a7, SYS_read
 366:	4895                	li	a7,5
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <write>:
.global write
write:
 li a7, SYS_write
 36e:	48c1                	li	a7,16
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <close>:
.global close
close:
 li a7, SYS_close
 376:	48d5                	li	a7,21
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <kill>:
.global kill
kill:
 li a7, SYS_kill
 37e:	4899                	li	a7,6
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <exec>:
.global exec
exec:
 li a7, SYS_exec
 386:	489d                	li	a7,7
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <open>:
.global open
open:
 li a7, SYS_open
 38e:	48bd                	li	a7,15
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 396:	48c5                	li	a7,17
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 39e:	48c9                	li	a7,18
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a6:	48a1                	li	a7,8
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <link>:
.global link
link:
 li a7, SYS_link
 3ae:	48cd                	li	a7,19
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b6:	48d1                	li	a7,20
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3be:	48a5                	li	a7,9
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c6:	48a9                	li	a7,10
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ce:	48ad                	li	a7,11
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d6:	48b1                	li	a7,12
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3de:	48b5                	li	a7,13
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e6:	48b9                	li	a7,14
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ee:	1101                	addi	sp,sp,-32
 3f0:	ec06                	sd	ra,24(sp)
 3f2:	e822                	sd	s0,16(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3fa:	4605                	li	a2,1
 3fc:	fef40593          	addi	a1,s0,-17
 400:	00000097          	auipc	ra,0x0
 404:	f6e080e7          	jalr	-146(ra) # 36e <write>
}
 408:	60e2                	ld	ra,24(sp)
 40a:	6442                	ld	s0,16(sp)
 40c:	6105                	addi	sp,sp,32
 40e:	8082                	ret

0000000000000410 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 410:	7139                	addi	sp,sp,-64
 412:	fc06                	sd	ra,56(sp)
 414:	f822                	sd	s0,48(sp)
 416:	f426                	sd	s1,40(sp)
 418:	f04a                	sd	s2,32(sp)
 41a:	ec4e                	sd	s3,24(sp)
 41c:	0080                	addi	s0,sp,64
 41e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c299                	beqz	a3,426 <printint+0x16>
 422:	0805c963          	bltz	a1,4b4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 426:	2581                	sext.w	a1,a1
  neg = 0;
 428:	4881                	li	a7,0
 42a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 42e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 430:	2601                	sext.w	a2,a2
 432:	00000517          	auipc	a0,0x0
 436:	4ce50513          	addi	a0,a0,1230 # 900 <digits>
 43a:	883a                	mv	a6,a4
 43c:	2705                	addiw	a4,a4,1
 43e:	02c5f7bb          	remuw	a5,a1,a2
 442:	1782                	slli	a5,a5,0x20
 444:	9381                	srli	a5,a5,0x20
 446:	97aa                	add	a5,a5,a0
 448:	0007c783          	lbu	a5,0(a5)
 44c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 450:	0005879b          	sext.w	a5,a1
 454:	02c5d5bb          	divuw	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f0e3          	bgeu	a5,a2,43a <printint+0x2a>
  if(neg)
 45e:	00088c63          	beqz	a7,476 <printint+0x66>
    buf[i++] = '-';
 462:	fd070793          	addi	a5,a4,-48
 466:	00878733          	add	a4,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef70823          	sb	a5,-16(a4)
 472:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 476:	02e05863          	blez	a4,4a6 <printint+0x96>
 47a:	fc040793          	addi	a5,s0,-64
 47e:	00e78933          	add	s2,a5,a4
 482:	fff78993          	addi	s3,a5,-1
 486:	99ba                	add	s3,s3,a4
 488:	377d                	addiw	a4,a4,-1
 48a:	1702                	slli	a4,a4,0x20
 48c:	9301                	srli	a4,a4,0x20
 48e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 492:	fff94583          	lbu	a1,-1(s2)
 496:	8526                	mv	a0,s1
 498:	00000097          	auipc	ra,0x0
 49c:	f56080e7          	jalr	-170(ra) # 3ee <putc>
  while(--i >= 0)
 4a0:	197d                	addi	s2,s2,-1
 4a2:	ff3918e3          	bne	s2,s3,492 <printint+0x82>
}
 4a6:	70e2                	ld	ra,56(sp)
 4a8:	7442                	ld	s0,48(sp)
 4aa:	74a2                	ld	s1,40(sp)
 4ac:	7902                	ld	s2,32(sp)
 4ae:	69e2                	ld	s3,24(sp)
 4b0:	6121                	addi	sp,sp,64
 4b2:	8082                	ret
    x = -xx;
 4b4:	40b005bb          	negw	a1,a1
    neg = 1;
 4b8:	4885                	li	a7,1
    x = -xx;
 4ba:	bf85                	j	42a <printint+0x1a>

00000000000004bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4bc:	7119                	addi	sp,sp,-128
 4be:	fc86                	sd	ra,120(sp)
 4c0:	f8a2                	sd	s0,112(sp)
 4c2:	f4a6                	sd	s1,104(sp)
 4c4:	f0ca                	sd	s2,96(sp)
 4c6:	ecce                	sd	s3,88(sp)
 4c8:	e8d2                	sd	s4,80(sp)
 4ca:	e4d6                	sd	s5,72(sp)
 4cc:	e0da                	sd	s6,64(sp)
 4ce:	fc5e                	sd	s7,56(sp)
 4d0:	f862                	sd	s8,48(sp)
 4d2:	f466                	sd	s9,40(sp)
 4d4:	f06a                	sd	s10,32(sp)
 4d6:	ec6e                	sd	s11,24(sp)
 4d8:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4da:	0005c903          	lbu	s2,0(a1)
 4de:	18090f63          	beqz	s2,67c <vprintf+0x1c0>
 4e2:	8aaa                	mv	s5,a0
 4e4:	8b32                	mv	s6,a2
 4e6:	00158493          	addi	s1,a1,1
  state = 0;
 4ea:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ec:	02500a13          	li	s4,37
 4f0:	4c55                	li	s8,21
 4f2:	00000c97          	auipc	s9,0x0
 4f6:	3b6c8c93          	addi	s9,s9,950 # 8a8 <malloc+0x128>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4fa:	02800d93          	li	s11,40
  putc(fd, 'x');
 4fe:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 500:	00000b97          	auipc	s7,0x0
 504:	400b8b93          	addi	s7,s7,1024 # 900 <digits>
 508:	a839                	j	526 <vprintf+0x6a>
        putc(fd, c);
 50a:	85ca                	mv	a1,s2
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	ee0080e7          	jalr	-288(ra) # 3ee <putc>
 516:	a019                	j	51c <vprintf+0x60>
    } else if(state == '%'){
 518:	01498d63          	beq	s3,s4,532 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 51c:	0485                	addi	s1,s1,1
 51e:	fff4c903          	lbu	s2,-1(s1)
 522:	14090d63          	beqz	s2,67c <vprintf+0x1c0>
    if(state == 0){
 526:	fe0999e3          	bnez	s3,518 <vprintf+0x5c>
      if(c == '%'){
 52a:	ff4910e3          	bne	s2,s4,50a <vprintf+0x4e>
        state = '%';
 52e:	89d2                	mv	s3,s4
 530:	b7f5                	j	51c <vprintf+0x60>
      if(c == 'd'){
 532:	11490c63          	beq	s2,s4,64a <vprintf+0x18e>
 536:	f9d9079b          	addiw	a5,s2,-99
 53a:	0ff7f793          	zext.b	a5,a5
 53e:	10fc6e63          	bltu	s8,a5,65a <vprintf+0x19e>
 542:	f9d9079b          	addiw	a5,s2,-99
 546:	0ff7f713          	zext.b	a4,a5
 54a:	10ec6863          	bltu	s8,a4,65a <vprintf+0x19e>
 54e:	00271793          	slli	a5,a4,0x2
 552:	97e6                	add	a5,a5,s9
 554:	439c                	lw	a5,0(a5)
 556:	97e6                	add	a5,a5,s9
 558:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 55a:	008b0913          	addi	s2,s6,8
 55e:	4685                	li	a3,1
 560:	4629                	li	a2,10
 562:	000b2583          	lw	a1,0(s6)
 566:	8556                	mv	a0,s5
 568:	00000097          	auipc	ra,0x0
 56c:	ea8080e7          	jalr	-344(ra) # 410 <printint>
 570:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 572:	4981                	li	s3,0
 574:	b765                	j	51c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 576:	008b0913          	addi	s2,s6,8
 57a:	4681                	li	a3,0
 57c:	4629                	li	a2,10
 57e:	000b2583          	lw	a1,0(s6)
 582:	8556                	mv	a0,s5
 584:	00000097          	auipc	ra,0x0
 588:	e8c080e7          	jalr	-372(ra) # 410 <printint>
 58c:	8b4a                	mv	s6,s2
      state = 0;
 58e:	4981                	li	s3,0
 590:	b771                	j	51c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 592:	008b0913          	addi	s2,s6,8
 596:	4681                	li	a3,0
 598:	866a                	mv	a2,s10
 59a:	000b2583          	lw	a1,0(s6)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	e70080e7          	jalr	-400(ra) # 410 <printint>
 5a8:	8b4a                	mv	s6,s2
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf85                	j	51c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5ae:	008b0793          	addi	a5,s6,8
 5b2:	f8f43423          	sd	a5,-120(s0)
 5b6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ba:	03000593          	li	a1,48
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	e2e080e7          	jalr	-466(ra) # 3ee <putc>
  putc(fd, 'x');
 5c8:	07800593          	li	a1,120
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	e20080e7          	jalr	-480(ra) # 3ee <putc>
 5d6:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d8:	03c9d793          	srli	a5,s3,0x3c
 5dc:	97de                	add	a5,a5,s7
 5de:	0007c583          	lbu	a1,0(a5)
 5e2:	8556                	mv	a0,s5
 5e4:	00000097          	auipc	ra,0x0
 5e8:	e0a080e7          	jalr	-502(ra) # 3ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ec:	0992                	slli	s3,s3,0x4
 5ee:	397d                	addiw	s2,s2,-1
 5f0:	fe0914e3          	bnez	s2,5d8 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5f4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b70d                	j	51c <vprintf+0x60>
        s = va_arg(ap, char*);
 5fc:	008b0913          	addi	s2,s6,8
 600:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 604:	02098163          	beqz	s3,626 <vprintf+0x16a>
        while(*s != 0){
 608:	0009c583          	lbu	a1,0(s3)
 60c:	c5ad                	beqz	a1,676 <vprintf+0x1ba>
          putc(fd, *s);
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	dde080e7          	jalr	-546(ra) # 3ee <putc>
          s++;
 618:	0985                	addi	s3,s3,1
        while(*s != 0){
 61a:	0009c583          	lbu	a1,0(s3)
 61e:	f9e5                	bnez	a1,60e <vprintf+0x152>
        s = va_arg(ap, char*);
 620:	8b4a                	mv	s6,s2
      state = 0;
 622:	4981                	li	s3,0
 624:	bde5                	j	51c <vprintf+0x60>
          s = "(null)";
 626:	00000997          	auipc	s3,0x0
 62a:	27a98993          	addi	s3,s3,634 # 8a0 <malloc+0x120>
        while(*s != 0){
 62e:	85ee                	mv	a1,s11
 630:	bff9                	j	60e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 632:	008b0913          	addi	s2,s6,8
 636:	000b4583          	lbu	a1,0(s6)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	db2080e7          	jalr	-590(ra) # 3ee <putc>
 644:	8b4a                	mv	s6,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	bdd1                	j	51c <vprintf+0x60>
        putc(fd, c);
 64a:	85d2                	mv	a1,s4
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	da0080e7          	jalr	-608(ra) # 3ee <putc>
      state = 0;
 656:	4981                	li	s3,0
 658:	b5d1                	j	51c <vprintf+0x60>
        putc(fd, '%');
 65a:	85d2                	mv	a1,s4
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	d90080e7          	jalr	-624(ra) # 3ee <putc>
        putc(fd, c);
 666:	85ca                	mv	a1,s2
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	d84080e7          	jalr	-636(ra) # 3ee <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	b565                	j	51c <vprintf+0x60>
        s = va_arg(ap, char*);
 676:	8b4a                	mv	s6,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b54d                	j	51c <vprintf+0x60>
    }
  }
}
 67c:	70e6                	ld	ra,120(sp)
 67e:	7446                	ld	s0,112(sp)
 680:	74a6                	ld	s1,104(sp)
 682:	7906                	ld	s2,96(sp)
 684:	69e6                	ld	s3,88(sp)
 686:	6a46                	ld	s4,80(sp)
 688:	6aa6                	ld	s5,72(sp)
 68a:	6b06                	ld	s6,64(sp)
 68c:	7be2                	ld	s7,56(sp)
 68e:	7c42                	ld	s8,48(sp)
 690:	7ca2                	ld	s9,40(sp)
 692:	7d02                	ld	s10,32(sp)
 694:	6de2                	ld	s11,24(sp)
 696:	6109                	addi	sp,sp,128
 698:	8082                	ret

000000000000069a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 69a:	715d                	addi	sp,sp,-80
 69c:	ec06                	sd	ra,24(sp)
 69e:	e822                	sd	s0,16(sp)
 6a0:	1000                	addi	s0,sp,32
 6a2:	e010                	sd	a2,0(s0)
 6a4:	e414                	sd	a3,8(s0)
 6a6:	e818                	sd	a4,16(s0)
 6a8:	ec1c                	sd	a5,24(s0)
 6aa:	03043023          	sd	a6,32(s0)
 6ae:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6b6:	8622                	mv	a2,s0
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e04080e7          	jalr	-508(ra) # 4bc <vprintf>
}
 6c0:	60e2                	ld	ra,24(sp)
 6c2:	6442                	ld	s0,16(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret

00000000000006c8 <printf>:

void
printf(const char *fmt, ...)
{
 6c8:	711d                	addi	sp,sp,-96
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e40c                	sd	a1,8(s0)
 6d2:	e810                	sd	a2,16(s0)
 6d4:	ec14                	sd	a3,24(s0)
 6d6:	f018                	sd	a4,32(s0)
 6d8:	f41c                	sd	a5,40(s0)
 6da:	03043823          	sd	a6,48(s0)
 6de:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e2:	00840613          	addi	a2,s0,8
 6e6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ea:	85aa                	mv	a1,a0
 6ec:	4505                	li	a0,1
 6ee:	00000097          	auipc	ra,0x0
 6f2:	dce080e7          	jalr	-562(ra) # 4bc <vprintf>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6125                	addi	sp,sp,96
 6fc:	8082                	ret

00000000000006fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6fe:	1141                	addi	sp,sp,-16
 700:	e422                	sd	s0,8(sp)
 702:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 704:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 708:	00001797          	auipc	a5,0x1
 70c:	8f87b783          	ld	a5,-1800(a5) # 1000 <freep>
 710:	a02d                	j	73a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 712:	4618                	lw	a4,8(a2)
 714:	9f2d                	addw	a4,a4,a1
 716:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 71a:	6398                	ld	a4,0(a5)
 71c:	6310                	ld	a2,0(a4)
 71e:	a83d                	j	75c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 720:	ff852703          	lw	a4,-8(a0)
 724:	9f31                	addw	a4,a4,a2
 726:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 728:	ff053683          	ld	a3,-16(a0)
 72c:	a091                	j	770 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	6398                	ld	a4,0(a5)
 730:	00e7e463          	bltu	a5,a4,738 <free+0x3a>
 734:	00e6ea63          	bltu	a3,a4,748 <free+0x4a>
{
 738:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	fed7fae3          	bgeu	a5,a3,72e <free+0x30>
 73e:	6398                	ld	a4,0(a5)
 740:	00e6e463          	bltu	a3,a4,748 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	fee7eae3          	bltu	a5,a4,738 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 748:	ff852583          	lw	a1,-8(a0)
 74c:	6390                	ld	a2,0(a5)
 74e:	02059813          	slli	a6,a1,0x20
 752:	01c85713          	srli	a4,a6,0x1c
 756:	9736                	add	a4,a4,a3
 758:	fae60de3          	beq	a2,a4,712 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 75c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 760:	4790                	lw	a2,8(a5)
 762:	02061593          	slli	a1,a2,0x20
 766:	01c5d713          	srli	a4,a1,0x1c
 76a:	973e                	add	a4,a4,a5
 76c:	fae68ae3          	beq	a3,a4,720 <free+0x22>
    p->s.ptr = bp->s.ptr;
 770:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 772:	00001717          	auipc	a4,0x1
 776:	88f73723          	sd	a5,-1906(a4) # 1000 <freep>
}
 77a:	6422                	ld	s0,8(sp)
 77c:	0141                	addi	sp,sp,16
 77e:	8082                	ret

0000000000000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	7139                	addi	sp,sp,-64
 782:	fc06                	sd	ra,56(sp)
 784:	f822                	sd	s0,48(sp)
 786:	f426                	sd	s1,40(sp)
 788:	f04a                	sd	s2,32(sp)
 78a:	ec4e                	sd	s3,24(sp)
 78c:	e852                	sd	s4,16(sp)
 78e:	e456                	sd	s5,8(sp)
 790:	e05a                	sd	s6,0(sp)
 792:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 794:	02051493          	slli	s1,a0,0x20
 798:	9081                	srli	s1,s1,0x20
 79a:	04bd                	addi	s1,s1,15
 79c:	8091                	srli	s1,s1,0x4
 79e:	0014899b          	addiw	s3,s1,1
 7a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7a4:	00001517          	auipc	a0,0x1
 7a8:	85c53503          	ld	a0,-1956(a0) # 1000 <freep>
 7ac:	c515                	beqz	a0,7d8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7b0:	4798                	lw	a4,8(a5)
 7b2:	02977f63          	bgeu	a4,s1,7f0 <malloc+0x70>
 7b6:	8a4e                	mv	s4,s3
 7b8:	0009871b          	sext.w	a4,s3
 7bc:	6685                	lui	a3,0x1
 7be:	00d77363          	bgeu	a4,a3,7c4 <malloc+0x44>
 7c2:	6a05                	lui	s4,0x1
 7c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cc:	00001917          	auipc	s2,0x1
 7d0:	83490913          	addi	s2,s2,-1996 # 1000 <freep>
  if(p == (char*)-1)
 7d4:	5afd                	li	s5,-1
 7d6:	a895                	j	84a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 7d8:	00001797          	auipc	a5,0x1
 7dc:	83878793          	addi	a5,a5,-1992 # 1010 <base>
 7e0:	00001717          	auipc	a4,0x1
 7e4:	82f73023          	sd	a5,-2016(a4) # 1000 <freep>
 7e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7ee:	b7e1                	j	7b6 <malloc+0x36>
      if(p->s.size == nunits)
 7f0:	02e48c63          	beq	s1,a4,828 <malloc+0xa8>
        p->s.size -= nunits;
 7f4:	4137073b          	subw	a4,a4,s3
 7f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7fa:	02071693          	slli	a3,a4,0x20
 7fe:	01c6d713          	srli	a4,a3,0x1c
 802:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 804:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 808:	00000717          	auipc	a4,0x0
 80c:	7ea73c23          	sd	a0,2040(a4) # 1000 <freep>
      return (void*)(p + 1);
 810:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 814:	70e2                	ld	ra,56(sp)
 816:	7442                	ld	s0,48(sp)
 818:	74a2                	ld	s1,40(sp)
 81a:	7902                	ld	s2,32(sp)
 81c:	69e2                	ld	s3,24(sp)
 81e:	6a42                	ld	s4,16(sp)
 820:	6aa2                	ld	s5,8(sp)
 822:	6b02                	ld	s6,0(sp)
 824:	6121                	addi	sp,sp,64
 826:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 828:	6398                	ld	a4,0(a5)
 82a:	e118                	sd	a4,0(a0)
 82c:	bff1                	j	808 <malloc+0x88>
  hp->s.size = nu;
 82e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 832:	0541                	addi	a0,a0,16
 834:	00000097          	auipc	ra,0x0
 838:	eca080e7          	jalr	-310(ra) # 6fe <free>
  return freep;
 83c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 840:	d971                	beqz	a0,814 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 844:	4798                	lw	a4,8(a5)
 846:	fa9775e3          	bgeu	a4,s1,7f0 <malloc+0x70>
    if(p == freep)
 84a:	00093703          	ld	a4,0(s2)
 84e:	853e                	mv	a0,a5
 850:	fef719e3          	bne	a4,a5,842 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 854:	8552                	mv	a0,s4
 856:	00000097          	auipc	ra,0x0
 85a:	b80080e7          	jalr	-1152(ra) # 3d6 <sbrk>
  if(p == (char*)-1)
 85e:	fd5518e3          	bne	a0,s5,82e <malloc+0xae>
        return 0;
 862:	4501                	li	a0,0
 864:	bf45                	j	814 <malloc+0x94>
