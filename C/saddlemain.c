#include <u.h>
#include <libc.h>

char a[] = {
	3, 4, 1, 1, 5,
	4, 5, 2, 2, 3,
	5, 8, 15, 5, 10,
	7, 10, 20, 4, 2
};	

char saddle(char *, int, int);

void
main(void)
{
	char s;

	s = saddle(a, 4, 5);
	print("saddle point value: %d\n", s);
	exits(0);
}
