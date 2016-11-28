	.text
	.equ LEDs, 0xFF200000
	.equ KEYS, 0xFF200050
	.equ TIMER, 0xFFFEC600
	.global _start


_start:
	LDR 	R2, =LEDs	// R2 - LED base
	LDR 	R3, =KEYS	// R3 - keys base
	MOV	R4, #1		// R4 - current bit pattern
	LDR	R5, =TIMER	// R5 - timer base

	LDR	R6, =20000000	// 20,000,000 ticks =~ 1/10 second on this hardware
	STR	R6, [R5]	// store in the timer load register
	MOV	R7, #0b011	// timer control bits - interrupts DISabled, timer auto-load enabled, timer enabled
	STR	R7, [R5, #8]	// store in timer control register

LOOP1:
	BL	CHECK_KEY

	LDR	R7, [R5, #8]	// if the timer is not running, just loop
	AND	R7, #1		// checking to see if key is pressed again
	BEQ	LOOP1

	BL	DELAY

	STR	R4, [R2]	// store the current LED pattern in the LED register
	LSL	R4, #1		// and shift it left one bit
	CMP	R4, #512	// 2^9...reached the last LED
	BNE	LOOP1

LOOP2:
	BL	CHECK_KEY

	LDR	R7, [R5, #8]	// if the timer is not running, just loop
	AND	R7, #1		// checking to see if key is pressed again
	BEQ	LOOP2

	BL	DELAY

	STR	R4, [R2]	// store the current LED pattern in the LED register
	LSR	R4, #1		// and shift it right one bit
	CMP	R4, #1		// 2^0 - reached the last LED
	BNE	LOOP2

	B	LOOP1


CHECK_KEY:
	LDR	R0, [R3]	// which key(s) are pressed
	ANDS	R0, #8		// check for key 3 (2^3)
	BEQ	NOT_HELD	// it's not pressed - return

	LDR	R7, [R5, #8]	// toggle the timer off->on or on->off
	EOR	R7, #1		// by using X-OR on the "timer enabled" bit
	STR	R7, [R5, #8]

HELD:
	LDR	R0, [R3]	// while the key is still pressed, loop
	ANDS	R0, #8		// FIXME - should use the edge detection register instead
	BNE	HELD

NOT_HELD:
	MOV	PC, LR		/ key is no longer pressed - return

DELAY:
	LDR	R0, [R5,#12]	// read the current timer status
	CMP	R0, #0
	BEQ	DELAY		// timer has not fired - keep delaying
	STR	R0, [R5,#12]	// we need to reset the "timer fired" bit
	MOV	PC, LR
