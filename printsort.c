#include <stdio.h>

int main(int argc, char **argv) {
	long *result;

	asm volatile (
		"bl sort\n\t"
		"mov %[result], r0\n\t"
	    : [result] "=r" (result)
	    : /* no input registers */
	    : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7", "r8", "r9"
	    );

	long count = *result++;
	for (long i = 0 ; i < count ; i++) {
		printf("%02ld: %ld\n", i, result[i]);
	}
}
