	.global pivot

	/* Offsets for Node */
	.equ right, 0
	.equ down, 8
	.equ row, 16
	.equ col, 20
	.equ val, 24

	/* Offsets for Matrix */
	.equ baserow, 0
	.equ basecol, 8
	.equ rows, 16
	.equ cols, 20


/* 
 * On entry
 * %rdi points to the Matrix m
 * %rsi is the row of the pivot I0.
 * %rdx is the col of the pivot J0.
 * After entry
 * %rcx is P0
 * %r8 is Q0
 * %xmm0 is ALPHA
 */
	.text
pivot:
0:
	leaq	baserow(%rdi,%rsi*8),	%rcx	// P0 <- LOC(baserow[I0])
	movl	$-1,	%rax
	movq	right(%rcx),	%rcx	// P0 <- right(P0)
	cmpl	col(%rcx),	%rax	// Have we reached the end?
	je	nopivot	// If so there is no pivot element.
	cmpl	col(%rcx),	%rdx
	jb	0b	// Are we at the right column?
	leaq	basecol(%rdi,%rdx*8),	%r8
	
	cvtsi2sd	$1,	xmm0
	movsd
nopivot:
	movq	$-1,	%rax
	ret
