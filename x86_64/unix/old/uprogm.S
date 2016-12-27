#define j	%rax
#define k	%rbx
#define m	%rcx
#define	x0	%r8
#define xk	%rdx

	.globl maximum
	.text
maximum:
	movq	%rdi, j
	movq	%rdi, k
	leaq	x(%rip), x0
	movq	(x0,k,8), m
	jmp	Decrk
Loop:
	movq	(x0,k,8), xk
	cmpq	m, xk
	jle	Decrk
ChangeM:
	movq	xk, m
	movq	k, j
Decrk:
	decq	k
	cmpq	$0, k
	jg	Loop
	ret
