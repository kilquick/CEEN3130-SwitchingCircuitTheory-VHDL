;******************************************
;* Studio4 Simulation                     *
;*                                        *
;* Class: 1060 Spring 2013 Lab 5          *
;* Name: Weyler Flores and Evan Stohlmann *
;* Activity 1                             *
;******************************************

.INCLUDE "usb1286def.inc"
.ORG 0x00
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,LOW(RAMEND)
	OUT SPL,R16

	LDI	R16,0xFF
	OUT DDRD,R16
	OUT	DDRB,R16		
	CBI PORTD, 4
	CBI PORTD, 5
	CBI PORTD, 6
	CALL LCD_init
	L1: RJMP L1

LCD_init:
	CALL DELAY
	LDI R16,0x38
	CALL LCD_write
	CALL DELAY
	LDI R16,0x0E
	CALL LCD_write
	LDI R16,0x01
	CALL LCD_write

		

LCD_write:
	OUT PORTB,R16
	CBI PORTD, 6
	CBI PORTD, 4
	SBI PORTD, 5
	CALL DELAY
	CBI	PORTD,5
	CALL DELAY
	RET

DELAY:
	  LDI R19, 100
THIS: LDI R18, 120
THAT: NOP
	  NOP
	  DEC R18
	  BRNE THAT
	  DEC R19
	  BRNE THIS
	  RET
		
Activity 2:
;******************************************
;* Studio4 Simulation                     *
;*                                        *
;* Class: 1060 Spring 2013 Lab 5          *
;* Name: Weyler Flores and Evan Stohlmann *
;* Activity 1                             *
;******************************************

.INCLUDE "usb1286def.inc"
.ORG 0x00
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,LOW(RAMEND)
	OUT SPL,R16

	LDI	R16,0xFF
	OUT DDRD,R16
	OUT	DDRB,R16		
	CBI PORTD, 4
	CBI PORTD, 5
	CBI PORTD, 6
	CALL LCD_init
	CALL LCD_char
	L1: RJMP L1

LCD_init:
	CALL DELAY
	LDI R16,0x38
	CALL LCD_write1
	CALL DELAY
	LDI R16,0x0E
	CALL LCD_write1
	LDI R16,0x01
	CALL LCD_write1
	RET
		

LCD_write1:
	OUT PORTB,R16
	CBI PORTD, 6
	CBI PORTD, 4
	SBI PORTD, 5
	CALL DELAY
	CBI	PORTD,5
	CALL DELAY
	RET

DELAY:
	  LDI R19, 100
THIS: LDI R18, 120
THAT: NOP
	  NOP
	  DEC R18
	  BRNE THAT
	  DEC R19
	  BRNE THIS
	  RET
		

LCD_char:
	LDI R16, 'E'
	CALL LCD_write
	LDI R16, 'v'
	CALL LCD_write
	LDI R16, 'a'
	CALL LCD_write
	LDI R16, 'n'
	CALL LCD_write
	LDI R16, ' '
	CALL LCD_write
	LDI R16, 'S'
	CALL LCD_write
	LDI R16, 't'
	CALL LCD_write
	LDI R16, 'o'
	CALL LCD_write
	LDI R16, 'h'
	CALL LCD_write
	LDI R16, 'l'
	CALL LCD_write
	LDI R16, 'm'
	CALL LCD_write
	LDI R16, 'a'
	CALL LCD_write
	LDI R16, 'n'
	CALL LCD_write
	LDI R16, 'n'
	CALL LCD_write
	RET
LCD_write:
	  OUT PORTB, R16
	  SBI PORTD, 6
	  CBI PORTD, 4
	  SBI PORTD, 5
	  CALL DELAY
	  CBI PORTD, 5
	  CALL DELAY
	  RET

Activity 3:

;******************************************
;* Studio4 Simulation                     *
;*                                        *
;* Class: 1060 Spring 2013 Lab 5          *
;* Name: Weyler Flores and Evan Stohlmann *
;* Activity 1                             *
;******************************************

.INCLUDE "usb1286def.inc"
.ORG 0x00
	LDI R16,HIGH(RAMEND)
	OUT SPH,R16
	LDI R16,LOW(RAMEND)
	OUT SPL,R16
	RJMP HER
	NAME: .DB "Evan Stohlmann", $00
	NAME2:.DB "Graduated in 2012",$00


HER:LDI	R16,0xFF
	OUT DDRD,R16
	OUT	DDRB,R16		
	CBI PORTD, 4
	CBI PORTD, 5
	CBI PORTD, 6
	CALL LCD_init
	CALL LCD_string
	L2: RJMP L2

LCD_init:
	CALL DELAY
	LDI R16,0x38
	CALL LCD_write1
	CALL DELAY
	LDI R16,0x0E
	CALL LCD_write1
	LDI R16,0x01
	CALL LCD_write1
	RET
		

LCD_write1:
	OUT PORTB,R16
	CBI PORTD, 6
	CBI PORTD, 4
	SBI PORTD, 5
	CALL DELAY
	CBI	PORTD,5
	CALL DELAY
	RET

DELAY:
	  LDI R19, 100
THIS: LDI R18, 120
THAT: NOP
	  NOP
	  DEC R18
	  BRNE THAT
	  DEC R19
	  BRNE THIS
	  RET
		
LCD_write:
	OUT PORTB, R20
	SBI PORTD, 6
	CBI PORTD, 4
	SBI PORTD, 5
	CALL DELAY
	CBI PORTD, 5
	CALL DELAY
	RET

LCD_string:
	LDI R16, 0x06 ;move cursor to the right
	CALL LCD_write1 ;write to the LCD
	LDI ZL, LOW(NAME<<1)
	LDI ZH, HIGH(NAME<<1)
	CALL LCD_char
	LDI R16, 0xC0
	CALL LCD_write1
	LDI ZL, LOW(NAME2<<1)
	LDI ZH, HIGH(NAME2<<1)
	CALL LCD_char
	RET

LCD_char:
M1:		LPM R16, Z+
		CPI R16, 0
		BREQ M2
		CALL LCD_write
		RJMP M1
M2:		RET
	
 L1:LPM R20, Z+
    CALL LCD_write
	RJMP L1
RET
