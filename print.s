	.arch armv6
	.eabi_attribute 28, 1
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 2
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"print.c"
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu vfp
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, lr}
	.syntax divided
@ 6 "print.c" 1
	bl test
	mov ip, r5
	mov lr, r6
	mov r8, r7
@ 0 "" 2
	.arm
	.syntax unified
	ldr	r0, .L3
	mov	r3, r8
	mov	r2, lr
	mov	r1, ip
	bl	printf
	mov	r0, #0
	pop	{r4, r5, r6, r7, r8, pc}
.L4:
	.align	2
.L3:
	.word	.LC0
	.size	main, .-main
	.section	.rodata.str1.4,"aMS",%progbits,1
	.align	2
.LC0:
	.ascii	"R5: %d\012R6: %d\012R7: %d\012\000"
	.ident	"GCC: (GNU) 6.2.1 20160830"
	.section	.note.GNU-stack,"",%progbits
