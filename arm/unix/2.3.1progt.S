	.global inorder
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
inorder:
T1:	push	{r4-r8}
	mov	r4,	r0
	mov	r5,	r1
	movw	r6,	#:lower16:x
	movt	r6,	#:upper16:x
	mov	r8,	r6
	add	r7,	r6, #asize
T2:	cmp	r4,	#0
	beq	T4
T3:	cmp	r6,	r7
	beq	OVERFLOW
	str	r4,	[r6], #4
	ldr	r4,	[r4, #left]
	b	T2
T4:
	cmp	r6,	r8
	beq	RET
	ldr	r4,	[r6, #-4]!
	blx	r5
	ldr	r4,	[r4, #right]
	b	T2

RET:
	pop	{r4-r8}
	bx	lr
OVERFLOW:
	mov	r0,	#-1
	blx	exit
