#include <u.h>
#include <libc.h>

enum{ MAXRECUR = 1000 };

typedef struct Node Node;

struct Node
{
	Node *left, *right;
};

#define push(p)	\
	if(sp == ep)	\
		exits("Stack overflow");	\
	else	\
		*sp++ = (p)
#define pop(p) (p) = *--sp

void
inorder(Node *p, void(*visit)(Node*))
{
	static Node *a[MAXRECUR], **sp, **ep;

	sp = a;
	ep = sp + MAXRECUR;
	for(;;) {
		if(p == nil) {
			if(sp == a)
				return;
			pop(p);
			visit(p);
			p = p->right;
		} else {
			push(p);
			p = p->left;
		}
	}
}
