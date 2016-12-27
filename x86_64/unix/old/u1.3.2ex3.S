/* reads 100 octabytes into a buffer, sorts them
 * into increasing order and writes them
 * to standard output. Pipe it to printlongs
 * to see a sorted list of the values
 */

#include <sys/syscall.h>

	.data
	.globl x
x:	.space	808
fmt:	.asciz	"%lld\n"

	.text
	.globl	main
	.type	main, @function

main:
	movq	$0, %rdi	/* read 800 values into x */
	leaq	x+8, %rsi
	movq	$800, %rdx
	movq	$SYS_read, %rax
	syscall
	movq	$100, %r8
loop:
	pushq	%r8	/* save our register */
	movq	%r8, %rdi	/* get max value */
	call	maximum
	popq	%r8
	movq	x(,%r8,8), %rbx	/* swap max value and end value */
	movq	x(,%rax,8), %rcx
	movq	%rcx, x(,%r8,8)
	movq	%rbx, x(,%rax,8)
	decq	%r8
	cmpq	$0, %r8
	jne	loop
	movq	$1, %rdi	/* print out x */
	leaq	x+8, %rsi
	movq	$800, %rdx
	movq	$SYS_write, %rax
	syscall
	xorq	%rdi, %rdi
	movq	$SYS_exit, %rax
	syscall
	.size	main,.-main
	.end
