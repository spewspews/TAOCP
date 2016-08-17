#include <u.h>
#include <libc.h>

char a[] = {
	3, 4, 1, 1, 5,
	4, 5, 13, 2, 3,
	13, 8, 7, 5, 10,
	35, 10, -3, 4, 2,
	18, 2, 1, -5, 3,
	10, 1, 9, -1, 5,
	1, 13, 4, -3, 7
};	

char *saddle(char *, int, int);

void
main(void)
{
	char	*sp;
	uintptr	 l;
	int	 i, j;

	if(sp = saddle(a, 7, 5)){
		print("saddle point value: %d\n", *sp);
		l = (uintptr)sp - (uintptr)a;
		i = l / 5;	/* 5 is the number of columns */
		j = l % 5;
		print("saddle point location: %d, %d\n", i, j);
	}
	else
		print("no saddle point");
	exits(0);
}
