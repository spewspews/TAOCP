#include <sys/types.h>
#include <stdlib.h>
#include <stdio.h>

int64_t x[] = { 0, 7, 5000, 7, 2893, 4, 304 };

int64_t maximum(int64_t);

int
main(void)
{
	int64_t m;

	m = maximum(sizeof(x)/sizeof(int64_t) - 1);
	printf("%lld %lld\n", m, x[m]);
	exit(0);
}
