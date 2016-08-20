/*
 * Program T.
 * C prototype: int *topsort(int *rel, int maxn)
 * returns sorted array of ints with 0 as sentinel
 */

count = 0
top = 4
j = 0
k = 4
suc = 0
next = 4

#define I AX
#define COUNT CX
#define TOP DX
#define SUC CX
#define NEXT DX
#define QLINK CX
#define AVAIL SI
#define J DI
#define K R8
#define P R9
#define REAR R10
#define FRONT R11
#define S R12
#define T R13

GLOBL pool(SB), $(1000 * 8)

TEXT topsort(SB), $40
	MOVQ RARG, I
	MOVL $1, AVAIL
	MOVL n+8(FP), T
	ADDL T, AVAIL
	INCL AVAIL         /* Allocate space for QLINK[0] and N COUNT and TOP fields */
	SHLL $3, AVAIL
	MOVQ $pool+count(SB), COUNT
	MOVQ $pool+top(SB), TOP
	JMP T2
T3:
	SHLL $3, K
	SHLL $3, J
	MOVL (COUNT)(K), T
	INCL T
	MOVL T, (COUNT)(K)     /* Increment the successor */
	MOVL AVAIL, P          /* Allocate successor node */
	ADDL $8, AVAIL
	MOVL K, (SUC)(P)
	MOVL (TOP)(J), T
	MOVL T, (NEXT)(P)
	MOVL P, (TOP)(J)       /* Add to predecessor list */
T2:
	MOVL j(I), J
	MOVL k(I), K
	ADDQ $8, I
	CMPL J, $0
	JG T3
T4:
	MOVQ $0, REAR
	MOVL n+8(FP), K
	SHLL $3, K
1(H):
	MOVL (COUNT)(K), T
	CMPL T, $0
	JNE 0(F)
	MOVL K, (QLINK)(REAR)
	MOVL K, REAR
0(H):
	SUBL $8, K
	CMPQ K, $0
	JG 1(B)
	MOVL (QLINK), FRONT
	MOVQ RARG, I        /* buffer start, use input buffer for return buffer */
	JMP T5
T5B:
	MOVL (TOP)(FRONT), P
	CMPL P, $0
	JE T7
T6:
	MOVL (SUC)(P), S
	MOVL (COUNT)(S), T
	DECL T
	MOVL T, (COUNT)(S)
	CMPL T, $0
	JNE 0(F)
	MOVL S, (QLINK)(REAR)
	MOVL S, REAR
0(H):
	MOVL (NEXT)(P), P
	CMPL P, $0
	JNE T6
T7:
	MOVL (QLINK)(FRONT), FRONT
T5:
	MOVL FRONT, (I)
	SHRL $3, (I)
	ADDQ $4, I
	CMPL FRONT, $0
	JNE T5B
	MOVQ RARG, AX
	RET
	END
