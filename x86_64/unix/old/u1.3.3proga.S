/*
 * Multiply permutations in cycle form.
 * Unlike the Knuth program, this one
 * does not test for invalid characters.
 */

#include <sys/syscall.h>
#include <machine/asm.h>

#define size	%r12
#define k	%r13
#define current	%r8b
#define start	%r9b
#define j	%r10
#define x	%r11b

	.data
	.comm	inbuf, 1000
	.comm	outbuf, 1000

ENTRY(main)
	movq	$0, %rdi
	movq	$inbuf, %rsi
	movq	$1000, %rdx
	movq	$SYS_read, %rax
	syscall
	cmpq	$0, %rax
	jle	Fail
	leaq	-1(%rax), size			/* decrement for newline at end */
	movq	$0, k				/* A1 first pass */
2:	movb	inbuf(k), current
	cmpb	$'(', current			/* Is it '('? */
	jne	1f
	orb	$0x80, current			/* If so, tag it. */
	movb	current, inbuf(k)
	incq	k
	movb	inbuf(k), start		/* Put the next input symbol in start */
	incq	k
	movb	inbuf(k), current		/* and the next in current. */
1:	cmpb	$')', current			/* Is it ')'? */
	jne	0f
	orb	$0x80, start
	movb	start, inbuf(k)		/* replace ')' by tagged start */
0:	incq	k
	cmpq	size, k
	jl	2b				/* have all eleements been processed? */
	movq	$0, j
Open:	movq	$0, k				/* A2. Open. */
1:	movb	inbuf(k), x			/* Look for untagged element. */
	cmpb	$0, x
	jg	Go
	incq	k
	cmpq	size, k
	jl	1b
Done:	cmpq	$0, j				/* Is answer the identity permutation? */
	jg	0f				/* If so, change to '()' */
	movb	$'(', outbuf
	movb	$')', outbuf+1
	movq	$2, j
0:	movb	$'\n', outbuf(j)
	movq	$1, %rdi
	movq	$outbuf, %rsi
	leaq	1(j), %rdx			/* length of answer is j+1 including new line */
	movq	$SYS_write, %rax		/* print the answer */
	syscall
Fail:	movq	$0, %rdi
	movq	$SYS_exit, %rax
	syscall
Go:	movb	$'(', outbuf(j)		/* output '(' */
	incq	j
	movb	x, outbuf(j)		/* output x */
	incq	j
	movb	x, start
Succ:	orb	$0x80, x
	movb	x, inbuf(k)		/* tag x */
	incq	k				/* A3. Set current */
	movb	inbuf(k), current
	andb	$0x7f, current
	jmp	1f
5:	movb	current, outbuf(j)	/* output current */
	incq	j
	movq	$0, k				/* Scan formula again */
4:	movb	inbuf(k), x		/* A4. Scan formula */
	andb	$0x7f, x			/* Untag. */
	cmpb	current, x
	je	Succ
1:	incq	k				/* Move to right. */
	cmpq	size, k
	jl	4b				/* End of formula? */
	cmpb	current, start
	jne	5b
	movb	$')', outbuf(j)			/* A6. Close */
	subq	$2, j				/* suppress singleton cycles */
	movb	outbuf(j), %bl
	cmpb	$'(', %bl
	je	Open
	addq	$3, j
	jmp	Open
	ret
