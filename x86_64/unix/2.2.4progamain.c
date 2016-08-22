#include <stdlib.h>
#include <stdio.h>

typedef struct Poly Poly;

struct Poly {
	int32_t coef;
	int32_t abc;
	Poly *link;
};

int	add(Poly *q, Poly *p);

Poly *avail;

int
main(int argc, char **argv)
{
	Poly *pool, *p;

	pool = calloc(500, sizeof(*pool));
	for(p = pool; p < pool+499; p++)
		p->link = p+1;
	p->link = NULL;
	avail = pool;

	exit(0);
}
