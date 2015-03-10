#include <u.h>
#include <libc.h>
#include "2.3.1.h"

void
printval(Tree* tp)
{
	print("%d\n", tp->val);
}

void
main(void)
{
	Tree	*t;

	t = add(nil, 15);
	add(t, 32);
	add(t, 5);
	add(t, 1);
	add(t, 381);
	add(t, 381);
	add(t, 3);
	add(t, 30);
	print("inorder:\n");
	inorder(t, printval);
	print("preorder:\n");
	preorder(t, printval);
	print("postorder:\n");
	postorder(t, printval);
	exits(0);
}
