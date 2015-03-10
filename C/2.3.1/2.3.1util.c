#include <u.h>
#include <libc.h>
#include "2.3.1.h"

Tree*
add(Tree* tp, int v)
{
	if(tp == nil){
		tp = malloc(sizeof(Tree));
		tp->val = v;
		tp->left = nil;
		tp->right = nil;
		return tp;
	}
	else for(;;){
		if(v < tp->val){
			if(tp->left == nil){
				tp->left = malloc(sizeof(Tree));
				tp->left->val = v;
				tp->left->left = nil;
				tp->left->right = nil;
				return tp->left;
			}else{
				tp = tp->left;
				continue;
			}
		}else if(v > tp->val){
			if(tp->right == nil){
				tp->right = malloc(sizeof(Tree));
				tp->right->val = v;
				tp->right->left = nil;
				tp->right->right = nil;
				return tp->right;
			}else{
				tp = tp->right;
				continue;
			}
		}else
			return tp;
	}
}
