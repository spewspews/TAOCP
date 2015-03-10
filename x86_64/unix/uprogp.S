/* print the first 500 primes */
#include <machine/asm.h>

#define L	500
#define n	%bx
#define j	%r12
#define k	%r13
#define pk	%r14d

	.data
fmt:	.asciz	"%d\n"
	.comm	x, L*2

ENTRY(main)
	movw	$2, x	/* first prime */
	movw	$3, n	/* second prime */
	movq	$1, j
Mtwo:
	movw	n, x(,j,2)	/* add new prime to array */
	incq	j
Mthree:
	cmpq	$L, j
	je	print
Mfour:
	addw	$2, n	/* next prime candidate */
Mfive:
	movq	$1, k
Msix:
	movzwl	x(,k,2), pk
	movzwl	n, %eax
	xorq	%rdx, %rdx
	divl	pk	/* divide by prime from array */
	cmpl	$0, %edx	/* not prime if no remainder */
	je	Mfour
Mseven:
	cmpl	pk, %eax	/* prime if quotient is <= to divisor */
	jle	Mtwo
Meight:
	incq	k	/* try dividing by next prime in array */
	jmp	Msix
print:
	xorq	j, j
loop:
	movq	$fmt, %rdi	/* print all the primes */
	movzwl	x(,j,2), %esi
	xorb	%al, %al	/* no floating point arguments to printf */
	call	printf
	incq	j
	cmpq	$L, j
	je	end
	jmp	loop
end:
	xorq	%rdi, %rdi
	callq	exit
	ret
