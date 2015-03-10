#include <u.h>
#include <libc.h>
#include "2.3.1.h"

void
inorder(Tree *p, void (*visit)(Tree *))
{
	int s;

	s = 0;
	if(p == nil)
		return;
	for(;;){
		do{
			if(s == MAXRECUR)
				exits("Recursion depth exceeded");
			a[s++] = p;
			p = p->left;
		}while(p != nil);
		for(;;){
			p = a[--s];
			visit(p);
			p = p->right;
			if(p != nil)
				break;
			if(s == 0)
				return;
		}
	}
}
