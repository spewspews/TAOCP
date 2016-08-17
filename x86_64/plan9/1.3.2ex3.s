/* reads 100 octabytes into a buffer, sorts them
 * into increasing order and writes them
 * to standard output. Pipe it to printlongs
 * to see a sorted list of the values
 */

#include "/sys/src/libc/9syscall/sys.h"

GLOBL	x(SB), $808

TEXT main(SB), $40
	MOVQ	$0, 8(SP)	/* read 800 values into x */
	MOVQ	$x+8(SB), 16(SP)
	MOVL	$800, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PREAD, RARG
	SYSCALL
	MOVQ	$100, R8
loop:
	PUSHQ	R8
	MOVQ	R8, RARG	/* get max value */
	CALL	maximum(SB)
	POPQ	R8
	MOVQ	x(SB)(R8*8), BX /* swap max value and end value */
	MOVQ	x(SB)(AX*8), CX
	MOVQ	CX, x(SB)(R8*8)
	MOVQ	BX, x(SB)(AX*8)
	DECQ	R8
	CMPQ	R8, $0
	JNE	loop
	MOVQ	$1, 8(SP)	/* print out x */
	MOVQ	$x+8(SB), 16(SP)
	MOVL	$800, 24(SP)
	MOVQ	$-1, 32(SP)
	MOVQ	$PWRITE, RARG
	SYSCALL
	MOVQ	$0, 8(SP)
	MOVQ	$EXITS, RARG
	SYSCALL
	RET
	END
