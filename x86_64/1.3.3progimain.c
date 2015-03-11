#include <u.h>
#include <libc.h>

void invert(char*, int);

void
main(void)
{
	int i;
	char a[] = { 3, 2, 5, 1, 4 };

	invert(a, sizeof(a));
	for(i = 0; i < sizeof(a); i++){
		print("%d ", a[i]);
	}
	print("\n");
	exits(0);
}
