#include <u.h>
#include <libc.h>

vlong x[] = { 9999999, -320983, -6, 2093, 437, -18 };

vlong maximum(vlong);

void
main(void)
{
	int m;

	m = maximum(sizeof(x)/sizeof(vlong) - 1);
	print("%d, %d\n", m, x[m]);
	exits(0);
}
