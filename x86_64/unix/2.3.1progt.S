	.equ	left,	0
	.equ	right,	8
	.equ	asize,	1000

	.bss
a:	.space	asize

/*
 * On entry:
 * %rdi is Node *p
 * %rsi is pointer to visit function
 *
 * After entry:
 * %rbx is Node *p
 * %rbp is pointer to visit function
 * %r12 is stack index
 */

	.text
	.global inorder
inorder:
T1:	cmpq	$0,	%rdi
	jne	T2A
	ret
T2A:	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	movq	%rdi,	%rbx
	movq	%rsi,	%rbp
	xorq	%r12, %r12
T3:	cmpq	$asize,	%r12
	jge	OVERFLOW
	movq	%rbx,	a(,%r12,8)
	incq	%r12
	movq	left(%rbx),	%rbx
T2B:	cmpq	$0,	%rbx
	jne	T3
T4:	decq	%r12
	movq	a(,%r12,8),	%rbx
T5:	movq	%rbx,	%rdi
	callq	*%rbp
	movq	right(%rbx),	%rbx
T2C:	cmpq	$0,	%rbx
	jne	T3
	cmpq	$0,	%r12
	jne	T4
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret

OVERFLOW:
	movq	$-1,	%rdi
	callq	exit
