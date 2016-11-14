	.text
	.global	test
 
test:
	MOV	R5,#0		// final answer - ones
	MOV	R6,R5		// final answer - zeros
	MOV	R7,R5		// final answer - alternating
	LDR	R4,=TEST_NUM	// pointer to test array

1:	LDR	R1,[R4],#4	// r1 <- *r4++
	CMP	R1,#0		// end of test data is signaled with 0
	BEQ	2f

	PUSH	{R1-R7,LR}	// save our registers; multiple of 8 bytes
	BL	ONES		// count 1's in R0, returned in R1
	POP	{R1-R7,LR}	// restore our registers

	CMP	R5,R0		// is return value larger than accumulator?
	MOVLT	R5,R0		// R0 was larger, so save it

	PUSH	{R1-R7,LR}	// save our registers; multiple of 8 bytes
	BL	ZEROS		// count 0's in R0, returned in R1
	POP	{R1-R7,LR}	// restore our registers

	CMP	R6,R0		// is return value larger than accumulator?
	MOVLT	R6,R0		// R0 was larger, so save it

	PUSH	{R1-R7,LR}	// save our registers; multiple of 8 bytes
	BL	ALT		// count alternating bits in R0, returned in R1
	POP	{R1-R7,LR}	// restore our registers

	CMP	R7,R0		// is return value larger than accumulator?
	MOVLT	R7,R0		// R0 was larger, so save it

	B	1b		// go back around
2:	
	BX	LR		// return

/*
 * ONES - count consecutive 1's in a 32-bit word.
 *
 * IN:
 *	R1 - word to test
 * OUT:
 *	R0 - longest string of 1's
 */
ONES:
	MOV	R0,#0
1:	CMP	R1,#0
	BEQ	2f
	LSR	R2,R1,#1
	AND	R1,R1,R2
	ADD	R0,#1
	B	1b

2:	BX	LR		// return


/*
 * ZEROS - count consecutive 0's in a 32-bit word.
 * IN:
 *	R1 - word to test
 * OUT:
 *	R0 - longest string of 0's
 */
ZEROS:
	LDR	R2,=0xffffffff
	EOR	R1,R1,R2
	PUSH	{R1,LR}
	BL	ONES		// count all 1's in R1, which counts all 0's in input
	POP	{R1,LR}

	BX	LR


ALT:
	LDR	R2,=0xAAAAAAAA	// XOR against alternating 1-0 pattern; this converts
	EOR	R1,R1,R2	// our test to a longest zeros or longest ones test

	MOV	R3,R1		// save a copy of R1, our test number
	PUSH	{R1-R3,LR}
	BL	ONES
	POP	{R1-R3,LR}

	MOV	R2,R0		// save result of ONES
	MOV	R1,R3		// restore our saved test number
	PUSH	{R1-R3,LR}
	BL	ZEROS
	POP	{R1-R3,LR}

	CMP	R0,R2		// return result of ONES or ZEROS, whichever is larger
	BGT	RETURN
	MOV	R0,R2

RETURN:	BX	LR


TEST_NUM:
	.word	0xff770ffe	// 11; 4; 3; 1111 1111 0111 0111 0000 1111 1111 1110
	.word	0x00ffff77	// 16; 8; 3; 0000 0000 1111 1111 1111 1111 0111 0111
	.word	0x103fe00f	// 9;  9; 3; 0001 0000 0011 1111 1110 0000 0000 1111
	.word	0x00AA0005	// 1; 14; 9; 0000 0000 1010 1010 0000 0000 0000 0101
	.word	0

	.end
