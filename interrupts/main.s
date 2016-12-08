	.include "address_map_arm.s"
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
		BL	CONFIG_PRIV_TIMER	// configure the MPCore private timer
		BL	CONFIG_KEYS		// configure the pushbutton KEYs

		MOV	R0, #SVC_MODE | INT_ENABLE
		MSR	CPSR,R0			// enable CPU interrupts

		LDR	R6, =LEDR_BASE		// LED base address
MAIN:
		LDR	R4, LEDR_PATTERN	// LEDR pattern; modified by timer ISR
		STR	R4, [R6] 		// write to red LEDs
		B 	MAIN

/* Configure the MPCore private timer to create interrupts every 1/10 second */
CONFIG_PRIV_TIMER:
		LDR	R0, =MPCORE_PRIV_TIMER 	// Timer base address
		LDR	R1, =20000000		// 20 million ticks = 1/10 second
		STR	R1,[R0]			
		MOV	R1, #0b111		// interrupts enabled, auto-reset, timer enabled
		STR	R1, [R0, #8]
		MOV	PC, LR

/* Configure the KEYS to generate an interrupt */
CONFIG_KEYS:
		LDR 	R0, =KEY_BASE		// KEYs base address
		MOV	R1, #KEY3		// we only want interrupts for KEY3
		STR	R1, [R0,#8]
		MOV 	PC, LR

		.global	LEDR_DIRECTION
LEDR_DIRECTION:
		.word 	0			// 0 means left, 1 means right

		.global	LEDR_PATTERN
LEDR_PATTERN:
		.word 	RIGHT
