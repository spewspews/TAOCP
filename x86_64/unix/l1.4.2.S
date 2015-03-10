/*
 * Knuth's coroutine from §1.4.2
 * Register R15 is used for passing
 * values between the two coroutines
 */
#include <sys/syscall.h>

#define ENTRY(x) \
	.text; .align 16, 0x90; .globl x; .type x,@function; x:

.comm	in, 8
.comm	out, 8
.comm	inbuf, 1000
.comm	outbuf, 64
.comm	inptr, 4
.comm	outptr, 4
.comm	i, 1

ENTRY(main)
	/*
	 * coroinit returns twice: 0 initially
	 * and 1 when jumped to from a call to
	 * go.
	 */
	movq	$in, %rdi
	call	coroinit
	cmpq	$1, %rax
	je	in1
	jmp	out1
/* first coroutine */
callout:
	movq	$out, %rdi
	movq	$in, %rsi
	call	go
in1:
	call	nextchar
	movb	%al, %r15b
	cmpb	$'9', %al
	jg	callout
	subb	$'0', %al
	cmpb	$0, %al
	jl	callout
	movb	%al, i
	call	nextchar
	movb	%al, %r15b
inloop:
	movq	$out, %rdi
	movq	$in, %rsi
	call	go
	movb	i, %al
	decb	%al
	movb	%al, i
	cmpb	$0, %al
	jge	inloop
	jmp	in1
/* second coroutine */
emptybuf:
	movq	$1, %rdi
	movq	$outbuf, %rsi
	movq	$64, %rdx
	movq	$SYS_write, %rax
	syscall
out1:
	movl	$0, outptr
outloop:
	movq	$in, %rdi
	movq	$out, %rsi
	call	go
	movl	outptr, %ebx
	movb	%r15b, outbuf(,%ebx,1)
	cmpb	$'.', %r15b
	je	end
	movl	%ebx, outptr
	movq	$in, %rdi
	movq	$out, %rsi
	call	go
	movl	outptr, %ebx
	movb	%r15b, outbuf+1(,%ebx,1)
	cmpb	$'.', %r15b
	je	end1
	movl	%ebx, outptr
	movq	$in, %rdi
	movq	$out, %rsi
	call	go
	movl	outptr, %ebx
	movb	%r15b, outbuf+2(,%ebx,1)
	cmpb	$'.', %r15b
	je	end2
	cmpl	$60, %ebx
	je	finline
	movb	$' ', outbuf+3(,%ebx,1)
	addl	$4, %ebx
	movl	%ebx, outptr
	jmp	outloop
finline:
	movb	$'\n', outbuf+3(,%ebx,1)
	xorl	%ebx, %ebx
	movl	%ebx, outptr
	jmp	emptybuf
end2:
	incl	%ebx
end1:
	incl	%ebx
end:
	incl	%ebx
	movb	$'\n', outbuf(,%ebx,1)
	incl	%ebx
	movq	$1, %rdi
	movq	$outbuf, %rsi
	movq	%rbx, %rdx
	movq	$SYS_write, %rax
	syscall
	xorq	%rdi, %rdi
	movq	$SYS_exit, %rax
	syscall

ENTRY(go)
	movq	(%rsp), %rbx
	movq	%rbx, (%rsi)
	movq	(%rdi), %rax
	movq	%rax, (%rsp)
	movq	$1, %rax
	ret

ENTRY(coroinit)
	movq	(%rsp), %rax
	movq	%rax, (%rdi)
	xorq	%rax, %rax
	ret

ENTRY(nextchar)
	jmp	start
fillbuf:
	movq	$0, %rdi
	movq	$inbuf, %rsi
	movq	$999, %rdx
	movq	$SYS_read, %rax
	syscall
	movq	$0, inptr
start:
	movl	inptr, %ebx
	movb	inbuf(,%ebx,1), %al
	cmpb	$0, %al
	je	fillbuf
	incl	%ebx
	cmpb	$' ', %al
	je	start
	movl	%ebx, inptr
	ret
