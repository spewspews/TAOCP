#include <u.h>
#include <libc.h>

char	inbuf[1000];
char	outbuf[1000];
char	t[0x80];

void
main(void)
{
	long	size;
	uchar	i;
	char	j, z, x;

	for(i = 0x21; i < 0x80; i++)
		t[i] = i;
	size = read(0, inbuf, sizeof(inbuf));
	for(size -= 2; size >= 0; size--){
		i = inbuf[size];
		switch(i){
		case ')':
			z = 0;
			break;
		case '(':
			t[j] = z;
			break;
		default:
			if(z == 0)
				j = i;
			x = t[i];
			t[i] = z;
			z = x;
			break;
		}
	}
	size = 0;
	for(i = 0x21; i < 0x80; i++){
		x = t[i];
		if(x == i)
			continue;
		if(x < 0)
			continue;
		outbuf[size++] = '(';
		for(z = i; x >= 0; x = t[z]){
			outbuf[size++] = z;
			t[z] |= 0x80;
			z = x;
		}
		outbuf[size++] = ')';
	}
	outbuf[size++] = '\n';
	write(1, outbuf, size);
	exits(0);
}
