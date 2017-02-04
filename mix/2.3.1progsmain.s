BUF	EQU	1000
	ORIG	BUF
	ALF	"VALUE"
	ALF	" IS  "

HEAD	EQU	ENDP+2

	ORIG	3500
MAIN	ENNA	HEAD
	STA	HEAD(0:2)
	ENN4	ENDP-POOL
1H	ENT1	ENDP,4
	JMP	INSBT
	INC4	2
	J4NP	1B
	JMP	S0

VISIT	STJ	1F
	LDA	0,5(3:5)
	CHAR
	STA	BUF+2
	STX	BUF+3
	OUT	BUF(19)
1H	JMP	*

* Insertion into binary tree at HEAD
* ri1 points to the node to insert.
LLINKT	EQU	0:2
RLINKT	EQU	0:2
INSBT	STJ	2F
	LDA	0,1(3:5)
	ENT2	HEAD		# P ← HEAD
	JMP	LESS
1H	ENT2	0,3		# P ← Q
	CMPA	0,2(3:5)
	JL	LESS		# N < P
	JG	GREATER		# N > P
2H	JMP	*
LESS	LD3	0,2(LLINKT)	# Q ← LLINKT(P)
	J3P	1B		# Jump if LTAG(P) == 0
	ST1	0,2(LLINKT)	# LLINKT(P) ← N
	ST3	0,1(LLINKT)	# LLINKT(N) ← Q
	ENN2	0,2
	ST2	1,1(RLINKT)	# RLINKT(N) ← P
	JMP	2B		# Return
GREATER	LD3	1,2(RLINKT)
	J3P	1B
	ST1	1,2(RLINKT)
	ST3	1,1(RLINKT)
	ENN2	0,2
	ST2	0,1(LLINKT)
	JMP	2B
