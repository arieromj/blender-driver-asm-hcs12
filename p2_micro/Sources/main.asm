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
            BSET DDRE,$10                  ;define o bit 4 da PORTE como saída
            BCLR DDRE,$0F                  ;define os bits 0,1,2 e 3 da PORTE como entrada
            BSET DDRB,$FF                  ;define todos os bits da PORTB como saída. Dígito 1 BCD
            BSET DDRA,$FF                  ;define todos os bits da PORTA como saída. Dígito 2 BCD
            
VERIFICA    
            BCLR PORTE,$10
     
            BRSET PORTE,$01,N1             ;verifica se o botao 1 está apertado
            BRSET PORTE,$02,N2             ;verifica se o botao 2 está apertado
            BRSET PORTE,$04,N3             ;verifica se o botao 3 está apertado
            BRSET PORTE,$08,N4             ;verifica se o botao 4 está apertado   
          
            BRA VERIFICA
            
N1          JSR BOTAO1
            BRA VERIFICA
            
N2          JSR BOTAO2
            BRA VERIFICA
                         
N3          JSR BOTAO3
            BRA VERIFICA
            
N4          JSR BOTAO4
            BRA VERIFICA 
            
 
 
 
            
BOTAO1:      BSET PORTE,$10

INFINITO    BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC
            
            BRA INFINITO                  
         
           
BOTAO2:

            BCLR PORTB,$FF
            BCLR PORTA,$FF
            RTS
            

BOTAO3 

            BCLR PORTB,$FF
            BCLR PORTA,$FF
            RTS
            

BOTAO4      BSET PORTE,$10

            BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC2
            BCLR PORTE,$10

            BCLR PORTB,$FF
            BCLR PORTA,$FF
            RTS
            
            
            
            
            
            
DISPLAYINC:
            LDX #BCD
            LDY #BCD
            LDAB Y
            STAB PORTA
            
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
            STAB PORTA
            DEC CONTMIN
            BNE LOOP
            
            RTS
            
            
DISPLAYINC2:
            LDX #BCD
            LDY #BCD
            LDAB Y
            STAB PORTA
            
LOOP2       BRCLR PORTE,$08,DESLIGA
            
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
            STAB PORTA
            DEC CONTMIN
            BNE LOOP2
            
DESLIGA     RTS
            
                                  


            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
