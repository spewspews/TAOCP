BUF	EQU	1000
	ORIG	BUF
	ALF	"VALUE"
	ALF	" IS  "

HEAD	EQU	POOLEND+2

	ORIG	3500
MAIN	ENNA	HEAD
	STA	HEAD(0:2)
	ENT4	POOLEND-POOL
LOOPM	ENT1	POOL,4
	JMP	INSBT
	DEC4	2
	J4NN	LOOPM
	JMP	S0

VISIT	STJ	EXITV
	LDA	0,5(3:5)
	CHAR
	STA	BUF+2
	STX	BUF+3
	OUT	BUF(19)
EXITV	JMP	*

# Insertion into binary tree at HEAD
# ri1 points to the node to insert.
LLINKT	EQU	0:2
RLINKT	EQU	0:2
INSBT	STJ	EXITINS
	LDA	0,1(3:5)
	ENT2	HEAD		# P ← HEAD
	JMP	LESS
LOOPI	ENT2	0,3		# P ← Q
	CMPA	0,2(3:5)
	JL	LESS		# N < P
	JG	GREATER		# N > P
EXITINS	JMP	*
LESS	LD3	0,2(LLINKT)	# Q ← LLINKT(P)
	J3P	LOOPI		# Jump if LTAG(P) == 0
	ST1	0,2(LLINKT)	# LLINKT(P) ← N
	ST3	0,1(LLINKT)	# LLINKT(N) ← Q
	ENN2	0,2
	ST2	1,1(RLINKT)	# RLINKT(N) ← P
	JMP	EXITINS		# Return
GREATER	LD3	1,2(RLINKT)
	J3P	LOOPI
	ST1	1,2(RLINKT)
	ST3	1,1(RLINKT)
	ENN2	0,2
	ST2	0,1(LLINKT)
	JMP	EXITINS
