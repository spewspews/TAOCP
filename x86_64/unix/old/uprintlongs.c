#include <stdlib.h>
#include <stdio.h>

int
main(void)
{
	int64_t l;

	while (read(0, &l, 8))
		printf("%lld\n", l);
	exit(0);
}
