Knuth's TAOCP
=============

I am currently reading Knuth’s _TAOCP_ and implementing the programs and
exercises in C and x86-64 assembly.  I may add some other languages
(possibly Go, Python, or ARM assembly).

Caveat:
-------
The x86-64 assembly is written for the [Plan 9
assembler](http://doc.cat-v.org/plan_9/4th_edition/papers/asm) and the
Plan 9 calling convention. However, this assembler does not support 
local symbols as described in _TAOCP_ §1.3.2. So in order to assemble these
on Plan 9, you'll need to download or patch [6a](http://man.cat-v.org/9front/1/2a) with the extension I wrote
[here](http://www.codigo.co/code/C/local_labels/).

The C programs are written for the Plan 9 compiler and libraries. They
are not difficult to port to Unix. For more information on the differences
see [this paper](http://doc.cat-v.org/plan_9/4th_edition/papers/comp).

I am also maintaining unix versions of the assembly code so find those in the Unix
[subdirectory](http://www.codigo.co/code/Knuth/x86_64/unix/).
