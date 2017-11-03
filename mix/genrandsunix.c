#include <stdio.h>
#include <stdlib.h>
#include <time.h>

enum {
	MAX = (1 << 6*3) - 1
};

int
main(int argc, char **argv)
{
	int i, n;

	if(argc != 2) n = 100;
	else          n = strtol(argv[1], NULL, 10);

	printf("POOL\tEQU\t1\n\tORIG\tPOOL\n");

	srand48(time(NULL));
	for(i = 0; i < n-1; i++) {
		printf("\tCON\t%d(3:5)\n", (int)(drand48()*MAX));
		printf("\tCON\t0(3:5)\n");
	}
	printf("ENDP\tCON\t%d(3:5)\n", (int)(drand48()*MAX));
	printf("\tCON\t0(3:5)\n");

	exit(0);
}
