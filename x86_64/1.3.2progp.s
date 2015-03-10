/* print the first 500 primes */

#define L	500
#define t	BX
#define n	CX
#define j	R8
#define k	R9
#define pk	R10

GLOBL	x(SB), $(L*2)	/* declare space for array of L primes */
DATA	fmt(SB)/5, $"%ud\n\z"
GLOBL	fmt(SB), $5


TEXT main(SB), $16
	MOVW	$2, x(SB)	/* first prime */
	MOVW	$3, n	/* second prime */
	MOVQ	$1, j
Mtwo:
	MOVW	n, x(SB)(j*2)	/* add new prime to array */
	INCQ	j
Mthree:
	CMPQ	j, $L
	JEQ	end
Mfour:
	ADDW	$2, n	/* next prime candidate */
Mfive:
	MOVQ	$1, k
Msix:
	MOVWLZX	x(SB)(k*2), pk
	MOVWLZX	n, AX
	XORQ	DX, DX
	DIVL	pk	/* divide by prime from array */
	CMPL	DX, $0	/* not prime if no remainder */
	JEQ	Mfour
Mseven:
	CMPL	AX, pk	/* prime if quotient is ≤ to divisor */
	JLE	Mtwo
Meight:
	INCQ	k	/* try dividing by next prime  in array */
	JMP	Msix
end:
	XORQ	j, j
loop:
	PUSHQ	j	/* print all the prime numbers */
	MOVQ	$fmt(SB), RARG
	MOVWLZX	x(SB)(j*2), t
	MOVL	t, 8(SP)
	CALL	print(SB)
	POPQ	j
	INCQ	j
	CMPQ	j, $L
	JEQ	2(PC)
	JMP	loop
	XORQ	RARG, RARG
	CALL	exits(SB)
	RET
	END
