#include <stdlib.h>
#include <math.h>

typedef struct Matrix Matrix;
typedef struct Node Node;

struct Node
{
	Node *right;
	Node *down;
	unsigned int row;
	unsigned int col;
	double val;
};

struct Matrix
{
	Node *baserow;
	Node *basecol;
	unsigned int rows;
	unsigned int cols;
};

int
pivot(Matrix *m, unsigned int i0, unsigned int j0, double epsilon)
{
	Node **ptr, *p0, *q0, *p, *p1, *x;
	unsigned int i, j;
	double alpha;

	if(i0 >= m->rows || j0 >= m->cols)
		return -1;

	ptr = calloc(sizeof(*ptr), m->cols);

	for(p0 = m->baserow[i0].right; p0->col != j0; p0 = p0->right) {
		if(p0->col == (unsigned int)-1 || p0->col > j0)
			return -1;
	}

	alpha = 1.0 / p0->val;
	p0->val = 1.0;

	for(p0 = m->baserow[i0].right; p0->col != (unsigned int)-1; p0 = p0->right) {
		ptr[p0->col] = m->basecol + p0->col;
		p0->val *= alpha;
	}

	for(q0 = m->basecol[j0].down; q0->row != (unsigned int)-1; q0 = q0->down) {
		if(q0->row == i0)
			continue;
		i = q0->row;
		p = m->baserow + i;
		p1 = p->right;
		for(p0 = m->baserow[i0].right; p0->col != (unsigned int)-1; p0 = p0->right) {
			if(p0->col == j0)
				continue;
			j = p0->col;
			while(p1->col < j) {
				p = p1;
				p1 = p->right;
			}
			if(p1->col > j) {
				while(ptr[j]->down->row < i)
					ptr[j] = ptr[j]->down;
				x = malloc(sizeof(*x));
				x->val = 0.0;
				x->row = i;
				x->col = j;
				x->right = p1;
				x->down = ptr[j]->down;
				ptr[j]->down = x;
				p->right = x;
				p1 = x;
			}
			p1->val -= p0->val * q0->val;
			if(fabs(p1->val) < epsilon) {
				while(ptr[j]->down != p1)
					ptr[j] = ptr[j]->down;
				ptr[j]->down = p1->down;
				p->right = p1->right;
				free(p1);
			} else
				ptr[j] = p1;
		}
		q0->val *= -alpha;
	}
	return 0;
}
