LLINKT EQU 0:2
RLINKT EQU 0:2

     ORIG 2000
*  PREORDER SUCCESSOR
P0   STJ  2F
     LD6  0,5(LLINKT)
     J6NN 1F
P1   LD5N 1,5(RLINKT)
     J5NN P1
     ENN6 0,5
1H   ENT5 0,6
2H   JMP *

*  SYMMETRIC SUCCESSOR
S0   STJ  1F
     LD5N 1,5(RLINKT)
     J5NN 1F
     ENN6 0,5
S2   ENT5 0,6
     LD6  0,5(LLINKT)
     J6NN S2
1H   JMP *

     ORIG 100
A    ALF  "    A"
     ALF  "     "
B    ALF  "    B"
     ALF  "     "
C    ALF  "    C"
     ALF  "     "
D    ALF  "    D"
     ALF  "     "
E    ALF  "    E"
     ALF  "     "
F    ALF  "    F"
     ALF  "     "
G    ALF  "    G"
     ALF  "     "
H    ALF  "    H"
     ALF  "     "
J    ALF  "    J"
     ALF  "     "
HEAD CON  0
     CON  0

     ORIG 500
PRE  ALF  "  PRE"

     ORIG 524
SYM  ALF  "  SYM"

     ORIG 3000
MAIN ENTA A    # Link everything up.
     STA  HEAD(0:2)
     ENTA HEAD
     STA  HEAD+1(0:2)

     ENTA B
     STA  A(0:2)
     ENTA C
     STA  A+1(0:2)

     ENTA D
     STA  B(0:2)
     ENNA A
     STA  B+1(0:2)

     ENTA E
     STA  C(0:2)
     ENTA F
     STA  C+1(0:2)

     ENNA HEAD
     STA  D(0:2)
     ENNA B
     STA  D+1(0:2)

     ENNA A
     STA  E(0:2)
     ENTA G
     STA  E+1(0:2)

     ENTA H
     STA  F(0:2)
     ENTA J
     STA  F+1(0:2)

     ENNA E
     STA  G(0:2)
     ENNA C
     STA  G+1(0:2)

     ENNA C
     STA  H(0:2)
     ENNA F
     STA  H+1(0:2)

     ENNA F
     STA  J(0:2)
     ENNA HEAD
     STA  J+1(0:2)

     ENT1 PRE+1
     ENT5 HEAD
1H   JMP  P0   # Preorder traversal
     ENT6 -HEAD,5
     J6Z  1F
     LDA  0,5(3:5)
     STA  0,1(3:5)
     INC1 1
     JMP  1B

1H   ENT1 SYM+1
     ENT5 HEAD
1H   JMP  S0   # Symmetric traversal
     ENT6 -HEAD,5
     J6Z  1F
     LDA  0,5(3:5)
     STA  0,1(3:5)
     INC1 1
     JMP  1B

1H   OUT  PRE(18)
     OUT  SYM(18)
     HLT     
     END  MAIN
