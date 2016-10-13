	.global topsort
	.equ count, 0
	.equ qlink, 0
	.equ top, 4
	.equ j, 0
	.equ k, 4
	.equ suc, 0
	.equ next, 4

	.bss
	.align 2
x:
	.space 1024*8

/*
 * r0 = initially set to buffer.
 * r1 = AVAIL and P
 * r2 = k
 * r3 = buffer pointer
 * r4 = j and R
 * r5 = F
 * r6 = n
 * r7 = Holds the base address of the memory pool.
 */

	.text
	.align 2
topsort:
	push {r4-r7}
	mov	r3, r0	// Store buffer pointer.
