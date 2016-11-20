PROGS=first count1s longest1s sum01 longest sort

all: ${PROGS}

longest: print.c longest.s

sort: printsort.c sort.s

clean:
	rm -vf ${PROGS} *.o
