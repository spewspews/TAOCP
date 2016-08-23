CFLAGS = -Wall -O2 -g

2.2.3progt: 2.2.3progt.o 2.2.3progtmain.o
	$(CC) -o $@ $^

2.2.4proga: 2.2.4proga.o 2.2.4progamain.o
	$(CC) -o $@ $^

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

clean:
	rm *.o 2.2.3progt 2.2.4proga
