#include <stdint.h>
#include <stdlib.h>
#include "2.2.4proga.h"

int
add(Poly *q, Poly *p)
{
	Poly *q1, *q2;

	q1 = q;
	q = q->link;
	p = p->link;

	for(;;) {
		if(q->abc > p->abc) {
			q1 = q;
			q = q->link;
			continue;
		}
	
		if(q->abc == p->abc) {
			if(q->abc == -1)
				return 0;
			q->coef += p->coef;
			if(q->coef != 0) {
				q1 = q;
				q = q->link;
				p = p->link;
				continue;
			}
			q2 = q;
			q1->link = q = q->link;
			q2->link = avail;
			avail = q2;
			p = p->link;
			continue;
		}
	
		if(avail == NULL)
			return -1;
		q2 = avail;
		avail = avail->link;
		q2->abc = p->abc;
		q2->coef = p->coef;
		q2->link = q;
		q1->link = q2;
		q1 = q2;
		p = p->link;
	}
}
