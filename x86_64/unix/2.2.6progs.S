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
	.equ matrixsize, 24

	/* Space on the stack */
	.equ I0, 0
	.equ J0, 4
	.equ BASEROW, 8
	.equ BASECOL, 16
	.equ PTR, 24
	.equ I, 32
	.equ J, 36
	.equ stacksize, 40

	.data
neg:
	.quad	0x8000000000000000

/* 
 * On entry
 * %rdi points to the Matrix m
 * %esi is the row of the pivot I0.
 * %edx is the col of the pivot J0.
 * After entry
 * %rcx is P0
 * %rdx is Q0
 * %edi is J and P (%rdi)
 * %esi is I and P1 (%rsi)
 * %r8 is PTR
 * %xmm0 is ALPHA
 * OLD STUFF BELOW
 * %r8 is Q0
 * %rdi is I
 * %r9 is J
 */
	.text
pivot:
	// Check if the pivot element is out of range.
	cmpl	rows(%rdi),	%esi
	jae	nopivot
	cmpl	cols(%rdi), %edx
	jae	nopivot

	subq	$stacksize,	%rsp	// Allocate space on the stack.

	// Store variables
	movl	%esi,	I0(%rsp)
	movl	%edx,	J0(%rsp)
	movq	baserow(%rdi),	%rax
	movq	%rax,	BASEROW(%rsp)
	movq	basecol(%rdi),	%rax
	movq	%rax,	BASECOL(%rsp)

	movl	cols(%rdi),	%edi
	sall	$3,	%edi	// Size of the PTR array
	call	malloc	// Allocate it.
	movq	%rax,	PTR(%rsp)	// Set PTR

	movl	I0(%rsp),	%ecx
	salq	$5,	%rcx
	addq	BASEROW(%rsp),	%rcx	// P0 <- LOC(BASEROW[I0])

	movl	J0(%rsp),	%edx
	movl	$-1,	%eax
0:
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0)
	cmpl	col(%rcx),	%eax	// Have we reached the end?
	je	nopivot	// If so there is no pivot element.
	cmpl	col(%rcx),	%edx
	ja	0b	// Are we at the right column?
	jb	nopivot	// No need to go farther than necessary

	movl	$1,	%eax
	cvtsi2sd	%eax,	%xmm0	// ALPHA <- 1
	movsd	val(%rcx),	%xmm1
	divsd	%xmm1,	%xmm0	// ALPHA <- 1/VAL(P0).

	cvtsi2sd	%eax,	%xmm1
	movsd	%xmm1,	val(%rcx)	// VAL(P0) <- 1.0. This completes S1.

	movl	I0(%rsp),	%ecx
	salq	$5,	%rcx
	addq	BASEROW(%rsp),	%rcx	// P0 <- LOC(BASEROW[I0])
	movl	$-1,	%eax
	movq	PTR(%rsp),	%r8
0:
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0)
	cmpl	col(%rcx),	%eax	// Are we done?
	je	0f
	movl	col(%rcx),	%edx
	salq	$5,	%rdx
	addq	BASECOL(%rsp),	%rdx	// Calculate LOC(BASECOL[J])
	movl	col(%rcx),	%edi
	movq	%rdx,	(%r8, %rdi, 8)	// PTR[J] <- LOC(BASECOL[J])
	movsd	val(%rcx),	%xmm1
	mulsd	%xmm0,	%xmm1
	movsd	%xmm1,	val(%rcx)	// VAL(P0) <- ALPHA X VAL(P0)
	jmp	0b

	movl	J0(%rsp),	%edx
	salq	$5,	%rdx
	addq	BASECOL(%rsp),	%rdx	// Q0 <- LOC(BASEROW[J0])
0:	// S3.
	movq	down(%rdx),	%rdx	// Q0 <- DOWN(Q0)
	movl	row(%rdx),	%eax
	cmpl	$-1,	%eax
	je	end	// Have we reached the end?
	cmpl	I0(%rsp),	%eax	// I = I0?
	je	0b	// We have already done the pivot row.
	movl	%eax,	I(%rsp)
	movl	%eax,	%edi
	salq	$5,	%rdi
	addq	BASEROW(%rsp),	%rdi	// P <- LOC(BASEROW[I])
	movq	right(%rdi),	%rsi	// P1 <- RIGHT(P).

1:	// S4.
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0).
	movl	col(%rcx),	%eax
	cmpl	$-1,	%eax	// Are at the end?
	jne	2f
	movsd	val(%rdx),	%xmm1
	xorpd	neg,	%xmm1	// Flip the sign bit.
	mulsd	%xmm0,	%xmm1
	movsd	%xmm1,	val(%rdx)	// VAL(Q0) <- -ALPHA * VAL(Q0).
	jmp	0b
2:
	cmpl	J0(%rsp),	%eax	// Process the pivot column at the end.
	je	1b

2:	// S5.
	cmpl	col(%rsi),	%eax
	ja	1f	// COL(P1) < J ?
	je	2f	// COL(P1) = J ?
	movq	%rsi,	%rdi	// P <- P1
	movq	right(%rdi),	%rsi	// P1 <- RIGHT(P)
	jmp	2b

1:	// S6.

2:	// S7.

nopivot:
	addq	$stacksize,	%rsp
	movq	$-1,	%rax
	ret

end:
	addq	$stacksize,	%rsp
	xorq	%rax,	%rax
	ret
