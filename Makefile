PROGS=first count1s longest1s sum01 longest

all: ${PROGS}

longest: print.c longest.s

clean:
	rm -vf ${PROGS} *.o
