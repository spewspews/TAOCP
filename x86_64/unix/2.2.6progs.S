	.global pivot

	/* Offsets for Node */
	.equ right, 0
	.equ down, 8
	.equ row, 16
	.equ col, 20
	.equ val, 24
	.equ nodesize, 32

	/* Offsets for Matrix */
	.equ baserow, 0
	.equ basecol, 8
	.equ rows, 16
	.equ cols, 20

	/* Space on the stack */
	.equ I0, 0
	.equ J0, 4
	.equ BASEROW, 8
	.equ BASECOL, 16
	.equ I, 32
	.equ ALPHA, 40
	.equ EPSILON, 48
	.equ stacksize, 56

	.data
neg:
	.quad	0x8000000000000000
	.quad	0
pos:
	.quad	0x7fffffffffffffff

/* 
 * On entry
 * %rdi points to the Matrix m
 * %esi is the row of the pivot I0.
 * %edx is the col of the pivot J0.
 * %xmm0 is epsilon
 * After entry
 * P0 is %rbx
 * Q0 is %rbp
 * P is %r12
 * PTR is %r13
 * J is %r14
 * PTR[J] is %r15
 * P1 is %rcx
 */
	.text
pivot:
	// Check if the pivot element is out of range.
	cmpl	rows(%rdi),	%esi
	jae	nopivot
	cmpl	cols(%rdi), %edx
	jae	nopivot

	pushq	%rbx	// Allocate this register for P0.
	pushq	%rbp	// Allocate for Q0.
	pushq	%r12	// Allocate for P.
	pushq	%r13	// Allocate for PTR.
	pushq	%r14	// Allocate for J.
	pushq	%r15	// Allocate for PTR[J].
	subq	$stacksize,	%rsp	// Allocate space on the stack.

	// Store variables
	movsd	%xmm0,	EPSILON(%rsp)
	movl	%esi,	I0(%rsp)
	movl	%edx,	J0(%rsp)
	movq	baserow(%rdi),	%rax
	movq	%rax,	BASEROW(%rsp)
	movq	basecol(%rdi),	%rax
	movq	%rax,	BASECOL(%rsp)

	movl	cols(%rdi),	%edi
	sall	$3,	%edi	// Size of the PTR array
	call	malloc	// Allocate it.
	movq	%rax,	%r13	// Set PTR

	movl	I0(%rsp),	%ebx
	salq	$5,	%rbx
	addq	BASEROW(%rsp),	%rbx	// P0 <- LOC(BASEROW[I0])

	movl	J0(%rsp),	%ecx
	movl	$-1,	%eax
0:
	movq	right(%rbx),	%rbx	// P0 <- RIGHT(P0)
	cmpl	col(%rbx),	%eax	// Have we reached the end?
	je	nopivot	// If so there is no pivot element.
	cmpl	col(%rbx),	%ecx
	ja	0b	// Are we at the right column?
	jb	nopivot	// No need to go farther than necessary

// S1.
	movl	$1,	%eax
	cvtsi2sd	%eax,	%xmm0	// ALPHA <- 1
	movsd	%xmm0,	%xmm1
	divsd	val(%rbx),	%xmm0
	movsd	%xmm0,	ALPHA(%rsp)	// ALPHA <- 1/VAL(P0).
	movsd	%xmm1,	val(%rbx)	// VAL(P0) <- 1.0.

	movl	I0(%rsp),	%ebx
	salq	$5,	%rbx
	addq	BASEROW(%rsp),	%rbx	// P0 <- LOC(BASEROW[I0])
	movl	J0(%rsp),	%ebp
	salq	$5,	%rbp
	addq	BASECOL(%rsp),	%rbp	// Q0 <- LOC(BASEROW[J0])

0:	// S2. Process pivot row.
	movq	right(%rbx),	%rbx	// P0 <- RIGHT(P0)
	movl	col(%rbx),	%eax
	cmpl	$-1,	%eax
	je	0f
	salq	$5,	%rax
	addq	BASECOL(%rsp),	%rax	// Calculate LOC(BASECOL[J])
	movl	col(%rbx),	%r14d
	movq	%rax,	(%r13,%r14,8)	// PTR[J] <- LOC(BASECOL[J])
	movsd	val(%rbx),	%xmm0
	mulsd	ALPHA(%rsp),	%xmm0
	movsd	%xmm0,	val(%rbx)	// VAL(P0) <- ALPHA X VAL(P0)
	jmp	0b

0:	// S3. Find new row.
	movq	down(%rbp),	%rbp	// Q0 <- DOWN(Q0)
	movl	row(%rbp),	%eax
	cmpl	$-1,	%eax
	je	end	// Have we reached the end?
	cmpl	I0(%rsp),	%eax	// I = I0?
	je	0b	// We have already done the pivot row.
	movl	%eax,	I(%rsp)
	movl	%eax,	%r12d
	salq	$5,	%r12
	addq	BASEROW(%rsp),	%r12	// P <- LOC(BASEROW[I])
	movq	right(%r12),	%rcx	// P1 <- RIGHT(P).

1:	// S4. Find new column.
	movq	right(%rbx),	%rbx	// P0 <- RIGHT(P0).
	movl	col(%rbx),	%r14d	// Set J.
	cmpl	$-1,	%r14d	// At the end?
	jne	2f
	movsd	val(%rbp),	%xmm0
	xorpd	neg,	%xmm0	// Flip the sign bit.
	mulsd	ALPHA(%rsp),	%xmm0
	movsd	%xmm0,	val(%rbp)	// VAL(Q0) <- -ALPHA * VAL(Q0).
	jmp	0b
2:
	cmpl	J0(%rsp),	%r14d	// Process the pivot column at the end.
	je	1b

	movq	(%r13,%r14,8),	%r15	// put PTR[J] in a register.
2:	// S5.
	cmpl	col(%rcx),	%r14d
	jb	3f	// COL(P1) > J ?
	je	2f	// COL(P1) = J ?
	movq	%rcx,	%r12	// P <- P1
	movq	right(%r12),	%rcx	// P1 <- RIGHT(P)
	jmp	2b

3:
	movl	I(%rsp),	%eax
3:	// S6.
	movq	down(%r15),	%rcx
	cmpl	row(%rcx),	%eax
	jb	3f	//	ROW(DOWN(PTR[J])) > I?
	movq	%rcx,	%r15
	jmp 3b
3:
	movq	$nodesize,	%rdi
	call	malloc	// X <= AVAIL

	movq	right(%r12),	%rcx	// P1 <- RIGHT(P)
	movq	%rcx,	right(%rax)	// RIGHT(X) <- P1
	movq	%rax,	%rcx	// P1 <- X
	movq	%rcx,	right(%r12)	// RIGHT(P) <- P1
	movq	down(%r15),	%rax
	movq	%rax,	down(%rcx)	// DOWN(P1) <- DOWN(PTR[J])
	movq	%rcx,	down(%r15)	// DOWN(PTR[J]) <- P1
	xorpd	%xmm0,	%xmm0
	movsd	%xmm0,	val(%rcx)	// VAL(P1) <- 0
	movl	I(%rsp),	%eax
	movl	%eax,	row(%rcx)	// ROW(P1) <- I
	movl	%r14d,	col(%rcx)	// COL(P1) <- J

2:	// S7.
	movsd	val(%rbx),	%xmm0
	mulsd	val(%rbp),	%xmm0
	movsd	val(%rcx),	%xmm1
	subsd	%xmm0,	%xmm1
	movsd	%xmm1,	val(%rcx)	// VAL(P1) <- VAL(P1)-VAL(P0)*VAL(Q0)
	andpd	pos,	%xmm1	// Clear the sign bit.
	ucomisd	EPSILON(%rsp),	%xmm1
	jb	2f	// |VAL(P1)| < epsilon?
	movq	%rcx,	(%r13,%r14,8)	// PTR[J] <- P1
	movq	%rcx,	%r12	// P <- P1
	movq	right(%r12),	%rcx	// P1 <- RIGHT(P)
	jmp	1b	// To S4.

2:
	cmpq	down(%r15),	%rcx	// DOWN[PTR[J]] is P1?
	je	2f
	movq	down(%r15),	%r15
	jmp 2b
2:
	movq	down(%rcx),	%rax
	movq	%rax,	down(%r15)	// DOWN(PTR[J]) <- DOWN(P1)
	movq	right(%rcx),	%rax
	movq	%rax,	right(%r12)	// RIGHT(P) <- RIGHT(P1)

	movq	%rcx,	%rdi
	call	free

	movq	right(%r12),	%rcx	// P1 <- RIGHT(P)
	jmp	1b

nopivot:
	movq	$-1,	%rax
	jmp 1f
end:
	xorq	%rax,	%rax
1:
	addq	$stacksize,	%rsp
	popq	%r15	// Allocate for PTR[J].
	popq	%r14	// Allocate for J.
	popq	%r13	// Allocate for PTR.
	popq	%r12	// Allocate for P.
	popq	%rbp	// Allocate for Q0.
	popq	%rbx	// Allocate this register for P0.
	ret
