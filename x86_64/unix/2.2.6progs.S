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
	.equ m, 0
	.equ I0, 8
	.equ J0, 12
	.equ stacksize, 24

/* 
 * On entry
 * %rdi points to the Matrix m
 * %esi is the row of the pivot I0.
 * %edx is the col of the pivot J0.
 * After entry
 * %rcx is P0
 * %r8 is Q0
 * %rdi is I
 * %r9 is J
 * %r10 is the array PTR
 * %xmm0 is ALPHA
 */
	.text
pivot:
	subq	$stacksize,	%rsp	// Allocate space on the stack.

	movq	%rdi,	m(%rsp)
	movl	%esi,	I0(%rsp)	// Store the variables
	movl	%edx,	J0(%rsp)
	movl	cols(%rdi),	%edi
	movq	$nodesize,	%rax
	imulq	%rax,	%rdi	// Size of the PTR array
	call	malloc	// Allocate it.
	movq	%rax,	%r10	// Set PTR
	movq	m(%rsp),	%rdi
	movl	I0(%rsp),	%esi	// Get the variables back
	movl	J0(%rsp),	%edx

	movq	baserow(%rdi),	%rcx	// P0 <- LOC(BASEROW[0])
	movq	$nodesize,	%r11	// Calculate offet of the I0 row.
	imulq	%rsi,	%r11
	addq	%r11,	%rcx	// P0 <- LOC(BASEROW[I0])
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
	divsd	%xmm1,	%xmm0	// ALPHA <- 1/VAL(P0)
	cvtsi2sd	%eax,	%xmm1
	movsd	%xmm1,	val(%rcx)	// VAL(P0) <- 1.0
	movq	baserow(%rdi),	%rcx	// P0 <- LOC(BASEROW)
	addq	%r11,	%rcx	// P0 <- LOC(BASEROW[I0]) (%r11 still holds $nodesize*I0)
	movq	basecol(%rdi),	%r8	// Q0 <- LOC(BASEROW[0])
	movq	$nodesize,	%r11
	imulq	%rdx,	%r11
	addq	%r11,	%r8	// Q0 <- LOC(BASEROW[J0]
0:
	movq	right(%rcx),	%rcx	// P0 <- RIGHT(P0)
	movl	col(%rcx),	%r9d	// J <- COL(P0)
	cmpl	$-1,	%r9d	// At the end of the row?
	je	0f	// If so we are done
	jmp 0b
0:
	addq	$stacksize,	%rsp
	ret
	
nopivot:
	movq	$-1,	%rax
	ret
