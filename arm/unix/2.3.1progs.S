	.equ	left,	0
	.equ	right,	4
/*
 * On entry:
 * r0 is Node *p
 * r1 is pointer to visit function
 *
 * After entry:
 * r4 is Node *p
 * r5 is pointer to visit function
 */

	.text
	.align	4
	.global	inorder
	.arm
inorder:
S0:	cmp	r0,	#0		// 1
	bxeq	lr			// 1
	push	{r4, r5, lr}		// 1
	mov	r4,	r0		// 1
	mov	r5,	r1		// 1
	ldr	r0,	[r4, #left]	// 1	Q ← LEFT(HEAD)
	tst	r0,	#1		// 1
	beq	2f			// 1	If LTAG(HEAD) = 0, search to left.
1:	cmp	r4,	#1		// a
	popeq	{r4, r5, pc}		// 1	If P = NULL return.
	eor	r4,	r4, #1		// a-1	Clear the tag.
S3:	mov	r0,	r4		// n
	blx	r5			// n	Visit
S1:	ldr	r4,	[r4, #right]	// n	S1. P ← RIGHT(P)
	tst	r4,	#1		// n
	bne	1b			// a	Jump if RTAG(P) = 1.
S2:	ldr	r0,	[r4, #left]	// n-1	Q ← LEFT(P)
	tst	r0,	#1		// n-1	
	bne	S3			// n-a+1 If LTAG(P) = 1, visit.
2:	mov	r4,	r0		// a-1	P ← Q
	b	S2			// a-1

// Running time is 7n + 4a + 6
// n number of nodes, a number of nodes with no right child.
// I count a branch only if it is taken.
