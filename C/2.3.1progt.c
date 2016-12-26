#include <u.h>
#include <libc.h>

enum{ MAXRECUR = 1000 };

typedef struct Node Node;

struct Node
{
	Node *left, *right;
	int val;
};

#define push(p)	\
	if(sp == ep)	\
		exits("Stack overflow");	\
	else	\
		*sp++ = (p)
#define pop(p) (p) = *--sp

/* Program T */
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
			continue;
		}
		push(p);
		p = p->left;
	}
}

Node*
insert(Node *r, Node *n)
{
	if(r == nil)
		return n;

	if(n->val > r->val)
		r->right = insert(r->right, n);
	else if (n->val < r->val)
		r->left = insert(r->left, n);
	return r;
}

void
printnode(Node *r)
{
	print("Value is %d.\n", r->val);
}

Node pool[100];

void
main(void)
{
	Node *a, *r;

	srand(time(nil));
	r = nil;
	for(a = pool; a < pool + nelem(pool); a++) {
		a->val = lnrand(1000);
		print("Inserting %d.\n", a->val);
		r = insert(r, a);
	}
	print("\nSorted:\n");
	inorder(r, printnode);
}
