#include <stdio.h>

int main(int argc, char **argv) {
	int reg5, reg6, reg7;

	asm volatile (
		"bl test\n\t"
		"mov %[reg5], r5\n\t"
		"mov %[reg6], r6\n\t"
		"mov %[reg7], r7"
	    : [reg5] "=r" (reg5), [reg6] "=r" (reg6), [reg7] "=r" (reg7)
	    : /* no input registers */
	    : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7"
	    );

	printf("R5: %d\nR6: %d\nR7: %d\n", reg5, reg6, reg7);
}
