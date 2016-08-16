count = 0
qlink = 0
top = 4
j = 0
k = 4
suc = 0
next = 4

GLOBL x(SB), $(1000 * 8)

/*
 * RARG (BP) initially set to buffer.
 * BX ≡ AVAIL and P
 * CX ≡ j and R
 * DX ≡ k
 * SI ≡ pool X
 * DI ≡ buffer pointer
 * R8 ≡ F
 */

TEXT topsort(SB), $0
	MOVQ RARG, DI // Store buffer pointer in a register.
	MOVL $x(SB), SI	// Store the memory pool location in a register.
	MOVL n+8(FP), BX
	INCL BX	// Storage starts after X[n].
1(H):
	MOVL j(DI), CX // T2. Next relation.
	CMPL CX, $0
	JEQ 1(F)	// Is j > 0?
	MOVL k(DI), DX	// T3. Record the relation.
	INCL count(SI)(DX*8)	// COUNT[k] + 1 → COUNT[k].
	MOVL top(SI)(CX*8), AX	// TOP[j]
	MOVL AX, next(SI)(BX*8)	// 	→ NEXT(P).
	MOVL DX, suc(SI)(BX*8)	// k → SUC(P).
	MOVL BX, top(SI)(CX*8)	// P → TOP[j].
	INCL BX	// AVAIL ← AVAIL+1.
	ADDQ $8, DI	// Increase buffer pointer.
	JMP 1(B)
1(H):
	MOVL n+8(FP), DX	// T4. Scan for zeros. k ← n
	MOVQ RARG, DI	// Reset buffer pointer for output.
	MOVL $0, CX	// R ← 0.
1(H):
	CMPL count(SI)(DX*8), $0	// Examine COUNT[k].
	JG 3(PC)	// Is it nonzero?
	MOVL DX, qlink(SI)(CX*8)	// QLINK[R] ← k.
	MOVL DX, CX	// R ← k
	DECL DX
	CMPL DX, $0
	JG 1(B)	// n ≥ k ≥ 1
// Sorting phase.
	MOVL qlink(SI), R8	// F ← QLINK[0]
1(H):	// T5. Output front of queue.
	MOVL R8, (DI)	// Store F in buffer area.
	CMPL R8, $0
	JEQ 1(F)	// Is F zero?
	ADDL $4, DI	// Advance buffer pointer.
	MOVL top(SI)(R8*8), BX	// P ← TOP[F]
	CMPL BX, $0
	JEQ 3(F)
2(H):	// T6. Erase relations.
	MOVL suc(SI)(BX*8), DX	// k ← suc(P).
	MOVL count(SI)(DX*8), AX	// COUNT[k]
	DECL AX	//	-1
	MOVL AX, count(SI)(DX*8)	//	→ COUNT[k]
	CMPL AX, $0
	JG 3(PC)	// Has zero been reached?
	MOVL DX, qlink(SI)(CX*8)	// If so, set QLINK[R] ← k
	MOVL DX, CX	// R ← k
	MOVL next(SI)(BX*8), BX	// P ← NEXT(P).
	CMPL BX, $0
	JG 2(B)	// If P ≠ Λ, repeat.
3(H):
	MOVL qlink(SI)(R8*8), R8	// T7. Remove from queue.
	JMP 1(B)	// F ← QLINK(F), goto T5.
1(H):
	MOVQ RARG, AX
	RET
	END
