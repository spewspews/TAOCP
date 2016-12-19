	.bss
top:
	.space 8

/*
 * %rdi is new card
 */
	.global	faceup
	.equ	tag,	0
	.equ	suit,	2
	.equ	rank,	4
	.equ	link,	8
	.text
faceup:
	movq	top,	%rax
	movq	%rax,	link(%rdi)
	movq	%rdi,	top
	movw	$0,	tag(%rdi)
	ret
