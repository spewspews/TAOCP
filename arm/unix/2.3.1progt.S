	.equ	left,	0
	.equ	right,	4
	.equ	asize,	4000

	.bss
	.align	2
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
	.align	2
	.global inorder
	.arm
inorder:
T1:	push	{r4-r8, lr}
	mov	r4,	r0
	mov	r5,	r1
	movw	r6,	#:lower16:a
	movt	r6,	#:upper16:a
	mov	r8,	r6
	add	r7,	r6, #asize
T2:	cmp	r4,	#0
	beq	T4
T3:	cmp	r6,	r7
	beq	OVERFLOW
	str	r4,	[r6], #4
	ldr	r4,	[r4, #left]
	b	T2
T4:	cmp	r6,	r8
	popeq	{r4-r8, pc}
	ldr	r4,	[r6, #-4]!
T5:	mov	r0,	r4
	blx	r5
	ldr	r4,	[r4, #right]
	b	T2

OVERFLOW:
	mvn	r0,	#0
	bl	exit
