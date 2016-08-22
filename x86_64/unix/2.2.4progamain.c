#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

typedef struct Poly Poly;

struct Poly {
	int32_t coef;
	int32_t abc;
	Poly *link;
};

int	add(Poly *q, Poly *p);

Poly *avail;

Poly*
makepoly(void)
{
	Poly *p;

	if(avail == NULL)
		return NULL;
	p = avail;
	avail = avail->link;
	p->abc = -1;
	p->coef = 0;
	p->link = p;
	return p;
}

int
addterm(Poly *p, int32_t coef, unsigned char a, unsigned char b, unsigned char c)
{
	Poly *q, *r;
	int32_t abc;

	abc = (a << 16) + (b << 8) + c;

	for(r = p->link; abc < r->abc; r = p->link)
		p = r;

	if(abc == r->abc) {
		r->coef += coef;
		return 0;
	}

	if(avail == NULL)
		return -1;
	q = avail;
	avail = avail->link;

	q->coef = coef;
	q->abc = abc;
	q->link = r;

	p->link = q;
	return 0;
}

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
