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
/* Cortex-A9 MPCore Technical Reference Manual https://developer.arm.com/docs/ddi0407/i/4-global-timer-private-timers-and-watchdog-registers/42-private-timer-and-watchdog-registers */
/* triggers interrup ID 29 */
CONFIG PRIV TIMER:
	LDR R0, =0xFFFEC600	// Timer base address

	LDR R1, =20000000	// 20,000,000 ticks ~= 1/10th second
	STR R1, [R0]		// timer load register

	MOV R1, #0b111		// enable interrupts, enable autoreload, enable timer
	STR R1, [R0, #8]	// timer control register

	MOV PC, LR		// return

/* Configure the KEYS to generate an interrupt */
/* Altera DE1-SoC Computer Manual p 16-23 and p 15 */

CONFIG KEYS:
	LDR R0, =0xFF200050	// KEYs base address
	MOV R1, 0b1000		// set interrupt mask bits - key 3 only
	STR R1, [R0, #8]	// set the interrupt mask register

	MOV PC, LR		// return

.global LEDR DIRECTION
LEDR_DIRECTION:
	.word 0			// 0 means left, 1 means right

	.global LEDR PATTERN
LEDR_PATTERN:
	.word 0x1



KEY_INTERRUPT:
	LDR R0, =0xFF2000050	// KEYs base address
	LDR R1, [R0, #12]	// fetch the edge capture register
	STR R1, [R0, #12]	// clear the interrupt

	AND R1, 0b1000
	BEQ END_KEY_INTERRUPT	// key 3 was not pressed

	LDR R0, =0xFFFEC600	// TIMER base address
	LDR R1, [R0, #8]	// fetch current timer control register
	EOR R1, 0b1		// toggle the "timer enabled" bit
	STR R1, [R0, #8]

END_KEY_INTERRUPT:
	// cleanup stack, etc.
	MOV PC, LR		// is this right for interrupts?


TIMER_INTERRUPT:
	LDR R0, LEDR_DIRECTION	// fetch current LED direction
	BNE MOVE_RIGHT

MOVE_LEFT:
	LDR R0, LEDR_PATTERN	// current bit pattern
	LSL R0, #1		// shift left 1 bit
	STR R0, LEDR_PATTERN
	AND R0, 0x200		// is bit 9 set?
	BEQ END_TIMER_INTERRUPT
	MOV R0, #1
	STR R0, LEDR_DIRECTION	// change shift direction
	BAL END_TIMER_INTERRUPT

MOVE_RIGHT:
	LDR R0, LEDR_PATTERN	// current bit pattern
	LSR R0, #1		// shift left 1 bit
	STR R0, LEDR_PATTERN
	AND R0, 0x1		// is bit 0 set?
	BEQ END_TIMER_INTERRUPT
	MOV R0, #0
	STR R0, LEDR_DIRECTION	// change shift direction

END_TIMER_INTERRUPT:
	// cleanup
	MOV PC, LR
