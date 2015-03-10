#include <u.h>
#include <libc.h>

void
main(void)
{
	uvlong l;

	while (readn(0, &l, 8)) {
		print("%.16ll#x\n", l);
	}
	exits(0);
}
