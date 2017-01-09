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
 * %r12 is beginning of stack
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
	movq	%rsp,	%r12
T3:	pushq	%rbx
	movq	left(%rbx),	%rbx
T2B:	cmpq	$0,	%rbx
	jne	T3
T4:	popq	%rbx
T5:	movq	%rbx,	%rdi
	callq	*%rbp
	movq	right(%rbx),	%rbx
T2C:	cmpq	$0,	%rbx
	jne	T3
	cmpq	%rsp,	%r12
	jne	T4
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret
