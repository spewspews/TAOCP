CC=armv7l-linux-musleabihf-gcc
LDLIBS=
LDFLAGS=-static

testmain: 2.2.3progt.o 2.2.3progtmain.o

run:
	qemu-arm testmain

clean:
	rm -f *.o testmain

.PHONY: clean run
