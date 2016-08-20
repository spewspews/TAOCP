#include <stdlib.h>
#include <stdio.h>

typedef struct Node Node;
typedef struct Head Head;
typedef struct Pool Pool;

struct Head {
	int count;
	int qlink;
	Node *top;
};

struct Node {
	int suc;
	Node *next;
};

struct Pool {
	unsigned int max;
	unsigned int avail;
	Node *nodes;
};

Node*
allocnode(Pool *pool)
{
	if(pool->avail == pool->max) {
		fprintf(stderr, "Overflow in pool of size %u\n", pool->max);
		exit(1);
	}
	return &pool->nodes[pool->avail++];
}

int*
topsort(int *arr, int n)
{
	Head *heads;
	Node *p;
	Pool pool;
	int i, j, k, r, f, nrel, *bp;

	nrel = 0;
	for(bp = arr; *bp != 0; bp += 2)
		nrel++;

	pool.max = nrel;
	pool.avail = 0;
	pool.nodes = calloc(nrel, sizeof(*pool.nodes));

	heads = calloc(n+1, sizeof(*heads));
	for(bp = arr; *bp != 0; bp += 2) {
		j = bp[0];
		k = bp[1];
		
		heads[k].count++;
		
		p = allocnode(&pool);
		p->suc = k;
		p->next = heads[j].top;
		heads[j].top = p;
	}
	
	r = 0;
	for(i = 1; i <= n; i++) {
		if(heads[i].count == 0) {
			heads[r].qlink = i;
			r = i;
		}
	}

	bp = arr;
	f = heads->qlink;
	for(;;) {
		*bp++ = f;
		if(f == 0)
			break;
		for(p = heads[f].top; p != NULL; p = p->next) {
			if(--heads[p->suc].count == 0) {
				heads[r].qlink = p->suc;
				r = p->suc;
			}
		}
		f = heads[f].qlink;
	}

	free(heads);
	free(pool.nodes);
	return arr;
}
