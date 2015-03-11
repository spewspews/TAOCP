/* 1st argument RARG is the location of the array of bytes of permuted elements.
 * 2nd argument 8(FP) is the number of elements n.
 * m is CX for easy looping.
 * j is SI.
 * i is DI.
 */

#define m	CX
#define j	SI
#define i	DI

TEXT	invert(SB), $0
	MOVL	n+8(FP), m		// 1	I1. Initialize. m←n
	MOVQ	$-1, j			// 1	j←-1
2(H):	MOVBQZX	-1(RARG)(m*1), i	// N	I2. Next Element. i←X[m-1]
	CMPB	i, $0			// N
	JL	5(F)			// N	To I5 if i < 0
3(H):	MOVB	j, -1(RARG)(m*1)	// N	I3. Invert one X[m-1]←j
	MOVQ	m, j			// N
	NEGQ	j			// N	j←-m
	MOVQ	i, m			// N	m←i
	MOVBQZX	-1(RARG)(m*1), i	// N	i←X[m-1]
4(H):	CMPB	i, $0			// N	I4. End of cycle?
	JG	3(B)			// N	To I3 if i>0
	MOVB	j, i			// N	Otherwise set i←j
5(H):	MOVB	i, -1(RARG)(m*1)	// N	I5. Store final value.
	NEGB	-1(RARG)(m*1)
	LOOP	2(B)
	RET
