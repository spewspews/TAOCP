enum{ MAXRECUR = 1000 };

typedef struct Tree Tree;

struct Tree
{
	int	 val;
	Tree	*left;
	Tree	*right;
};

Tree	*a[MAXRECUR];

Tree	*add(Tree*, int);
void	 visit(Tree*);
void	 inorder(Tree *, void (*)(Tree*));
void	 preorder(Tree *, void (*)(Tree*));
void	 postorder(Tree *, void (*)(Tree*));
