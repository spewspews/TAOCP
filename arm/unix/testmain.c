#include <stdio.h>
#include <stdlib.h>

int topsort(int*, int);
int arr[] = {
	9, 2,
	3, 7,
	7, 5,
	5, 8,
	8, 6,
	4, 6,
	1, 3,
	7, 4,
	9, 5,
	2, 8,
	0
};

int
main(void)
{
	int i;

	i = topsort(arr, 9);
	printf("got %d\n", i);
	exit(0);
}
