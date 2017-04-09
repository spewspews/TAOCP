#include <stdlib.h>

typedef struct Tree Tree;
typedef struct Node Node;

struct Tree {
	Node *root;
	int size;
};

struct Node {
	Node *left, *right;
	int val;
};

void
copy1(Node *o, Node *n, Node **avail)
{
	Node *curavail;

	if(n == NULL)
		return;

	curavail = *avail;

	o->val = n->val;
	if(n->left != NULL)
		o->left = ++curavail;
	if(n->right != NULL)
		o->right = ++curavail;

	*avail = curavail;

	copy1(o->left, n->left, avail);
	copy1(o->right, n->right, avail);
}

void
copy(Tree *n, Tree *o)
{
	Node *nodes;

	nodes = NULL;
	if(o->root != NULL) {
		nodes = calloc(o->size, sizeof(*nodes));
		copy1(nodes, o->root, &nodes);
	}

	n->root = nodes;
	n->size = o->size;
}
