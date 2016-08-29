#include <stdlib.h>
#include <assert.h>
#include <fmt.h>

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

Matrix*
makematrix(unsigned int rows, unsigned int cols)
{
	Matrix *m;
	Node *n;

	m = malloc(sizeof(*m));
	if(m == NULL)
		return NULL;

	m->baserow = calloc(rows, sizeof(*m->baserow));
	m->basecol = calloc(cols, sizeof(*m->basecol));
	if(m->baserow == NULL || m->basecol == NULL) {
		free(m);
		return NULL;
	}

	for(n = m->baserow; n < m->baserow + rows; n++) {
		n->right = n;
		n->col = -1;
	}

	for(n = m->basecol; n < m->basecol + cols; n++) {
		n->down = n;
		n->row = -1;
	}

	m->rows = rows;
	m->cols = cols;

	return m;
}

int
insert(Matrix *m, double val, unsigned int row, unsigned int col)
{
	Node *n, *p;

	if(row >= m->rows || col >= m->cols)
		return 0;

	for(p = m->baserow+row; ; p = p->right) {
		if(col > p->right->col)
			continue;

		if(col < p->right->col) {
			n = malloc(sizeof(*n));
			if(n == NULL)
				return -1;
		
			n->row = row;
			n->col = col;
			n->val = val;

			n->right = p->right;
			p->right = n;
			break;
		}

		if(col == p->right->col) {
			n = NULL;
			if(val == 0.0) {
				p->right = p->right->right;
				break;
			}
			p = p->right;
			p->val = val;
			break;
		}
	}

	for(p = m->basecol+col; ; p = p->down) {
		if(row > p->down->row)
			continue;

		if(row < p->down->row) {
			n->down = p->down;
			p->down = n;
			break;
		}

		if(row == p->down->row) {
			assert(n != NULL);
			if(val == 0.0) {
				n = p->down;
				p->down = n->down;
				free(n);
				break;
			}
			p = p->down;
			p->val = val;
			break;
		}
	}

	return 0;
}

int
matrixfmt(Fmt *fmt)
{
	Matrix *m;
	Node *n;
	unsigned int i, j;
	int r;
	char c;

	m = va_arg(fmt->args, Matrix*);

	for(i = 0; i < m->rows; i++) {
		n = m->baserow[i].right;
		for(j = 0; j < m->cols; j++) {
			c = j+1 < m->cols ? ' ' : '\n';
			if(j == n->col)
				r = fmtprint(fmt, "%g%c", c);
			else
				r = fmtprint(fmt, "0%c", c);

			if(r == -1)
				return -1;
		}
	}

	return 0;
}

int
main(void)
{
	Matrix *m;

	fmtinstall('M', matrixfmt);

	print("Node size: %lu\n", sizeof(Node));
	print("Matrix size: %lu\n", sizeof(Matrix));

	m = makematrix(20, 20);

	print("%u, %u\n", m->baserow->col, m->basecol->row);
	exit(0);
}
