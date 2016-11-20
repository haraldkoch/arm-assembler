	.text
	.global	sort

/* Sort the elements in =List using a bubble sort. The first element of =List
 * is the count of elements in the rest of the array.
 */
sort:
	PUSH	{R1-R11,LR}	// for GCC wrapper

	// r5 - pointer to array
	// r6 - length (n)
	// r7 - c (outer loop)
	// r8 - d (inner loop)

	LDR	R5, =List
	LDR	R6, [R5], #4	// R5 now points to first element (past the count)

//  for (c = 0 ; c < ( n - 1 ); c++)
	SUB	R6, R6, #1	// subtract 1 from n because it's easier to compare
	MOV	R7, #0		// c = 0
outer:	CMP	R7, R6		// if c >= (n - 1) then exit loop
	BGE	outer_done
		
//    for (d = 0 ; d < n - c - 1; d++)
	MOV	R8, #0		// d = 0
inner:	SUB	R0, R6, R7	// compute n - c - 1 == (n - 1) - c == R6 - R7
	CMP	R8, R0
	BGE	inner_done	// if d >= (n - c - 1) then exit loop

//      if (list[d] > list[d+1]) { swap }
	LSL	R0, R8, #2	// multiply our loop index by word size
	ADD	R0, R0, R5	// R0 = ( List + d )
	BL	SWAP		// swap *r0 and *(r0+1) if required
	ADD	R8, R8, #1	// increment loop index and go back
	B	inner

inner_done:
	ADD	R7, R7, #1	// increment loop index and go back
	B	outer

outer_done:
	LDR	R0, =List
	POP	{R1-R11,LR}
	BX	LR

/* compare and swap two adjacent memory elements.
 * input:
 *	r0 - address of first element to check / swap.
 * output:
 *	r0 - 1 if a swap occurred, 0 otherwise
 */
SWAP:
	LDR	R2, [R0]	// load first element of array
	LDR	R1, [R0, #4]	// load second element of array
	CMP	R2, R1		// branch if they're already correct
	BLE	1f
	STR	R1, [R0]	// swap - store R1 as second
	STR	R2, [R0, #4]	//  and R2 as first
	MOV	R0, #1		// we swapped; tell the caller
	BAL	2f
1:
	MOV	R0, #0		// we did not swap; tell the caller
2:	MOV	PC, LR		// return

	.data
List:	.word	10, 1400, 45, 23, 5, 3, 8, 17, 4, 20, 33
