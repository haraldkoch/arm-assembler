	.text
	.global	main
 
main:
	MOV	R5,#0		// final answer
	LDR	R4,=TEST_NUM	// pointer to test array

L1:	LDR	R1,[R4],#4	// load the next element of the array (and skip to next)
	CMP	R1,#0		// end of test data is signaled with 0
	BEQ	E1

	MOV	R6,LR		// save LR (we need it to return later)
	BL	ONES		// count 1's in R0, returned in R1
	MOV	LR,R6		// restore LR saved previously
				// we magically know that ONES doesn't touch R6

	CMP	R5,R0		// is return value larger than accumulator?
TEST:	MOVLT	R5,R0		// R1 was larger, so save it
	B	L1		// go back around
E1:
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
LOOP:	CMP	R1,#0
	BEQ	END
	LSR	R2,R1,#1
	AND	R1,R1,R2
	ADD	R0,#1
	B	LOOP

END:	BX	LR		// return

TEST_NUM:
	.word	0xff770ffe	// 11; 1111 1111 0111 0111 0000 1111 1111 1110
	.word	0x00ffff77	// 16; 0000 0000 1111 1111 1111 1111 0111 0111
	.word	0x103fe00f	// 9;  0001 0000 0011 1111 1110 0000 0000 1111
	.word	0

	.end
