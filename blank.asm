; This program does absolutely nothing
; Created only as a reference for maintaining the stack accross functions
.DEVICE ATmega328p
.equ SPH = 0x3e
.equ SPL = 0x3d

; Execution time
; C = 1/16Mhz
; setup - 15 C
; loop - 15 C
; main - 14 C
; 44 C = 44 * 0.0625 us = 2.75 us

.org 0x00
	jmp main

; setup function
; void
setup:
	push r28
	push r29
	in r28, SPL
	in r29, SPH
	nop
	pop r29
	pop r28
	ret

; loop function
; void
loop:
	push r28
	push r29
	in r28, SPL
	in r29, SPH
	nop
	pop r29
	pop r28
	ret

; main function
main:
	push r28
	push r29
	in r28, SPL
	in r29, SPH
	rcall setup
forloop:
	rcall loop
	rjmp forloop