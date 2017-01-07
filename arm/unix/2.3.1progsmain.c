#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>

#define	nelem(x)	(sizeof(x)/sizeof((x)[0]))

enum {
	MAX = 1000,
	NODES = 100
};

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
	if(r == NULL) {
		n->left = (Node*)1;
		n->right = (Node*)1;
		return n;
	}
	if(n->val > r->val) {
		if((uintptr_t)r->right & 1) {
//			printf("at right end %d %d\n", r->val, n->val);
			n->right = r->right;
			n->left = (Node*)((uintptr_t)r | 1);
			r->right = n;
			return r;
		}
		r->right = insert(r->right, n);
	} else if (n->val < r->val) {
		if((uintptr_t)r->left & 1) {
//			printf("at left end %d %d\n", r->val, n->val);
			n->left = r->left;
			n->right = (Node*)((uintptr_t)r | 1);
			r->left = n;
			return r;
		}
		r->left = insert(r->left, n);
	}
	return r;
}

void
printnode(Node *r)
{
	printf("Value is %d.\n", r->val);
}

Node pool[NODES];

void
debug(int d)
{
	printf("here at %d\n", d);
}

void
debug1(int d)
{
	printf("the node is %d\n", d);
}

int
main(void)
{
	Node *a, *r;

	srand(time(NULL));
	r = NULL;
	for(a = pool; a < pool + nelem(pool); a++) {
		a->val = (double)rand() / RAND_MAX * MAX;
		printf("Inserting %d.\n", a->val);
		r = insert(r, a);
	}
	printf("\nSorted:\n");
	inorder(r, printnode);
	exit(0);
}
