/*
 * File:   %<%NAME%>%.%<%EXTENSION%>%
 * Author: %<%USER%>%
 *
 * Created on %<%DATE%>%, %<%TIME%>%
 */

    .include "p33fj32mc202.inc"

    ; ______Configuration Bits________
    ;User program memory is not write-protected
    #pragma config __FGS, GWRP_OFF & GSS_OFF & GCP_OFF
    
    ;Internal Fast RC (FRC)
    ;Start-up device with user-selected oscillator source
    #pragma config __FOSCSEL, FNOSC_FRC & IESO_ON
    
    ;Both Clock Switching and Fail-Safe Clock Monitor are disabled
    ;XT mode is a medium-gain, medium-frequency mode that is used to work with crystal
    ;frequencies of 3.5-10 MHz
  ; #pragma config __FOSC, FCKSM_CSDCMD & POSCMD_XT
    
    ;Watchdog timer enabled/disabled by user software
    #pragma config __FWDT, FWDTEN_OFF
    
    ;POR Timer Value
    #pragma config __FPOR, FPWRT_PWR128
   
    ; Communicate on PGC1/EMUC1 and PGD1/EMUD1
    ; JTAG is Disabled
    #pragma config __FICD, ICS_PGD1 & JTAGEN_OFF

;..............................................................................
;Program Specific Constants (literals used in code)
;..............................................................................

    .equ SAMPLES, 64         ;Number of samples



;..............................................................................
;Global Declarations:
;..............................................................................

    .global _wreg_init       ;Provide global scope to _wreg_init routine
                                 ;In order to call this routine from a C file,
                                 ;place "wreg_init" in an "extern" declaration
                                 ;in the C file.

    .global __reset          ;The label for the first line of code.

;..............................................................................
;Constants stored in Program space
;..............................................................................

    .section .myconstbuffer, code
    .palign 2                ;Align next word stored in Program space to an
                                 ;address that is a multiple of 2
ps_coeff:
    .hword   0x0002, 0x0003, 0x0005, 0x000A

    /*POEMA:
    .word 0xFC4A, 0xCC42, 0x3381, 0xCC42, 0x3381, 0XC042, 0xCC24, 0x3F00, 0x3F00, 0XC042, 0xCC24,0xF318	,0xCF00,0x3318,0xCC42,0x0000					 

Bin in tzuutz a chi
Bin in tzuutz a chi
Tut yam x cohl
X ciichpam zac
Y an y an a u ahal
 
     ESPAÑOL  
     
Besaré tu boca
Besaré tu boca
entre las plantas de milpa,
belleza centelleante,
debes darte prisa.*/
    

;prueba1
;Y 211A
;P E318
/*
 POEMA:
.word 0xFC4A, 0xCC42, 0x3381, 0xCC42, 0x3381, 0xC042, 0xCC24, 0x3F00, 0x3F00, 0xC042, 0xCC24, 0xF318, 0xCF00, 0x3318, 0xCC42 
.word 0xFC4A, 0xCC42, 0x3381, 0xCC42, 0x3381, 0xC042, 0xCC24, 0x3F00, 0x3F00, 0xC042, 0xCC24, 0xF318, 0xCF00, 0x3318, 0xCC42
.word 0xC042, 0x3F00, 0xC042, 0x211A, 0xF318, 0x33A0, 0x00A5, 0xCF00, 0xFF00, 0x3318, 0x0F00
.word 0x00A5, 0xCF00,0xCC42, 0xCC42, 0xCF00, 0x3318, 0xE318, 0xF318, 0x33A0,0xCC24,0xF318,0xCF00
.word 0x211A, 0xF318, 0x3381, 0x211A, 0xF318, 0x3381, 0xF318, 0x3F00, 0xF318, 0x3318, 0xF318, 0x0F00, 0x0018
*/
    
POEMA:
.word 'A', 'B', 'C'


 
;........................................................................
;Uninitialized variables in X-space in data memory
;..............................................................................

    .section .xbss, bss, xmemory
x_input: .space 2*SAMPLES        ;Allocating space (in bytes) to variable.



;..............................................................................
;Uninitialized variables in Y-space in data memory
;..............................................................................

    .section .ybss, bss, ymemory
y_input:  .space 2*SAMPLES




;..............................................................................
;Uninitialized variables in Near data memory (Lower 8Kb of RAM)
;..............................................................................

    .section .nbss, bss, near
var1:     .space 2               ;Example of allocating 1 word of space for
                                 ;variable "var1".




;..............................................................................
;Code Section in Program Memory
;..............................................................................

.text                             ;Start of Code section
__reset:
    MOV #__SP_init, W15       ;Initalize the Stack Pointer
    MOV #__SPLIM_init, W0     ;Initialize the Stack Pointer Limit Register
    MOV W0, SPLIM
    NOP                       ;Add NOP to follow SPLIM initialization

    CALL _wreg_init           ;Call _wreg_init subroutine
                                  ;Optionally use RCALL instead of CALL




        ;<<insert more user code here>>
	
 ; Configuración de puertos
    SETM AD1PCFGL ; Configura todos los pines como digitales
    CLR TRISB        ; Configura PORTB como salida
    CLR PORTB        ; Inicializa PORTB en 0

    BRA Leer_Poema
/*
MENU:
    MOV #0, W5
    CP W5, #0
    BRA Z, Leer_Poema
*/
Leer_Poema:
    MOV #tblpage(POEMA), W0
    MOV W0, TBLPAG
    MOV #tbloffset(POEMA), W1

Ciclo_Poema:
    CLR W4                     ; Limpia W4 para recibir el dato
    TBLRDL [W1++], W4  ; Lee dato de la tabla en W4
    CP W4, #0x0018                ; compara
    BRA Z, END_DELAY                 ; Si es
    MOV W4, PORTB              ; Envía el dato al puerto para mostrarlo
    CALL Retardo               ; Espera antes de mostrar el siguiente dato
    BRA Ciclo_Poema            ; Repite para el siguiente dato
    
    
Retardo:    
    MOV	    #40000,	    W7
    LOOP1:
    CP0	    W7			;(1 Cycle)
    BRA	    Z,	    END_DELAY	;(1 Cycle if not jump)
    DEC	    W7,	    W7		;(1 Cycle)
    
    MOV	    #10,	    W8		;(1 Cycle)
    LOOP2:
    DEC	    W8,	    W8		;(1 Cycle)
    CP0	    W8			;(1 Cycle)
    BRA	    Z,	    LOOP1	;(1 Cycle if not jump)
    BRA	    LOOP2		;(2 Cycle if jump)
    
   END_DELAY:
    NOP
    return
    
;..............................................................................
;Subroutine: Initialization of W registers to 0x0000
;..............................................................................

_wreg_init:
    CLR W0
    MOV W0, W14
    REPEAT #12
    MOV W0, [++W14]
    CLR W14
    RETURN




;--------End of All Code Sections ---------------------------------------------

.end

