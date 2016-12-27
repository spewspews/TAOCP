/*
 * Same effect as Program A
 */

#include <sys/syscall.h>
#include <machine/asm.h>

#define size	%r8
#define k	%r9
#define kb	%r9b
#define j	%r10
#define x	%r11
#define xb	%r11b
#define z	%r12
#define zb	%r12b

	.comm	t, 0x80			/* a table for all valid names */
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
	leaq	-1(%rax), size		/* decrement for newline at end */
	movq	$0x21, k		/* B1. Initialize. Set k to first valid  name */
0:	movb	kb, t(k)		/* t[k]←k */
	incq	k
	cmpq	$0x80, k		/* Loop until k = 0x7f */
	jl	0b
	movq	size, k
	jmp	9f
2:	movq	$0, x
	movq	$0, %rax		/* initialize upper bytes 9 */
	movb	inbuf(k), xb		/* B2. Next element */
	cmpb	$')', xb
	je	0f
	cmpb	$'(', xb
	cmoveq	j, x			/* B4. Change t[i]. */
	cmpb	$0, zb
	cmoveq	x, j			/* B3. Change t[j] */
	movb	t(x), %al
	movb	zb, t(x)
0:	movq	%rax, z
9:	decq	k
	cmpq	$0, k
	jge	2b
Output:	movq	$0, j
	movq	$0, x
	movq	$0x21, k
0:	movb	t(k), xb
	cmpb	kb, xb
	je	2f			/* Skip singleton. */
	cmpb	$0, xb
	jl	2f			/* Skip tagged element. */
	movb	$'(', outbuf(j)		/* Output ‘(’ */
	incq	j
	movq	k, z			/* Loop invariant: x = t[z] */
1:	movb	zb, outbuf(j)		/* Output z. */
	incq	j
	movb	xb, %al
	orb	$0x80, %al
	movb	%al, t(z)		/* Tag t[z] */
	movb	xb, zb			/* advance z */
	movb	t(z), xb		/* Get successor element */
	cmpb	$0, xb			/*	and continue, if */
	jge	1b			/* 	untagged         */
	movb	$')', outbuf(j)		/* Otherwise, output ‘)’ */
	incq	j
2:	incq	k			/* Advance in Table t */
	cmpq	$0x80, k
	jl	0b
Done:	cmpq	$0, j			/* Is answer the identity permutation? */
	jg	0f			/* If so, change to '()' */
	movb	$'(', outbuf
	movb	$')', outbuf+1
	movq	$2, j
0:	movb	$'\n', outbuf(j)
	movq	$1, %rdi
	movq	$outbuf, %rsi
	leaq	1(j), %rdx		/* length of answer is j+1 including new line */
	movq	$SYS_write, %rax	/* print the answer */
	syscall
Fail:	movq	$0, %rdi
	movq	$SYS_exit, %rax
	syscall
	ret
