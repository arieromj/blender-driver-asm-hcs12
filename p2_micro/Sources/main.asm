;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point

            INCLUDE MC9S12C128.inc


            ORG $1000
            
BCD         DC.B $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$67
CONTSEC     DS.B 1
CONTMIN     DS.B 1
            
Entry:      
            BSET DDRA,$10                  ;define o bit 4 da PORTA como saída
            BSET DDRA,$0F                  ;define os bits 0,1,2 e 3 da PORTA como entrada
            BSET DDRB,$FF                  ;define todos os bits da PORTB como saída. Dígito 1 BCD
            BSET DDRE,$FF                  ;define todos os bits da PORTE como saída. Dígito 2 BCD
            
VERIFICA    BSET PORTA,$08
            BCLR PORTA,$10
     
            BRSET PORTA,$01,N1             ;verifica se o botao 1 está apertado
            BRSET PORTA,$02,N2             ;verifica se o botao 2 está apertado
            BRSET PORTA,$04,N3             ;verifica se o botao 3 está apertado
            BRSET PORTA,$08,N4             ;verifica se o botao 4 está apertado   
          
            BRA VERIFICA
            
N1          JSR BOTAO1
            BRA VERIFICA
N2          JSR BOTAO2
            BRA VERIFICA             
N3          JSR BOTAO3
            BRA VERIFICA
N4          JSR BOTAO4
            BRA VERIFICA 
 
 
 
            
BOTAO1:      BSET PORTA,$10

INFINITO    BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC
            
            BRA INFINITO                  
         
           
BOTAO2:

            RTS
            

BOTAO3 

            RTS
            

BOTAO4      BSET PORTA,$10

            BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC2
            BCLR PORTA,$10

            RTS
            
            
            
            
            
            
DISPLAYINC:
            LDX #BCD
            LDY #BCD
            LDAB Y
            STAB PORTE
            
LOOP        LDAA X
            STAA PORTB
            INX
            DEC CONTSEC
            ;delay 1 segundo
            BNE LOOP
            
            BSET CONTSEC,$0A
            LDX #BCD
            LDAA X
            STAA PORTB
            INY
            LDAB Y
            STAB PORTE
            DEC CONTMIN
            BNE LOOP
            
            RTS
            
            
DISPLAYINC2:
            LDX #BCD
            LDY #BCD
            LDAB Y
            STAB PORTE
            
LOOP2       BRCLR PORTA,$08,DESLIGA
            
            LDAA X
            STAA PORTB
            INX
            DEC CONTSEC
            ;delay 1 segundo
            BNE LOOP2
            
            BSET CONTSEC,$0A
            LDX #BCD
            LDAA X
            STAA PORTB
            INY
            LDAB Y
            STAB PORTE
            DEC CONTMIN
            BNE LOOP2
            
DESLIGA     RTS
            
                                  


            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
