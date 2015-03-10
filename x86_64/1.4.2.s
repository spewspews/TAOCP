/*
 * Knuth's coroutine from §1.4.2
 * Register R15 is used for passing
 * values between the two coroutines
 */

#include "/sys/src/libc/9syscall/sys.h"

GLOBL	in(SB), $8
GLOBL	out(SB), $8
GLOBL	inbuf(SB), $1000
GLOBL	outbuf(SB), $64
GLOBL	inptr(SB), $4
GLOBL	outptr(SB), $4
GLOBL	i(SB), $1

TEXT	main(SB), $40
	/*
	 * coroinit returns twice: 0 initially
	 * and 1 when jumped to from a call to
	 * go.
	 */
	MOVQ	$in(SB), RARG
	CALL	coroinit(SB)
	CMPQ	AX, $1
	JEQ	in1
	JMP	out1
/* first coroutine */
callout:
	MOVQ	out(SB), RARG
	MOVQ	$in(SB), 8(SP)
	CALL	go(SB)
in1:
	CALL	nextchar(SB)
	MOVB	AX, R15
	CMPB	AX, $'9'
	JG	callout
	SUBB	$'0', AX
	CMPB	AX, $0
	JL	callout
	MOVB	AX, i(SB)
	CALL	nextchar(SB)
	MOVB	AX, R15
inloop:
	MOVQ	out(SB), RARG
	MOVQ	$in(SB), 8(SP)
	CALL	go(SB)
	MOVB	i(SB), AX
	DECB	AX
	MOVB	AX, i(SB)
	CMPB	AX, $0
	JGE	inloop
	JMP	in1
/* second coroutine */
emptybuf:
	MOVQ	$1, 8(SP)
	MOVQ	$outbuf(SB), 16(SP)
	MOVQ	$64, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG
	SYSCALL
out1:
	MOVL	$0, outptr(SB)
outloop:
	MOVQ	in(SB), RARG
	MOVQ	$out(SB), 8(SP)
	CALL	go(SB)
	MOVL	outptr(SB), BX
	MOVB	R15, outbuf(SB)(BX*1)
	CMPB	R15, $'.'
	JEQ	end
	MOVL	BX, outptr(SB)
	MOVQ	in(SB), RARG
	MOVQ	$out(SB), 8(SP)
	CALL	go(SB)
	MOVL	outptr(SB), BX
	MOVB	R15, outbuf+1(SB)(BX*1)
	CMPB	R15, $'.'
	JEQ	end1
	MOVL	BX, outptr(SB)
	MOVQ	in(SB), RARG
	MOVQ	$out(SB), 8(SP)
	CALL	go(SB)
	MOVL	outptr(SB), BX
	MOVB	R15, outbuf+2(SB)(BX*1)
	CMPB	R15, $'.'
	JEQ	end2
	CMPL	BX, $60
	JEQ	finline
	MOVB	$' ', outbuf+3(SB)(BX*1)
	ADDL	$4, BX
	MOVL	BX, outptr(SB)
	JMP	outloop
finline:
	MOVB	$'\n', outbuf+3(SB)(BX*1)
	XORL	BX, BX
	MOVL	BX, outptr(SB)
	JMP	emptybuf
end2:
	INCL	BX
end1:
	INCL	BX
end:
	INCL	BX
	MOVB	$'\n', outbuf(SB)(BX*1)
	INCL	BX
	MOVQ	$1, 8(SP)
	MOVQ	$outbuf(SB), 16(SP)
	MOVQ	BX, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG
	SYSCALL
	MOVQ	$0, 8(SP)
	MOVQ	$EXITS, RARG
	SYSCALL

TEXT	go(SB), $0
	MOVQ	instrptr+8(FP), AX
	MOVQ	(SP), BX
	MOVQ	BX, (AX)
	MOVQ	RARG, (SP)
	MOVQ	$1, AX
	RET

TEXT	coroinit(SB), $0
	MOVQ	(SP), AX
	MOVQ	AX, (RARG)
	XORQ	AX, AX
	RET

TEXT	nextchar(SB), $40
	JMP	start
fillbuf:
	MOVQ	$0, 8(SP)
	MOVQ	$inbuf(SB), 16(SP)
	MOVQ	$999, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PREAD, RARG
	SYSCALL
	MOVQ	$0, inptr(SB)
start:
	MOVL	inptr(SB), BX
	MOVB	inbuf(SB)(BX*1), AX
	CMPB	AX, $0
	JEQ	fillbuf
	INCL	BX
	CMPB	AX, $' '
	JEQ	start
	MOVL	BX, inptr(SB)
	RET
