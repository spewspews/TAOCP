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
 */

	.text
	.global inorder
inorder:
S0:	cmp	$0,	%rdi		// 1
	jne	1f			// 1
	ret				// 0
1:	push	%rbx			// 1
	push	%rbp			// 1
	mov	%rdi,	%rbx		// 1
	mov	%rsi,	%rbp		// 1
	mov	left(%rbx),	%rax	// 1
	test	$1,	%rax		// 1
	jz	2f			// 1
1:	cmp	$1,	%rbx		// a
	je	RET			// 1
	xor	$1,	%rbx		// a-1
S3:	mov	%rbx,	%rdi		// n
	call	*%rbp			// n
S1:	mov	right(%rbx),	%rbx	// n
	test	$1,	%rbx		// n
	jnz	1b			// a
S2:	mov	left(%rbx),	%rax	// n-1
	test	$1,	%rax		// n-1
	jnz	S3			// n-a+1
2:	mov	%rax,	%rbx		// a-1
	jmp	S2			// a-1

RET:	pop	%rbp			// 1
	pop	%rbx			// 1
	ret				// 1

// Running time is 7n + 4a + 9
// n number of nodes, a number of nodes with no right child.
// I count a branch only if it is taken.
