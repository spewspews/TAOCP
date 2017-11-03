mix: 2.3.1progt.mix 2.3.1progs.mix

mixal: 2.3.1progt.mixal 2.3.1progs.mixal

2.3.1pool.s: genrandsunix
	./genrandsunix > 2.3.1pool.s

2.3.1prog%.mixal: 2.3.1pool.s 2.3.1prog%main.s 2.3.1prog%.s
	cat $^ > $@

%.mix: %.mixal
	mixasm $<

clean:
	rm -f 2.3.1pool.s *.mixal *.mix genrandsunix

.PHONY: clean
