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
	bhs	OVERFLOW		// n	Stack at capacity?
	str	r4,	[r6], #4	// n	If not store P in the stack.
	ldr	r4,	[r4, #left]	// n	P ← LEFT(P).
T2B:	cmp	r4,	#0		// n
	bne	T3			// n	To T3 if P ≠ Λ.
T4:	ldr	r4,	[r6, #-4]!	// n	T4. P ⇐ Stack.
T5:	mov	r0,	r4		// n	T5. Visit P
	blx	r5			// n
	ldr	r4,	[r4, #right]	// n	P ← RIGHT(P)
T2C:	cmp	r4,	#0		// n	T2. P = Λ?
	bne	T3			// n	To T3 if p ≠ Λ.
	cmp	r6,	r8		// a
	bhi	T4			// a	To T4 if stack non-empty.
	pop	{r4-r8, pc}		// 1
OVERFLOW:
	mvn	r0,	#0
	bl	exit

// Running time is 12n + 2a + 10
// n number of nodes, a number of nodes with no right child.
