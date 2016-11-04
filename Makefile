PROGS=first count1s longest1s sum01

all: ${PROGS}

clean:
	rm -vf ${PROGS} *.o
