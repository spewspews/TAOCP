#include <stdio.h>
#include <stdlib.h>

int *topsort(int*, int);
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
main(int argc, char **argv)
{
	int *ret, *i;

	ret = topsort(arr, 9);
	for(i = ret; *i != 0; i++)
		printf("%d ", *i);
	printf("\n");
	exit(0);
}
