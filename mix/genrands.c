#include <u.h>
#include <libc.h>

enum {
	MAX = 1<<(6*3) - 1
};

void
main(int argc, char **argv)
{
	int i, n;

	if(argc != 2)
		n = 100;
	else
		n = strtol(argv[1], nil, 10);

	srand(time(nil));
	for(i = 0; i < n; i++) {
		print("\tCON\t%ld(3:5)\n", lnrand(MAX));
		print("\tCON\t0(3:5)\n");
	}
	exits(nil);
}
