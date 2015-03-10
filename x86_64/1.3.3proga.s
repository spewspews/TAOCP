/*
 * Multiply permutations in cycle form.
 * Unlike the Knuth program, this one
 * does not test for invalid characters.
 */

#include "/sys/src/libc/9syscall/sys.h"

GLOBL	inbuf(SB), $1000
GLOBL	outbuf(SB), $1000

#define size	SI
#define k	DI
#define current	R8
#define start	R9
#define j	R10
#define x	R11

TEXT	main(SB), $40
	MOVQ	$0, 8(SP)
	MOVQ	$inbuf(SB), 16(SP)
	MOVQ	$1000, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PREAD, RARG
	SYSCALL
	CMPL	AX, $0
	JLE	Fail
	LEAL	-1(AX), size			/* decrement for newline at end */
	MOVL	$0, k				/* A1 first pass */
2(H):	MOVB	inbuf(SB)(k*1), current
	CMPB	current, $'('			/* Is it '('? */
	JNE	1(F)
	ORB	$0x80, current			/* If so, tag it. */
	MOVB	current, inbuf(SB)(k*1)
	INCL	k
	MOVB	inbuf(SB)(k*1), start		/* Put the next input symbol in start */
	INCL	k
	MOVB	inbuf(SB)(k*1), current		/* and the next in current. */
1(H):	CMPB	current, $')'			/* Is it ')'? */
	JNE	0(F)
	ORB	$0x80, start
	MOVB	start, inbuf(SB)(k*1)		/* replace ')' by tagged start */
0(H):	INCL	k
	CMPL	k, size
	JL	2(B)				/* have all elements been processed? */
	MOVL	$0, j
Open:	MOVL	$0, k				/* A2. Open. */
1(H):	MOVB	inbuf(SB)(k*1), x		/* Look for untagged element. */
	CMPB	x, $0
	JG	Go
	INCL	k
	CMPL	k, size
	JL	1(B)
Done:	CMPL	j, $0				/* Is answer the identity permutation? */
	JG	0(F)				/* If so, change to '()' */
	MOVB	$'(', outbuf(SB)
	MOVB	$')', outbuf+1(SB)
	MOVL	$2, j
0(H):	MOVB	$'\n', outbuf(SB)(j*1)
	MOVQ	$1, 8(SP)
	MOVQ	$outbuf(SB), 16(SP)
	LEAL	1(j), AX			/* length of answer is j+1 including new line */
	MOVL	AX, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG			/* print the answer */
	SYSCALL
Fail:	MOVQ	$0, 8(SP)
	MOVQ	$EXITS, RARG
	SYSCALL
Go:	MOVB	$'(', outbuf(SB)(j*1)		/* output '(' */
	INCL	j
	MOVB	x, outbuf(SB)(j*1)		/* output x */
	INCL	j
	MOVB	x, start
Succ:	ORB	$0x80, x
	MOVB	x, inbuf(SB)(k*1)		/* tag x */
	INCL	k				/* A3. Set current */
	MOVB	inbuf(SB)(k*1), current
	ANDB	$0x7f, current
	JMP	1(F)
5(H):	MOVB	current, outbuf(SB)(j*1)	/* output current */
	INCL	j
	MOVL	$0, k				/* Scan formula again */
4(H):	MOVB	inbuf(SB)(k*1), x		/* A4. Scan formula */
	ANDB	$0x7f, x			/* Untag. */
	CMPB	x, current
	JE	Succ
1(H):	INCL	k				/* Move to right. */
	CMPL	k, size
	JL	4(B)				/* End of formula? */
	CMPB	start, current
	JNE	5(B)
	MOVB	$')', outbuf(SB)(j*1)		/* A6. Close */
	SUBL	$2, j				/* suppress singleton cycles */
	MOVB	outbuf(SB)(j*1), BX
	CMPB	BX, $'('
	JE	Open
	ADDL	$3, j
	JMP	Open
	RET
	END
