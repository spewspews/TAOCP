/*
 * Same effect as Program A
 */

#include "/sys/src/libc/9syscall/sys.h"

#define size	SI
#define k	DI
#define j	R8
#define x	R9
#define z	R10

GLOBL	t(SB), $0x80			/* a table for all valid names */
GLOBL	inbuf(SB), $1000
GLOBL	outbuf(SB), $1000

TEXT	main(SB), $40
	MOVQ	$0, 8(SP)
	MOVQ	$inbuf(SB), 16(SP)
	MOVQ	$1000, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PREAD, RARG
	SYSCALL
	CMPL	AX, $0
	JLE	Fail
	LEAL	-1(AX), size		/* decrement for newline at end */
	MOVQ	$0x21, k		/* B1. Initialize. Set k to first valid  name */
0(H):	MOVB	k, t(SB)(k*1)		/* t[k]←k */
	INCQ	k
	CMPQ	k, $0x80		/* Loop until k = 0x7f */
	JL	0(B)
	MOVL	size, k
	JMP	9(F)
2(H):	MOVQ	$0, x			/* initialize upper bits to 0 */
	MOVQ	$0, AX
	MOVB	inbuf(SB)(k*1), x	/* B2. Next element */
	CMPB	x, $')'
	JE	0(F)
	CMPB	x, $'('
	CMOVQEQ	j, x			/* B4. Change t[i]. */
	CMPB	z, $0
	CMOVQEQ	x, j			/* B3. Change t[j] */
	MOVB	t(SB)(x*1), AX
	MOVB	z, t(SB)(x*1)
0(H):	MOVQ	AX, z
9(H):	DECL	k
	CMPL	k, $0
	JGE	2(B)
Output:	MOVL	$0, j
	MOVQ	$0, x
	MOVQ	$0x21, k
0(H):	MOVB	t(SB)(k*1), x
	CMPB	x, k
	JE	2(F)			/* Skip singleton. */
	CMPB	x, $0
	JL	2(F)			/* Skip tagged element. */
	MOVB	$'(', outbuf(SB)(j*1)	/* Output ‘(’ */
	INCL	j
	MOVQ	k, z			/* Loop invariant: x = t[z] */
1(H):	MOVB	z, outbuf(SB)(j*1)	/* Output z. */
	INCL	j
	MOVB	x, AX
	ORB	$0x80, AX
	MOVB	AX, t(SB)(z*1)		/* Tag t[z] */
	MOVB	x, z			/* advance z */
	MOVB	t(SB)(z*1), x		/* Get successor element */
	CMPB	x, $0			/*	and continue, if */
	JGE	1(B)			/* 	untagged         */
	MOVB	$')', outbuf(SB)(j*1)	/* Otherwise, output ‘)’ */
	INCL	j
2(H):	INCQ	k			/* Advance in Table t */
	CMPQ	k, $0x80
	JL	0(B)
Done:	CMPL	j, $0			/* Is answer the identity permutation? */
	JG	0(F)			/* If so, change to '()' */
	MOVB	$'(', outbuf(SB)
	MOVB	$')', outbuf+1(SB)
	MOVL	$2, j
0(H):	MOVB	$'\n', outbuf(SB)(j*1)
	MOVQ	$1, 8(SP)
	MOVQ	$outbuf(SB), 16(SP)
	LEAL	1(j), AX		/* length of answer is j+1 including new line */
	MOVL	AX, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG		/* print the answer */
	SYSCALL
Fail:	MOVQ	$0, 8(SP)
	MOVQ	$EXITS, RARG
	SYSCALL
	RET
	END
