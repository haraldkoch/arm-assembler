	.text
	.global	main
 
main:
	MOV	R5,#0		// final answer
	LDR	R4,=TEST_NUM	// pointer to test array

1:	LDR	R1,[R4],#4	// r1 <- *r4++
	CMP	R1,#0		// end of test data is signaled with 0
	BEQ	2f

	PUSH	{R1-R5,LR}	// save our state
	BL	ONES		// count 1's in R0, returned in R1
	POP	{R1-R5,LR}	// restore state

	CMP	R5,R0		// is return value larger than accumulator?
	MOVLT	R5,R0		// R1 was larger, so save it
	B	1b		// go back around
2:
	MOV	R0,R5		// copy R5 to R0 so that it becomes status
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

TEST_NUM:
	.word	0xff770ffe	// 11; 1111 1111 0111 0111 0000 1111 1111 1110
	.word	0x00ffff77	// 16; 0000 0000 1111 1111 1111 1111 0111 0111
	.word	0x103fe00f	// 9;  0001 0000 0011 1111 1110 0000 0000 1111
	.word	0

	.end
