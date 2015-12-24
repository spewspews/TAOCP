Knuth's TAOCP
=============

I am currently reading Knuth’s
[TAOCP](http://www-cs-faculty.stanford.edu/~uno/taocp.html) and
implementing the programs and exercises using x86-64 assembly instead
of MIX or [MMIX](http://mmix.cs.hm.edu/).

Caveat:
-------
The assembly and C is written for the [Plan 9
Operating System](http://plan9.bell-labs.com/plan9/). I use the [9front](http://www.9front.org/) fork. I have made a couple modifications to the assembler
to make assembly programming slightly easier. Ask me if you want those
changes (you will need them if you want to assemble these programs).

The following are the legal addressing modes in the x86 Plan 9
assembler. Capital words refer to register names and lowercase words
refer to constants.

```
	(BASE)
	offset(BASE)
	(BASE)(INDEX)
	(BASE)(INDEX*scale)
	offset(BASE)(INDEX)
	offset(BASE)(INDEX*scale)
```

I have a few unix versions of the assembly code in the unix
[subdirectory](http://www.codigo.co/code/Knuth/x86_64/unix/) for
comparison. The GCC assembler will assemble those.
