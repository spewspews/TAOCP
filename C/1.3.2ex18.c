#include <u.h>
#include <libc.h>

enum
{
	MAXROW = 1000,
	MAXCOL = 1000,
};

char rmin[MAXROW];
char cmax[MAXCOL];

char
saddle(char *a, int r, int c)
{
	int	i, j, sj, si;
	char	minmax, maxmin;

	for(i = 0; i < r; i++){
		rmin[i] = a[i*c];
		if(a[i*c] > cmax[0])
			cmax[0] = a[i*c];
		for(j = 1; j < c; j++){
			if(a[i*c + j] < rmin[i])
				rmin[i] = a[i*c + j];
			if(a[i*c + j] > cmax[j])
				cmax[j] = a[i*c + j];
		}
	}

	maxmin = rmin[0];
	si = 0;
	for(i = 0; i < r; i++){
		if(rmin[i] > maxmin){
			maxmin = rmin[i];
			si = i;
		}
	}
	minmax = cmax[0];
	sj = 0;
	for(j = 0; j < c; j++){
		if(cmax[j] < minmax){
			minmax = cmax[j];
			sj = j;
		}
	}
	if(maxmin == minmax){
		fprint(2, "sp at row %d, col %d\n", si, sj);
		return maxmin;
	}
	else
		return -1;
}
