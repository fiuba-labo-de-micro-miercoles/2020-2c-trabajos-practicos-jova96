.include "m328pdef.inc"

.def temp1 = R18	; Registro auxiliares para el delay
.def temp2 = R17

.equ PinLed = 0 
.equ PinPregunta_on = 0
.equ PinPregunta_off = 1

.cseg 
.org 0x0000
			jmp		main

.org INT_VECTORS_SIZE
main:

	ldi r20, low(RAMEND)
	out spl, r20
	ldi r20, high(RAMEND)
	out sph, r20

inicio:

	ldi r20, 0xff
	cbi PORTD, PinLed 
	out DDRD, r20	; puerto de salida D

	ldi r20, 0x00
	out DDRC, r20	; puerto de entrada C
	   
preguntarsipulso_on:
	call delay5ms
	in r20, PINC
	andi r20, 1<<PinPregunta_on
	breq preguntarsipulso_on
 

parpadear :
	sbi		PORTD, PinLed
	
	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio


	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio


	call delay5ms

	cbi PORTD, PinLed
		
	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio

	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio


	call delay5ms

	in r20, PINC
	andi r20, 1<<PinPregunta_off
	brne inicio


	call delay5ms

	jmp parpadear

delay5ms:
	ldi temp1, 66
	LOOP0:
		ldi temp2, 200
		LOOP1:
			dec temp2	
			brne LOOP1

		dec temp1
		brne LOOP0
ret
	