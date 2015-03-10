/* x(SB) is a global address of the array in the data section */

#define j	AX
#define m	BX
#define xk	DX

TEXT maximum(SB), $0
	MOVQ	RARG, j
	MOVQ	RARG, CX
	MOVQ	x(SB)(CX*8), m
	LOOP	Loop
Loop:
	MOVQ	x(SB)(CX*8), xk
	CMPQ	xk, m
	JLE	3(PC)
	MOVQ	xk, m
	MOVQ	CX, j
	LOOP	Loop
	RET
	END
