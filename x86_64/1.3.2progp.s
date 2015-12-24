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
0(H):
	MOVW	n, x(SB)(j*2)	/* add new prime to array */
	INCQ	j
	CMPQ	j, $L
	JEQ	0(F)
1(H):
	ADDW	$2, n	/* next prime candidate */
	MOVQ	$1, k
2(H):
	MOVWLZX	x(SB)(k*2), pk
	MOVWLZX	n, AX
	XORQ	DX, DX
	DIVL	pk	/* divide by prime from array */
	CMPL	DX, $0	/* not prime if no remainder */
	JEQ	1(B)
	CMPL	AX, pk	/* prime if quotient is ≤ to divisor */
	JLE	0(B)
	INCQ	k	/* try dividing by next prime  in array */
	JMP	2(B)
0(H):
	XORQ	j, j
0(H):
	PUSHQ	j	/* print all the prime numbers */
	MOVQ	$fmt(SB), RARG
	MOVWLZX	x(SB)(j*2), t
	MOVL	t, 8(SP)
	CALL	print(SB)
	POPQ	j
	INCQ	j
	CMPQ	j, $L
	JEQ	2(PC)
	JMP	0(B)
	XORQ	RARG, RARG
	CALL	exits(SB)
	RET
	END
