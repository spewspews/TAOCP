	.equ	left,	0
	.equ	right,	8

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
T1:	cmp	$0,	%rdi
	jne	T2A
	ret
T2A:	push	%rbx
	push	%rbp
	push	%r12
	mov	%rdi,	%rbx
	mov	%rsi,	%rbp
	mov	%rsp,	%r12
T3:	push	%rbx
	mov	left(%rbx),	%rbx
T2B:	cmp	$0,	%rbx
	jne	T3
T4:	pop	%rbx
T5:	mov	%rbx,	%rdi
	call	*%rbp
	mov	right(%rbx),	%rbx
T2C:	cmp	$0,	%rbx
	jne	T3
	cmp	%rsp,	%r12
	jne	T4
	pop	%r12
	pop	%rbp
	pop	%rbx
	ret
