#include <u.h>
#include <libc.h>

char	inbuf[1000];
char	outbuf[1000];

int
untagged(long size)
{
	int i;

	for(i = 0; i < size; i++){
		if(inbuf[i] > 0)
			return i;
	}
	return -1;
}

void
main(void)
{
	long	size;
	int	k, j, i;
	char	current, start, x;

	size = read(0, inbuf, sizeof(inbuf));
	size--;
	for(k = 0; k < size; k++){
		switch(inbuf[k]){
		case '(':
			inbuf[k++] |= 0x80;
			start = inbuf[k];
			break;
		case ')':
			start |= 0x80;
			inbuf[k] = start;
			break;
		}
	}
	j = 0;
	for(;;){
		if((k = untagged(size)) == -1)
			break;
		start = inbuf[k];
		outbuf[j++] = '(';
		outbuf[j++] = start;
		inbuf[k++] |= 0x80;
		current = inbuf[k++];
		current &= 0x7f;
		while(k <= size){
			if(k == size){
				if(current != start){
					outbuf[j++] = current;
					k = 0;
					continue;
				}
				else{
					if(outbuf[j - 2] == '(')
						j -= 2;
					else
						outbuf[j++] = ')';
					break;
				}
			}
			x = inbuf[k];
			x &= 0x7f;
			if(x == current){
				inbuf[k++] |= 0x80;
				current = inbuf[k++];
				current &= 0x7f;
			}
			else
				k++;
		}
	}
	outbuf[j++] = '\n';
	write(1, outbuf, j);
	exits(0);
}
