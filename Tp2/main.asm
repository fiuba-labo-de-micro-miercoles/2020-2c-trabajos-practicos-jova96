.include "m328pdef.inc"

.def RegAux = R16
.def RegContador0 = R20
.def RegContador1 = R21

.equ UltimoBit = 5	; Bit de rebote en el extremo superior
.equ PrimerBit = 0	; Bit de rebote en e extremo inferior
.equ PuertoSalida = PORTC
.equ PuertoConfiguracion = DDRC
.equ Repeticiones = 15
.equ ContadorMaximo = 63


.cseg
.org 0x0000
	jmp Configuracion

.org INT0addr
	jmp isr_int0

.org INT1addr
	jmp isr_int1

.org INT_VECTORS_SIZE


Configuracion:

	/* Inicializacion de stack pointer*/
	ldi RegAux, LOW(RAMEND)
	out spl, RegAux
	ldi RegAux, HIGH(RAMEND)
	out sph, RegAux

	/* configuracion interrupciones */
	ldi RegAux, (1<<ISC01 | 1<<ISC11)	; La interrupcion es por flanco descendente
	sts EICRA, RegAux

	ldi RegAux, (1<<INT0 | 1<<INT1)		; Se activa la interrupcion 0/1
	out EIMSK, RegAux

	SEI

	/* Configuraion de puerto */
	ldi RegAux, 0xff
	out PuertoConfiguracion, RegAux

	/* Inicializacion de puerto*/
	clr RegAux
	out PuertoSalida, RegAux

inicio: 
	clr RegAux
	sec
ida:
	rol RegAux
	call delay500mseg

	out PuertoSalida, RegAux
	sbrc RegAux, UltimoBit
	jmp vuelta
	jmp ida
vuelta:
	ror RegAux
	call delay500mseg

	out PuertoSalida, RegAux
	sbrc RegAux, (PrimerBit+1)
	jmp inicio
	jmp vuelta


final:	rjmp final

delay10ms:	; para 16Mhz
	push RegContador0
	push RegContador1 
	
	ldi RegContador0, 209
	LOOP0:
		ldi RegContador1, 255
		LOOP1:
			dec RegContador1
			brne LOOP1

		dec RegContador0
		brne LOOP0

	pop RegContador1
	pop RegContador0
ret

delay500mseg:
	push RegContador0

	ldi RegContador0, 50
retardo:	
	call delay10ms
	dec RegContador0
	brne retardo

	pop RegContador0
ret

isr_int0:
	push RegAux

	ldi RegContador0, Repeticiones 
repetir:
	cpi RegContador0, 0x00
	breq regresar
	ldi RegAux, (1<<PrimerBit | 1<<UltimoBit)
	out PuertoSalida, RegAux
	call delay500mseg 
	clr RegAux
	out PuertoSalida, RegAux
	call delay500mseg
	dec RegContador0
	jmp repetir

regresar:
	pop RegAux
reti


isr_int1:
	push RegContador0

	ldi RegContador0, 0x00
repetir_int1:
	out PuertoSalida, RegContador0
	call delay500mseg
	cpi RegContador0, ContadorMaximo
	breq final_int1
	inc RegContador0
	jmp repetir_int1

final_int1:
	pop RegContador0
reti
