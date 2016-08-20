CFLAGS = -Wall -g

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

.S.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm *.o 2.2.3progt progm
