	.equ	left,	0
	.equ	right,	8
	.equ	asize,	8000

	.bss
a:
	.space	asize

/*
 * On entry:
 * %rdi is Node *p
 * %rsi is pointer to visit function
 *
 * After entry:
 * %rbx is Node *p
 * %rbp is pointer to visit function
 * %r12 is stack pointer
 * %r13 is end of stack pointer
 * %r14 is beginning of stack pointer
 */

	.text
	.global inorder
inorder:
T1:	pushq	%rbx
	pushq	%rbp
	pushq	%r12
	pushq	%r13
	pushq	%r14
	movq	%rdi,	%rbx
	movq	%rsi,	%rbp
	movq	$a,	%r12
	movq	%r12,	%r14
	leaq	asize(%r12),	%r13
T2:	cmpq	$0,	%rbx
	je	T4
T3:	cmpq	%r12,	%r13
	je	OVERFLOW
	movq	%rbx,	(%r12)
	addq	$8,	%r12
	movq	left(%rbx),	%rbx
	jmp	T2
T4:	cmpq	%r12,	%r14
	je	RET
	subq	$8,	%r12
	movq	(%r12),	%rbx
T5:	movq	%rbx,	%rdi
	callq	*%rbp
	movq	right(%rbx),	%rbx
	jmp	T2

RET:	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbp
	popq	%rbx
	ret

OVERFLOW:
	movq	$1,	%rdi
	callq	exit
