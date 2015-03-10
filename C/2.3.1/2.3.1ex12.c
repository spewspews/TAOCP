#include <u.h>
#include <libc.h>
#include "2.3.1.h"

void
preorder(Tree *p, void (*visit)(Tree *))
{
	int s;

	s = 0;
	if(p == nil)
		return;
	for(;;){
		do{
			visit(p);
			if(s == MAXRECUR)
				exits("Recursion depth exceeded");
			a[s++] = p;
			p = p->left;
		}while(p != nil);
		for(;;){
			p = a[--s];
			p = p->right;
			if(p != nil)
				break;
			if(s == 0)
				return;
		}
	}
}
