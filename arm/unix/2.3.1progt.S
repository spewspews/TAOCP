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
 * r6 is beginning of stack pointer
 * r7 is end of stack pointer
 * r8 is beginning of stack pointer
 */

	.text
	.align	4
	.global	inorder
	.arm
inorder:
T1:	cmp	r0,	#0		// 1
	bxeq	lr			// 1
T2A:	push	{r4-r6, lr}		// 1
	mov	r4,	r0		// 1
	mov	r5,	r1		// 1
	mov	r6,	sp		// 1
T3:	push	{r4}			// n	Store P in the stack.
	ldr	r4,	[r4, #left]	// n	P ← LEFT(P).
T2B:	cmp	r4,	#0		// n
	bne	T3			// n	To T3 if P ≠ Λ.
T4:	pop	{r4}			// n	T4. P ⇐ Stack.
T5:	mov	r0,	r4		// n	T5. Visit P
	blx	r5			// n
	ldr	r4,	[r4, #right]	// n	P ← RIGHT(P)
T2C:	cmp	r4,	#0		// n	T2. P = Λ?
	bne	T3			// n	To T3 if p ≠ Λ.
	cmp	sp,	r6		// a
	bne	T4			// a	To T4 if stack non-empty.
	pop	{r4-r6, pc}		// 1

// Running time is 10n + 2a + 6
// n number of nodes, a number of nodes with no right child.
