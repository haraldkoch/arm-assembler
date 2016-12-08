	.include "address_map_arm.s"
	.include "defines.s"
/*
 * This program demonstrates the use of interrupts using the KEY and timer ports. It
 * 	1. displays a sweeping red light on LEDR, which moves left and right
 * 	2. stops/starts the sweeping motion if KEY3 is pressed
 * Both the timer and KEYs are handled via interrupts
*/
			.text
			.global	_start
_start:
		MOV	R0, #IRQ_MODE | INT_DISABLE
		MSR	CPSR, R0
		LDR	SP,=0x20000		// setup the stack for IRQ mode

		MOV	R0, #SVC_MODE | INT_DISABLE
		MSR	CPSR,R0			
		LDR	SP,=0x3FFFFFFC		// setup the stack for Supervisor mode


		BL	CONFIG_GIC		// configure the ARM generic interrupt controller
		BL	CONFIG_KEYS		// configure the pushbutton KEYs

		MOV	R0, #SVC_MODE | INT_ENABLE
		MSR	CPSR,R0			// enable CPU interrupts

		LDR	R6, =HEX3_HEX0_BASE	// 7-segment base address
MAIN:
		LDR	R0, DIGIT		// current digit
		BL	SEVEN_SEGMENT		// convert to pattern
		STR	R0, [R6]		// write pattern to hardware
		B 	MAIN

SEVEN_SEGMENT:
		MOV	R1, R0			// save a copy of the digit
		CMP	R1, #0
		MOVEQ	R0, #0b00111111
		CMP	R1, #1
		MOVEQ	R0, #0b00000110
		// etc.

		MOV	PC, LR

/* Configure the KEYS to generate an interrupt */
CONFIG_KEYS:
		LDR 	R0, =KEY_BASE		// KEYs base address
		MOV	R1, #KEY3		// we only want interrupts for KEY3
		STR	R1, [R0,#8]
		MOV 	PC, LR

		.global DIGIT
DIGIT:
		.word 	0
