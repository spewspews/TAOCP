	.global	topsort
	.equ	count,	0
	.equ	qlink,	0
	.equ	top,	4
	.equ	j,	0
	.equ	k,	4
	.equ	suc,	0
	.equ	next,	4
	.equ	bp,	0
	.equ	n,	4

	.bss
	.align	2
x:
	.space	1024*8

/*
 * On entry:
 * r0 is the buffer pointer
 * r1 is n
 *
 * r0 = buffer pointer
 * r1 = AVAIL and P
 * r2 = k
 * r3 = j and R
 * r4 = Holds the base address of the memory pool.
 * r5 = scratch and F
 * r6 = scratch
 * r7 = scratch
 */

	.text
	.align	2
topsort:
	push	{r0, r1, r4-r7}		// Save buffer pointer, n, and variable registers.
	movw	r4,	#:lower16:x
	movt	r4,	#:upper16:x
	add	r1,	#1		// Avaliable storage in x starts after n.
1:
	ldr	r3,	[r0, #j]	// T2. Next relation
	cmp	r3,	#0
	beq	1f			// At the end?
	ldr	r2,	[r0, #k]	// T3 Record relation
	add	r5,	r4, r2, lsl #3	// r5 is k's node.
	ldr	r6,	[r5, #count]
	add	r6,	#1
	str	r6,	[r5, #count]	// increment the predecessor count
	add	r5,	r4, r3, lsl #3	// r5 is j's node
	add	r6,	r4, r1, lsl #3	// Grab available node P
	ldr	r7,	[r5, #top]	// TOP(J)
	str	r7,	[r6, #next]	//  -> NEXT(P)
	str	r2,	[r6, #suc]	// k -> SUC(P)
	str	r1,	[r5, #top]	// P -> TOP(J)
	add	r1,	#1		// AVAIL <- AVAIL+1
	add	r0,	#8
	b	1b
1:
	ldr	r2,	[sp, #n]	// T4. Scan for zeroes. k <- n.
	mov	r3,	#0
1:
	add	r5,	r4, r2, lsl #3	// r5 is k's node.
	ldr	r5,	[r5, #count]	// r5 is COUNT(k)
	cmp	r5,	#0
	bgt	2f
	add	r3,	r4, r3, lsl #3	// if COUNT(k) = 0
	str	r2,	[r3, #qlink]	// 	QLINK(R) <- k
	mov	r3,	r2		// 	R <- k
2:					//
	sub	r2,	#1		// n <- n - 1;
	cmp	r2,	#0
	bgt	1b			// loop for 1 <= k <= n
// Sorting Phase
	ldr	r0,	[sp]		// Reset buffer pointer for output.
	ldr	r5,	[r4, #qlink]	// F <- QLINK[0] (r5 is F)
1:	// T5. Output front of queue.
	str	r5,	[r0], #4	// Store F in buffer area
	cmp	r5,	#0		// if F is 0 we are done.
	beq	1f
	add	r5,	r4, r5, lsl #3	// r5 is F
	ldr	r1,	[r5, #top]	// TOP(P)
	cmp	r1,	#0
	beq	4f
2:	// T6. Erase relations.
	add	r1,	r4, r1,lsl #3	// r1 is P <- TOP(P)
	ldr	r2,	[r1, #suc]	// k <- SUC(P)
	add	r7,	r4, r2, lsl #3
	ldr	r8,	[r7, #count]	// r8 is COUNT(K)
	sub	r8,	#1
	str	r8,	[r7, #count]	// COUNT(K) <- COUNT(K) - 1
	cmp	r8,	#0
	bgt	3f
	add	r3,	r4, r3, lsl #3
	str	r2,	[r3, #qlink]	// QLINK(R) <- k
	mov	r3,	r2		// R <- k
3:
	ldr	r1,	[r1, #next]
	cmp	r1,	#0
	bgt	2b
4:	// T7. Remove from queue.
	ldr	r5,	[r5, #qlink]	// F <- QLINK(F)
	b	1b
1:
	pop	{r0, r1, r4-r7}
	bx	lr
