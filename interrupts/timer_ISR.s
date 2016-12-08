			.include "address_map_arm.s"
			.extern	LEDR_DIRECTION
			.extern	LEDR_PATTERN

/*****************************************************************************
 * MPCORE Private Timer - Interrupt Service Routine                                
 *                                                                          
 * Shifts the pattern being displayed on the LEDR
 * 
******************************************************************************/
			.global PRIV_TIMER_ISR			
PRIV_TIMER_ISR:	
		LDR	R0, =MPCORE_PRIV_TIMER	// base address of timer
		MOV	R1, #1
		STR	R1, [R0, #0xC]		// must CLEAR interrupt...

/* Rotate the LEDR bits either to the left or right. Reverses direction when hitting 
	position 9 on the left, or position 0 on the right */
SWEEP:		LDR	R0, =LEDR_DIRECTION	// put shifting direction into R2
		LDR	R2, [R0]
		LDR	R1, =LEDR_PATTERN	// put LEDR pattern into R3
		LDR	R3, [R1]

		CMP	R2, #RIGHT		// what direction are we currently shifting?
		BEQ	SHIFTR

SHIFTL:		LSL	R3,#1			// shift left
		CMP	R3,#512			// are we at the last LED?
		BNE	DONE_SWEEP		
L_R:		MOV	R2, #RIGHT		// change direction to right
		B	DONE_SWEEP

SHIFTR:		LSR	R3,#1			// shift right
		CMP	R3,#1			// are we at the last LED?
		BNE	DONE_SWEEP		
R_L:		MOV	R2, #LEFT		// change direction to left

DONE_SWEEP:
		STR	R2, [R0]		// put shifting direction back into memory
		STR	R3, [R1]		// put LEDR pattern back into memory
	
END_TIMER_ISR:
		MOV	PC, LR
