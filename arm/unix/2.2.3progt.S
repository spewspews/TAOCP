	.global topsort
	.equ count, 0
	.equ qlink, 0
	.equ top, 4
	.equ j, 0
	.equ k, 4
	.equ suc, 0
	.equ next, 4

	.bss
	.align 2
x:
	.space 1024*8
bp:
	.space 4

/*
 * r0 = buffer pointer
 * r1 = AVAIL
 * r2 = k
 * r3 = j
 * r4 = n
 * r5 = Holds the base address of the memory pool.
 * r6 = scratch
 * r7 = scratch
 * r8 = scratch
 */

	.text
	.align 2
topsort:
	push	{r4-r8}
	push	{r0}	// Save the buffer pointer.
	mov	r4,	r1	// Store n in an index register.
	movw	r5,	#:lower16:x
	movt	r5,	#:upper16:x
	add	r1,	r1, #1	// Avaliable storage in x starts after n.
1:
	ldr	r3, [r0,#j]	// T2. Next relation
	cmp r3, #0
	beq	1f	// At the end?
	ldr	r2,	[r0,#k]	// r2 gets k
	add	r6,	r5, r2, lsl #3	// r6 is k's node.
	ldr	r7,	[r6, #count]
	add	r7,	#1
	str	r7,	[r6, #count]	// increment the predecessor count
	add	r6,	r5, r3, lsl #3	// r6 is j's node
	add	r7,	r5, r1, lsl #3	// Grab available node
	ldr	r8,	[r6, #top]	// TOP(J)
	str	r8,	[r7, #next]	//  -> NEXT(P)
	str	r2,	[r7, #suc]	// k -> SUC(P)
	str	r7,	[r6, #top]	// P -> TOP(J)
	add	r1,	#1	// AVAIL <- AVAIL+1
	add	r0,	#8
	b	1b
1:
	mov	r0,	r4
	pop	{r4-r7}
	bx	lr
