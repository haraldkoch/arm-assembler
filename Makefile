PROGS=first count1s longest1s sum01 longest

all: ${PROGS}

clean:
	rm -vf ${PROGS} *.o
