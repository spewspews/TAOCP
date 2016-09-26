CFLAGS = -std=c99 -Wall -Wpedantic -Wextra -O2 -g
LDLIBS = -lfmt -lutf

2.2.3progt: 2.2.3progt.o 2.2.3progtmain.o
	$(CC) -o $@ $^

2.2.4proga: 2.2.4proga.o 2.2.4progamain.o
	$(CC) -o $@ $^

2.2.6progs: 2.2.6progs.o 2.2.6progsmain.o
	$(CC) -o $@ $^ $(LDLIBS)

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm -f *.o 2.2.3progt 2.2.4proga 2.2.6progs
