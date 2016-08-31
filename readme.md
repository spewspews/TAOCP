Knuth's TAOCP
=============

I am currently reading Knuth’s
[TAOCP](http://www-cs-faculty.stanford.edu/~uno/taocp.html) and
implementing the programs and programming exercises in various languages.
Right now only x86_64 assembly being called from C. Some of the programs
are implemented for Plan 9 and it has its own assembler syntax. The
addressing modes are below: Capital words refer to register names and lowercase words
refer to constants.

```
	(BASE)
	offset(BASE)
	(BASE)(INDEX)
	(BASE)(INDEX*scale)
	offset(BASE)(INDEX)
	offset(BASE)(INDEX*scale)
```

I am not continuing the Plan 9 version so the most recent stuff
is in the Unix directory. I want to start ARM assembly implementations
soon. Stay tuned!
