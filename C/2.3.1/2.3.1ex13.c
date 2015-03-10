#include <u.h>
#include <libc.h>
#include "2.3.1.h"

void
postorder(Tree* p, void (*visit)(Tree *))
{
	Tree* q;
	int s;

	q = nil;
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
			if(p->right == nil || p->right == q){
				visit(p);
				q = p;
			}else{
				if(s == MAXRECUR)
					exits("Recursion depth exceeded");
				a[s++] = p;
				p = p->right;
				break;
			}
			if(s == 0)
				return;
		}
	}
}
