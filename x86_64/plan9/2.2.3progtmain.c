#include <u.h>
#include <libc.h>

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

void
main(int, char**)
{
	int *ret, *i;

	ret = topsort(arr, 9);
	for(i = ret; *i != 0; i++)
		print("%d ", *i);
	print("\n");
	exits(0);
}
