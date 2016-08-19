#include <stdlib.h>

typedef struct Node Node;
typedef struct Head Head;

struct Head {
	int count;
	int qlink;
	Node *top;
};

struct Node {
	int suc;
	Node *next;
};

int*
topsort(int *arr, int n)
{
	Head *heads;
	Node *p;
	int i, j, k, r, f, *bp;
	
	heads = calloc(n+1, sizeof(*heads));
	for(bp = arr; *bp != 0; bp += 2) {
		j = bp[0];
		k = bp[1];
		
		heads[k].count++;
		
		p = malloc(sizeof(*p));
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
	
	return arr;
}
