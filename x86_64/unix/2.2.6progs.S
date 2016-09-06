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
	.equ P, 40
	.equ P1, 48
	.equ ALPHA, 56
	.equ Q0, 64
	.equ P0, 72
	.equ stacksize, 88

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
 * %rdi is P
 * %rsi is P1
 * %r8 is PTR
 * %r9 is PTR[J]
 * %r10 is DOWN(PTR[J])
 * %r11 is J and J0
 * %xmm0 is ALPHA
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

	movl	J0(%rsp),	%r11d
	movl	$-1,	%eax
0:
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0)
	cmpl	col(%rcx),	%eax	// Have we reached the end?
	je	nopivot	// If so there is no pivot element.
	cmpl	col(%rcx),	%r11d
	ja	0b	// Are we at the right column?
	jb	nopivot	// No need to go farther than necessary

// S1.
	movl	$1,	%eax
	cvtsi2sd	%eax,	%xmm0	// ALPHA <- 1
	movsd	%xmm0,	%xmm2
	movsd	val(%rcx),	%xmm1
	divsd	%xmm1,	%xmm0	// ALPHA <- 1/VAL(P0).
	movsd	%xmm2,	val(%rcx)	// VAL(P0) <- 1.0.

	movl	I0(%rsp),	%ecx
	salq	$5,	%rcx
	addq	BASEROW(%rsp),	%rcx	// P0 <- LOC(BASEROW[I0])
	movl	J0(%rsp),	%edx
	salq	$5,	%rdx
	addq	BASECOL(%rsp),	%rdx	// Q0 <- LOC(BASEROW[J0])

	movq	PTR(%rsp),	%r8
0:	// S2. Process pivot row.
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0)
	movl	col(%rcx),	%eax
	cmpl	$-1,	%eax
	je	0f
	salq	$5,	%rax
	addq	BASECOL(%rsp),	%rax	// Calculate LOC(BASECOL[J])
	movl	col(%rcx),	%r11d
	movq	%rax,	(%r8,%r11,8)	// PTR[J] <- LOC(BASECOL[J])
	movsd	val(%rcx),	%xmm1
	mulsd	%xmm0,	%xmm1
	movsd	%xmm1,	val(%rcx)	// VAL(P0) <- ALPHA X VAL(P0)
	jmp	0b

0:	// S3. Find new row.
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

1:	// S4. Find new column.
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0).
	movl	col(%rcx),	%r11d
	cmpl	$-1,	%r11d	// Are at the end?
	jne	2f
	movsd	val(%rdx),	%xmm1
	xorpd	neg,	%xmm1	// Flip the sign bit.
	mulsd	%xmm0,	%xmm1
	movsd	%xmm1,	val(%rdx)	// VAL(Q0) <- -ALPHA * VAL(Q0).
	jmp	0b
2:
	cmpl	J0(%rsp),	%r11d	// Process the pivot column at the end.
	je	1b

2:	// S5.
	cmpl	col(%rsi),	%r11d
	jb	3f	// COL(P1) > J ?
	je	2f	// COL(P1) = J ?
	movq	%rsi,	%rdi	// P <- P1
	movq	right(%rdi),	%rsi	// P1 <- RIGHT(P)
	jmp	2b

3:
	movq	(%r8,%r11,8),	%r9	// PTR[J]
	movl	I(%rsp),	%eax
3:	// S6.
	movq	down(%r9),	%r10
	cmpl	row(%r10),	%eax
	jb	3f	//	ROW(DOWN(PTR[J])) > I?
	movq	%r10,	%r9
	jmp 3b
3:
	movq	%r9,	(%r8,%r11,8)	// Save PTR[J].
	movl	%r11d,	J(%rsp)
	movq	%rcx,	P0(%rsp)
	movq	%rdx,	Q0(%rsp)
	movq	%rdi,	P(%rsp)
	movq	%rsi,	P1(%rsp)
	movsd	%xmm0,	ALPHA(%rsp)
	movq	$nodesize,	%rdi
	call	malloc	// X <= AVAIL
	movq	P0(%rsp),	%rcx
	movq	Q0(%rsp),	%rdx
	movq	P(%rsp),	%rdi
	movq	P1(%rsp),	%rsi
	movsd	ALPHA(%rsp),	%xmm0
	movq	PTR(%rsp),	%r8
	movl	J(%rsp),	%r11d
	movq	(%r8,%r11,8),	%r9

	movq	%rsi,	right(%rax)	// RIGHT(X) <- P1
	movq	%rax,	%rsi	// P1 <- X
	movq	%rsi,	right(%rdi)	// RIGHT(P) <- X
	movq	down(%r9),	%rax
	movq	%rax,	down(%rsi)	// DOWN(X) <- DOWN(PTR[J])
	movq	%rsi,	down(%r9)	// DOWN(PTR[J]) <- X
	xorpd	%xmm1,	%xmm1
	movsd	%xmm1,	val(%rsi)	// VAL(X) <- 0
	movl	I(%rsp),	%eax
	movl	%eax,	row(%rsi)	// ROW(X) <- I
	movl	J(%rsp),	%eax
	movl	%eax,	col(%rsi)	// COL(X) <- J
	
2:	// S7.
	movsd	val(%rcx),	%xmm1
	mulsd	val(%rdx),	%xmm1
	movsd	val(%rsi),	%xmm2
	subsd	%xmm1,	%xmm2
	movsd	%xmm2,	val(%rsi)	// VAL(P1) <- VAL(P1) - VAL(P0) * VAL(Q0)
	movq	%rsi,	(%r8,%r11,8)	// PTR[J] <- P1
	movq	%rsi,	%rdi	// P <- P1
	movq	right(%rdi),	%rsi	// P1 <- RIGHT(P)
	jmp	1b	// To S4.

nopivot:
	addq	$stacksize,	%rsp
	movq	$-1,	%rax
	ret

end:
	addq	$stacksize,	%rsp
	xorq	%rax,	%rax
	ret
