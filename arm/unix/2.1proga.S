	.bss
	.align	2
top:
	.space 4

/*
 * r0 is new card
 */
	.global	faceup
	.equ	tag,	0
	.equ	suit,	1
	.equ	rank,	2
	.equ	link,	4
	.text
	.align	2
faceup:
	movw	r1,	#:lower16:top
	movt	r1,	#:upper16:top
	ldr	r2,	[r1]
	str	r2,	[r0,#link]
	str	r0,	[r1]
	mov	r1,	#0
	strb	r1,	[r0,#tag]
	bx	lr
