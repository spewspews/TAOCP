#include <stdlib.h>
#include <stdio.h>

char a[] = {
	3, 4, 1, 1, 5,
	4, 5, 2, 8, 3,
	5, 8, 1, 5, 10,
	35, 10, -3, 4, 2
};	

char saddle(char *, int, int);

int
main(void)
{
	char s;

	s = saddle(a, 4, 5);
	printf("saddle point value: %d\n", s);
	exit(0);
}
