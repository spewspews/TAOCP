	.equ	left,	0
	.equ	right,	4
	.equ	asize,	1000

	.bss
	.align	4
a:
	.space	asize

/*
 * On entry:
 * r0 is Node *p
 * r1 is pointer to visit function
 *
 * After entry:
 * r4 is Node *p
 * r5 is pointer to visit function
 * r6 is stack pointer
 * r7 is end of stack pointer
 * r8 is beginning of stack pointer
 */

	.text
	.align	4
	.global	inorder
	.arm
inorder:
T1:	cmp	r0,	#0		// 1
T2A:	bxeq	lr			// 1
	push	{r4-r8, lr}		// 1
	mov	r4,	r0		// 1
	mov	r5,	r1		// 1
	movw	r6,	#:lower16:a	// 1
	movt	r6,	#:upper16:a	// 1
	mov	r8,	r6		// 1
	add	r7,	r6, #asize	// 1
T3:	cmp	r6,	r7		// n
	bhs	OVERFLOW		// n
	str	r4,	[r6], #4	// n
	ldr	r4,	[r4, #left]	// n
T2B:	cmp	r4,	#0		// n
	bne	T3			// n
T4:	ldr	r4,	[r6, #-4]!	// n
T5:	mov	r0,	r4		// n
	blx	r5			// n
	ldr	r4,	[r4, #right]	// n
T2C:	cmp	r4,	#0		// n
	bne	T3			// n
	cmp	r6,	r8		// a
	bhi	T4			// a
	pop	{r4-r8, pc}		// 1
OVERFLOW:
	mvn	r0,	#0
	bl	exit
