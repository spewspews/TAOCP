	.global pivot

	/* Offsets for Node */
	.equ right, 0
	.equ down, 8
	.equ row, 16
	.equ row, 20
	.equ val, 24

	/* Offsets for Matrix */
	.equ baserow, 0
	.equ basecol, 8
	.equ rows, 16
	.equ cols, 20


/* %rdi points to the Matrix m
 * %rsi is the row of the pivot.
 * %rdx is the col of the pivot.
	.text
	.align 8
pivot:
	