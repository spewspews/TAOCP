typedef struct Poly Poly;

struct Poly {
	int32_t coef;
	int32_t abc;
	Poly *link;
};

extern Poly *avail;

int	add(Poly *q, Poly *p);
