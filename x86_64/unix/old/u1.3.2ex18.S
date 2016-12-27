/*
 * This is Exercise 18 from section
 * 1.3.2 implemented with the further
 * suggestion Knuth makes.
 *
 * See usaddlemain.c for how to call this
 * function.
 */

#include <machine/asm.h>

#define	a	%rbp
#define r	%esi
#define c	%edi
#define	i	%r8d
#define minmax	%r9b
#define	maxmin	%r10b
#define	si	%r11d
#define	sj	%r12d

	.data
fmt:	.asciz	"Saddle point at row %d, col %d\n"
	.lcomm	rmin, 1000
	.lcomm	cmax, 1000

ENTRY(saddle)
	subq	$8, %rsp		/* make room on stack for local variables and align it*/
	movq	%rdi, a
	movl	%edx, c			/* move third argument to columns register */
	movl	r, i			/* r is already second argument register */
	decl	i			/* start at r-1 */
Rowloop:
	movl	c, %eax
	imull	i, %eax
	movb	(a,%rax), %bl	/* bl is a[i*c] */
	movb	%bl, rmin(i)
	cmpb	cmax, %bl
	jle	1f
	movb	%bl, cmax
1:
	movl	c, %ecx
	decl	%ecx			/* start at c-1 */
	addl	%ecx, %eax		/* eax is now i*c + (c - 1) */
Colloop:
	movb	(a,%rax), %bl	/* bl is a[i*c + j] */
	cmpb	rmin(i), %bl
	jge	1f
	movb	%bl, rmin(i)
1:
	cmpb	cmax(%ecx), %bl 
	jle	1f
	movb	%bl, cmax(%ecx)
1:
	decl	%eax
	loop	Colloop
	decl	i
	cmpl	$0, i 
	jge	Rowloop

	movb	rmin, maxmin
	movl	$0, si
	movl	r, %ecx
	decl	%ecx
Getmaxmin:
	cmpb	rmin(%ecx), maxmin
	jge	1f
	movb	rmin(%ecx), maxmin
	movl	%ecx, si
1:
	loop	Getmaxmin

	movb	cmax, minmax
	movl	$0, sj
	movl	c, %ecx
	decl	%ecx
Getminmax:
	cmpb	cmax(%ecx), minmax
	jle	1f
	movb	cmax(%ecx), minmax
	movl	%ecx, sj
1:
	loop	Getminmax

	cmpb	minmax, maxmin
	jne	1f
	movb	minmax, (%rsp)
	movq	$fmt, %rdi
	movl	si, %esi
	movl	sj, %edx
	xorb	%al, %al
	call	printf
	movsbl	(%rsp), %eax
	jmp	2f
1:
	movl	$-1, %eax
2:
	addq	$8, %rsp		/* put stack back in place */
	ret
