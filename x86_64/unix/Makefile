1.4.2: u1.4.2.S
	$(CC) -static -o 1.4.2 u1.4.2.S

ex1.3.2.3: uex1.3.2.3.S uprogm.S
	$(CC) -static uex1.3.2.3.S uprogm.S
	mv a.out ex1.3.2.3

progm: umainprogm.c uprogm.S
	$(CC) -static umainprogm.c uprogm.S
	mv a.out progm

progp: uprogp.S
	$(CC) uprogp.S
	mv a.out progp
