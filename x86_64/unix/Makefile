CFLAGS = -Wall -Wextra -g
LDADD = -lfmt -lutf

1.4.2: u1.4.2.o
	$(CC) -static -o 1.4.2 $^

1.3.2ex3: u1.3.2ex3.o uprogm.o
	$(CC) -o $@ $^

progm: umainprogm.o uprogm.o
	$(CC) -o $@ $^

progp: uprogp.S
	$(CC) uprogp.S
	mv a.out progp

2.2.3progt: 2.2.3progt.o 2.2.3progtmain.o
	$(CC) -o $@ $^

2.2.4proga:	2.2.4proga.o 2.2.4progamain.o
	$(CC) -o $@ $^

2.2.6progs:	2.2.6progsmain.o 2.2.6progs.o
	$(CC) -o $@ $^ $(LDADD)

.S.o:
	$(CC) -g -c -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o 2.2.3progt progm 2.2.4proga 2.2.6progs
