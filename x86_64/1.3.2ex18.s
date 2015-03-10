/* RARG is address of array,
 * 8(FP) is number of rows
 * 16(FP) is number of columns
 *
 * This is Exercise 18 from section
 * 1.3.2 implemented with the further
 * suggestion Knuth makes.
 *
 * See saddlemain.c for how to call this
 * function.
 */

#define	i	R8
#define minmax	R9
#define	maxmin	R10
#define	si	R11
#define	sj	R12

DATA	fmt(SB)/8,	$"Saddle p"
DATA	fmt+8(SB)/8,	$"oint at "
DATA	fmt+16(SB)/8,	$"row %d, "
DATA	fmt+24(SB)/7,	$"col %d\n"
GLOBL	fmt(SB), $32
GLOBL	rmin(SB), $1000
GLOBL	cmax(SB), $1000

TEXT	saddle(SB), $0
	MOVL	r+8(FP), AX
	MULL	c+16(FP)
	DECL	AX			/* index of last element of array */
	MOVL	r+8(FP), i
Rowloop:
	MOVB	(RARG)(AX*1), BX	/* BX is a[c*i + (c - 1)] */
	MOVB	BX, rmin-1(SB)(i*1)
	MOVL	c+16(FP), CX
Colloop:
	MOVB	(RARG)(AX*1), BX	/* BX is a[i*c + j] */
	CMPB	BX, rmin-1(SB)(i*1)
	JGE	2(PC)
	MOVB	BX, rmin-1(SB)(i*1)
	CMPB	BX, cmax-1(SB)(CX*1)
	JLE	2(PC)
	MOVB	BX, cmax-1(SB)(CX*1)
	DECL	AX
	LOOP	Colloop
	DECL	i
	CMPL	i, $0
	JG	Rowloop

	MOVB	rmin(SB), maxmin
	MOVL	$0, si
	MOVL	r+8(FP), CX
	DECL	CX
Getmaxmin:
	CMPB	maxmin, rmin(SB)(CX*1)
	JGE	3(PC)
	MOVB	rmin(SB)(CX*1), maxmin
	MOVL	CX, si
	LOOP	Getmaxmin

	MOVB	cmax(SB), minmax
	MOVL	$0, sj
	MOVL	c+16(FP), CX
	DECL	CX
Getminmax:
	CMPB	minmax, cmax(SB)(CX*1)
	JLE	3(PC)
	MOVB	cmax(SB)(CX*1), minmax
	MOVL	CX, sj
	LOOP	Getminmax

	CMPB	minmax, maxmin
	JNE	Return
	MOVL	si, AX
	MULL	c+16(FP)
	ADDL	sj, AX
	LEAQ	(RARG)(AX*1), AX
	JMP	2(PC)
Return:
	MOVB	$0, AX
	RET
