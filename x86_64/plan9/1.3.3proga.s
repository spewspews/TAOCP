/*
 * Multiply permutations in cycle form.
 * Unlike the Knuth program, this one
 * does not test for invalid characters.
 */

#include "/sys/src/libc/9syscall/sys.h"

GLOBL	inbuf(SB), $1000
GLOBL	outbuf(SB), $1000

#define len	R8
#define inptr	R9
#define outptr	R10
#define current	R11
#define start	R12
#define x	R13

TEXT	main(SB), $40
	MOVQ	$0, 8(SP)
	MOVQ	$inbuf(SB), 16(SP)
	MOVQ	$1000, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PREAD, RARG
	SYSCALL
	CMPL	AX, $0
	JLE	Fail
	LEAQ	inbuf-1(SB)(AX*1), len	/* decrement for newline at end */
	MOVQ	$inbuf(SB), inptr	/* A1 first pass */
2(H):	MOVB	(inptr), current
	CMPB	current, $'('		/* Is it '('? */
	JNE	1(F)
	ORB	$0x80, current		/* If so, tag it. */
	MOVB	current, (inptr)
	INCQ	inptr
	MOVB	(inptr), start		/* Put the next input symbol in start */
	INCQ	inptr
	MOVB	(inptr), current	/* and the next in current. */
1(H):	CMPB	current, $')'		/* Is it ')'? */
	JNE	0(F)
	ORB	$0x80, start
	MOVB	start, (inptr)		/* replace ')' by tagged start */
0(H):	INCQ	inptr
	CMPQ	inptr, len
	JL	2(B)			/* have all elements been processed? */
	MOVQ	$outbuf(SB), outptr
Open:	MOVQ	$inbuf(SB), inptr	/* A2. Open. */
1(H):	MOVB	(inptr), x		/* Look for untagged element. */
	CMPB	x, $0
	JG	Go
	INCQ	inptr
	CMPQ	inptr, len
	JL	1(B)
Done:	CMPQ	outptr, $outbuf(SB)	/* Is answer the identity permutation? */
	JG	0(F)			/* If so, change to '()' */
	MOVB	$'(', outbuf(SB)
	MOVB	$')', outbuf+1(SB)
	MOVQ	$outbuf+2(SB), outptr
0(H):	MOVB	$'\n', (outptr)
	MOVQ	$1, 8(SP)
	MOVQ	$outbuf(SB), 16(SP)
	INCQ	outptr
	SUBQ	$outbuf(SB), outptr	/* subtract to get length */
	MOVL	outptr, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG		/* print the answer */
	SYSCALL
Fail:	MOVQ	$0, 8(SP)
	MOVQ	$EXITS, RARG
	SYSCALL
Go:	MOVB	$'(', (outptr)		/* output '(' */
	INCQ	outptr
	MOVB	x, (outptr)		/* output x */
	INCQ	outptr
	MOVB	x, start
Succ:	ORB	$0x80, x
	MOVB	x, (inptr)		/* tag x */
	INCQ	inptr			/* A3. Set current */
	MOVB	(inptr), current
	ANDB	$0x7f, current
	JMP	1(F)
5(H):	MOVB	current, (outptr)	/* output current */
	INCQ	outptr
	MOVL	$inbuf(SB), inptr	/* Scan formula again */
4(H):	MOVB	(inptr), x		/* A4. Scan formula */
	ANDB	$0x7f, x		/* Untag. */
	CMPB	x, current
	JE	Succ
1(H):	INCQ	inptr			/* Move to right. */
	CMPQ	inptr, len
	JL	4(B)			/* End of formula? */
	CMPB	start, current
	JNE	5(B)
	MOVB	$')', (outptr)		/* A6. Close */
	SUBQ	$2, outptr		/* suppress singleton cycles */
	MOVB	(outptr), BX
	CMPB	BX, $'('
	JE	Open
	ADDQ	$3, outptr
	JMP	Open
	RET
	END
