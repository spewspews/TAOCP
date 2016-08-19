	.global topsort

	.equ count, 0
	.equ qlink, 0
	.equ top, 4
	.equ j, 0
	.equ k, 4
	.equ suc, 0
	.equ next, 4

	.data
x:
	.space 1024*8

/*
 * %rdi = initially set to buffer.
 * %esi = AVAIL and P
 * %edx = k
 * %ecx = j and R
 * %rbx = pool X
 * %r8 = buffer pointer
 * %r9d = F
 * %r10d = n
 */

	.text
topsort:
	movq	%rdi,	%r8	// Store buffer pointer in a register.
	movq	$x,	%rbx	// Store the memory pool location in a register.
	movl	%esi,	%r10d	// Store n in a register
	incl	%esi	// Storage starts after X[n].
1:
	movl	j(%r8),	%ecx	// T2. Next relation.
	cmpl	$0,	%ecx
	je	1f	// Is j > 0 ?
	movl	k(%r8),	%edx	// T3. Record the relation.
	incl	count(%rbx,%rdx,8)	// COUNT[k] + 1 -> COUNT[k]
	movl	top(%rbx,%rcx,8),	%eax	// TOP[j]
	movl	%eax,	next(%rbx,%rsi,8)	// 	-> NEXT(P).
	movl	%edx,	suc(%rbx,%rsi,8)	// k -> SUC(P)
	movl	%esi,	top(%rbx,%rcx,8)	// P -> TOP[j]
	incl	%esi	// AVAIL <- AVAIL+1
	addq	$8,	%r8
	jmp	1b
1:
	movl	%r10d,	%edx	// T4. Scan for zeroes. k <- n.
	movq	%rdi,	%r8	// Reset buffer pointer for output.
	movl	$0,	%ecx	// R <- 0
1:
	cmpl	$0,	count(%rbx,%rdx,8)	// Examine COUNT[k]
	jg	2f	// Is it nonzero?
	movl	%edx,	qlink(%rbx,%rcx,8) // QLINK[R] <- k
	movl	%edx,	%ecx	// R <- k
2:
	decl	%edx
	cmpl	$0,	%edx
	jg	1b	// n >= k >= 1
// Sorting Phase
	movl	qlink(%rbx),	%r9d	// F <- QLINK[0]
1:	// T5. Output front of queue.
	movl	%r9d,	(%r8)	// Store F in buffer area.
	cmpl	$0,	%r9d
	je	1f	// Is F zero?
	addl	$4,	%r8d	// Advance buffer pointer.
	movl	top(%rbx,%r9,8),	%esi	// P <- TOP[F]
	cmpl	$0,	%esi
	je	4f
2:	// T6. Erase relations.
	movl	suc(%rbx,%rsi,8),	%edx	// k <- suc(P)
	movl	count(%rbx,%rdx,8),	%eax	// COUNT[K]
	decl	%eax	// 	- 1
	movl	%eax,	count(%rbx,%rdx,8)	// COUNT[K]
	cmpl	$0,	%eax
	jg	3f	// Has zero been reached?
	movl	%edx,	qlink(%rbx,%rcx,8)	// If so, set QLINK[R] <- k
	movl	%edx,	%ecx	// R <- k
3:
	movl	next(%rbx,%rsi,8),	%esi	// P <- NEXT(P)
	cmpl	$0,	%esi
	jg	2b	// If P != NULL, repeat.
4:	// T7. Remove from queue.
	movl	qlink(%rbx,%r9,8),	%r9d	// F <- QLINK(F)
	jmp	1b	// goto T5.
1:
	movq	%rdi,	%rax
	ret
