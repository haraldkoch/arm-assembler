	.text
	.global start

start:
	. . . initialize the IRQ stack pointer . . .
	. . . initialize the SVC stack pointer . . .

	BL CONFIG GIC		// configure the ARM generic interrupt controller
	BL CONFIG PRIV TIMER	// configure the MPCore private timer
	BL CONFIG KEYS		// configure the pushbutton KEYs

	. . . enable ARM processor interrupts . . .

	LDR R6, =0xFF200000	// red LED base address
MAIN:
	LDR R4, LEDR PATTERN	// LEDR pattern; modified by timer ISR
	STR R4, [R6]		// write to red LEDs

	B MAIN

/* Configure the MPCore private timer to create interrupts every 1/10 second */
CONFIG PRIV TIMER:
	LDR R0, =0xFFFEC600	// Timer base address
	. . . code not shown
	MOV PC, LR		// return

/* Configure the KEYS to generate an interrupt */
CONFIG KEYS:
	LDR R0, =0xFF200050	// KEYs base address
	. . . code not shown
	MOV PC, LR		// return

.global LEDR DIRECTION
LEDR DIRECTION:
	.word 0			// 0 means left, 1 means right

	.global LEDR PATTERN
LEDR PATTERN:
	.word 0x1
