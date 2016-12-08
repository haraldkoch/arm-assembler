
				.include "address_map_arm.s"
				.include "defines.s"

/***************************************************************************************
 * Pushbutton - Interrupt Service Routine                                
 *                                                                          
 * This routine checks which KEY has been pressed.  If KEY3 it stops/starts the timer.
****************************************************************************************/
			.global	KEY_ISR

KEY_ISR:	LDR	R0, =KEY_BASE		// base address of KEYs parallel port
		LDR	R1, [R0, #0xC]		// read edge capture register
		STR	R1, [R0, #0xC]		// clear the interrupt

CHK_KEY3:		
		TST	R1, #KEY3
		BEQ	CHK_KEY2

		// KEY3; increment
		LDR	R0, =DIGIT
		LDR	R2, [R0]
		CMP	R2, #0xF
		BEQ	END_KEY_ISR
		ADD	R2, R2, #1
		STR	R2, [R0]
		B	END_KEY_ISR		// assume one key at a time

CHK_KEY2:
		TST	R1, #KEY2
		BEQ	CHK_KEY1

		// KEY2; decrement
		LDR	R0, =DIGIT
		LDR	R2, [R0]
		CMP	R2, #0
		BEQ	END_KEY_ISR
		SUB	R2, R2, #1
		STR	R2, [R0]
		B	END_KEY_ISR		// assume one key at a time

CHK_KEY1:
		TST	R1, #KEY1
		BEQ	END_KEY_ISR

		// KEY1; reset to 0
		LDR	R0, =DIGIT
		MOV	R2, #0
		STR	R2, [R0]

END_KEY_ISR:	MOV	PC, LR
			.end
