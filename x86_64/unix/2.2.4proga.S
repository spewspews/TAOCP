	.global add

	.equ coef, 0
	.equ abc, 4
	.equ link, 8


/*
 * C Calling sequence:
 * 	add(Poly *q, Poly *p);
 * 	%rdi points to Q.
 * 	%rsi points to P.
 * 	%rdx points to Q1.
 * 	%rcx points to Q2.
 */
	.text
add:
1:
	movq	%rdi,	%rdx	// A1. Initialize. Set Q1 <- Q.
	movq	link(%rdx),	%rdi	// Q <- LINK(Q1).
0:
	movq	link(%rsi),	%rsi	// P <- LINK(P).
	movl	abc(%rsi),	%eax	// %eax <- ABC(P).
2:
	cmpl	abc(%rdi),	%eax	// A2. ABC(P):ABC(Q).
	je	3f	// If equal, got to A3.
	jg	5f	// If greater, go to A5.
	movq	%rdi,	%rdx	// If less, set Q1 <- Q.
	movq	link(%rdx),	%rdi	// Q <- LINK(Q1).
	jmp	2b
3:
	cmpl	$0,	%eax	// A3. Add coefficients.
	jl	return
	movl	coef(%rsi),	%eax	// COEF(P)
	addl	coef(%rdi),	%eax	// 	+ COEF(Q)
	movl	%eax,	coef(%rdi)	// 		-> COEF(Q)
	cmpl	$0,	%eax
	jne	1b	// Jump if nonzero.
	movq	%rdi,	%rcx	// A4. Delete zero term. Q2 <- Q.
	movq	link(%rdi),	%rdi	// Q <- LINK(Q).
	movq	avail,	%rax
	movq	%rax,	link(%rcx)	// AVAIL <= Q2.
	movq	%rcx,	(%rax)
	movq	%rdi,	link(%rdx)	// LINK(Q1) <- Q
	jmp	0b
5:
	movq	avail,	%rcx	// A5. Insert new term.
	cmpq	$0,	%rcx
	je	overflow
	movq	link(%rcx),	%r8	// Q2 <= AVAIL
	movq	%r8,	avail
	movl	%eax,	abc(%rcx)	// ABC(Q2) <- ABC(P) (%eax still holds ABC(P)).
	movl	coef(%rsi),	%eax	// %eax <- COEF(P).
	movl	%eax,	coef(%rcx)	// COEF(Q2) <- %eax
	movq	%rdi,	link(%rcx)	// LINK(Q2) <- Q
	movq	%rcx,	link(%rdx)	// LINK(Q1) <- Q
	movq	%rcx,	%rdx	// Q1 <- Q2
	jmp	0b
return:
	movl	$0, %eax
	ret
overflow:
	movl	$-1,	%eax
	ret
