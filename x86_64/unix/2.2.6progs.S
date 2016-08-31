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


/* 
 * On entry
 * %rdi points to the Matrix m
 * %esi is the row of the pivot I0.
 * %edx is the col of the pivot J0.
 * After entry
 * %rcx is P0
 * %r8 is Q0
 * %xmm0 is ALPHA
 */
	.text
pivot:
	movq	baserow(%rdi),	%rcx	// P0 <- LOC(BASEROW)
	movq	$nodesize,	%rax	// Calculate offet of the I0 row.
	imulq	%rsi,	%rax
	addq	%rax,	%rcx	// P0 <- LOC(BASEROW[I0])
	movl	$-1,	%eax
0:
	movq	right(%rcx),	%rcx	// P0 <- right(P0)
	cmpl	col(%rcx),	%eax	// Have we reached the end?
	je	nopivot	// If so there is no pivot element.
	cmpl	col(%rcx),	%edx
	ja	0b	// Are we at the right column?
	jb	nopivot	// No need to go farther than necessary
	movl	$1,	%eax
	cvtsi2sd	%eax,	%xmm0	// ALPHA <- 1
	movsd	val(%rcx),	%xmm1
	divsd	%xmm1,	%xmm0	// ALPHA <- 1/VAL(P0)
	ret
	
nopivot:
	movq	$-1,	%rax
	ret
