Knuth's TAOCP
=============

As I read Knuth’s
[TAOCP](http://www-cs-faculty.stanford.edu/~uno/taocp.html) I am
implementing the programs and programming exercises in C, x86_64 assembly
and arm assembly.  Some of the programs
are implemented for Plan 9 x86_64 which has its own assembler syntax. The
addressing modes are below: Capital words refer to register names
and lowercase words refer to constants.

```
	(BASE)
	offset(BASE)
	(BASE)(INDEX)
	(BASE)(INDEX*scale)
	offset(BASE)(INDEX)
	offset(BASE)(INDEX*scale)
```

I am not continuing the Plan 9 version so the most recent stuff
is in the Unix directory.
