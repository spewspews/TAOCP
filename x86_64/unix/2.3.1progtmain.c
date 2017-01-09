#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#define	nelem(x)	(sizeof(x)/sizeof((x)[0]))

typedef struct Node Node;

struct Node
{
	Node *left, *right;
	int val;
};

void inorder(Node*, void(*)(Node*));

Node*
insert(Node *r, Node *n)
{
	if(r == NULL)
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
	printf("Value is %d.\n", r->val);
}

Node pool[100];

int
main(void)
{
	Node *a, *r;

	srand(time(NULL));
	r = NULL;
	for(a = pool; a < pool + nelem(pool); a++) {
		a->val = (double)rand() / RAND_MAX * 1000000;
		printf("Inserting %d.\n", a->val);
		r = insert(r, a);
	}
	printf("\nSorted:\n");
	inorder(r, printnode);
	exit(0);
}
