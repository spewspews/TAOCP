/*
 * Same effect as Program A
 */

#include "/sys/src/libc/9syscall/sys.h"

#define char R8
#define ioptr R9
#define hold R10
#define next R11
#define chari R12

GLOBL t(SB), $0x80   /* a table for all valid names */
GLOBL buf(SB), $1000

TEXT main(SB), $40
	MOVQ $0, 8(SP)
	MOVQ $buf(SB), 16(SP)
	MOVQ $1000, 24(SP)
	MOVQ $-1, 32(SP)
	MOVQ $PREAD, RARG
	SYSCALL
	CMPL AX, $0
	JLE Fail
	LEAQ buf-1(SB)(AX*1), ioptr /* decrement for newline at end */
	MOVQ $0x21, char  /* B1. Initialize. Set char to first valid  name */
0(H):
	MOVB char, t(SB)(char*1)
	INCQ char
	CMPQ char, $0x80  /* Loop until char = 0x7f */
	JL 0(B)
	JMP 9(F)
2(H):
	MOVBQZX (ioptr), char /* B2. Next element */
	CMPB char, $')'
	JNE 1(F)
	MOVB $0, next
	JMP 9(F)
1(H):
	CMPB char, $'('
	CMOVQEQ hold, char /* B4. Change t[i]. */
	CMPB next, $0
	CMOVQEQ char, hold /* B3. Change t[hold] */
	MOVB t(SB)(char*1), AX
	MOVB next, t(SB)(char*1)
	MOVB AX, next
9(H):
	DECQ ioptr
	CMPQ ioptr, $buf(SB)
	JGE 2(B)
Output:
	MOVQ $buf(SB), ioptr
	MOVQ $0x21, chari
0(H):
	MOVB t(SB)(chari*1), next
	CMPB next, chari
	JE 2(F) /* Skip singleton. */
	CMPB next, $0
	JL 2(F) /* Skip tagged element. */
	MOVB $'(', (ioptr) /* Output ‘(’ */
	INCQ ioptr
	MOVQ chari, char /* Loop invariant: next = t[char] */
1(H):
	MOVB char, (ioptr) /* Output char. */
	INCQ ioptr
	MOVB next, AX
	ORB $0x80, AX
	MOVB AX, t(SB)(char*1) /* Tag t[char] */
	MOVB next, char  /* advance char */
	MOVB t(SB)(char*1), next /* Get successor element */
	CMPB next, $0  /* and continue, if */
	JGE 1(B)   /*  untagged         */
	MOVB $')', (ioptr)  /* Otherwise, output ‘)’ */
	INCQ ioptr
2(H):
	INCQ chari   /* Advance in Table t */
	CMPQ chari, $0x80
	JL 0(B)
Done:
	CMPQ ioptr, $buf(SB)  /* Is answer the identity permutation? */
	JG 0(F)   /* If so, change to '()' */
	MOVB $'(', buf(SB)
	MOVB $')', buf+1(SB)
	MOVQ $buf+2(SB), ioptr
0(H):
	MOVB $'\n', (ioptr)
	INCQ ioptr
	MOVQ $1, 8(SP)
	MOVQ $buf(SB), 16(SP)
	SUBQ $buf(SB), ioptr
	MOVL ioptr, 24(SP)
	MOVQ $-1, 32(SP)
	MOVQ $PWRITE, RARG  /* print the answer */
	SYSCALL
Fail:
	MOVQ $0, 8(SP)
	MOVQ $EXITS, RARG
	SYSCALL
	RET
	END
