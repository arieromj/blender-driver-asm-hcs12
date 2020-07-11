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
DCB         DC.B $67,$7F,$07,$7D,$6D,$66,$4F,$5B,$06,$3F
CONTSEC     DS.B 1
CONTMIN     DS.B 1
DURACAO     DS.B 1
            
Entry:      
            ;BCLR PEAR,%00101100            ;configura pinos 2,3 e 5 como I/O general purpose
            ;BSET PEAR,%10010000            ;configura pinos 4 e 7 como I/O general purpose
            
            
            BSET DDRE,$80                  ;define o bit 7 da PORTE como saída
            BCLR DDRE,$3C                  ;define os bits 2,3,4 e 5 da PORTE como entrada
            BSET DDRB,$FF                  ;define todos os bits da PORTB como saída. Dígito 1 BCD
            BSET DDRA,$FF                  ;define todos os bits da PORTA como saída. Dígito 2 BCD
            
            CLI                            ;ativa interrupção
            
VERIFICA    JSR BOTAO2
            
     
            BRSET PORTE,$04,N1             ;verifica se o botao 1 está apertado
            BRCLR PORTE,$08,N2             ;verifica se o botao 2 está apertado
            BRCLR PORTE,$10,N3             ;verifica se o botao 3 está apertado
            BRCLR PORTE,$20,N4             ;verifica se o botao 4 está apertado   
          
            BRA VERIFICA
  
            
N1          JSR BOTAO1
            BRA VERIFICA
            
N2          JSR BOTAO2
            BRA VERIFICA
                         
N3          JSR BOTAO3
            BRA VERIFICA
            
N4          JSR BOTAO4
            BRA VERIFICA 
            
 
 
 
            
BOTAO1:      BSET PORTE,$80

INFINITO    BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC
            
            BRA INFINITO                  
         
           
BOTAO2:     LDX #DCB+5
            LDY #DCB+7
            BSET CONTSEC,$05 
            BSET CONTMIN,$03
            
            BSET PORTE,$80
            BSET DURACAO,$03
            JSR DISPLAYDEC
            
            

            BCLR PORTB,$FF
            BCLR PORTA,$FF
            RTS
            

BOTAO3 

            BCLR PORTB,$FF
            BCLR PORTA,$FF
            RTS
            

BOTAO4      BSET PORTE,$80

            BSET CONTSEC,$0A 
            BSET CONTMIN,$09
            JSR DISPLAYINC2
            BCLR PORTE,$80

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
            
            
            JSR DELAY1SEC          ;delay 1 segundo
            
            
            
            DEC CONTSEC
            
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
            
LOOP2       BRCLR PORTE,$20,DESLIGA
            
            LDAA X
            STAA PORTB
            INX
            DEC CONTSEC
            
            JSR DELAY1SEC          ;delay 1 segundo
            
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



DISPLAYDEC:
            
            LDAB Y
            STAB PORTA
            
LOOP3        LDAA X
            STAA PORTB
            INX
            
            
            ;JSR DELAY1SEC          ;delay 1 segundo
            
            DEC DURACAO
            BRCLR DURACAO,$FF,TOGGLEMOTOR
SEGUE            
            DEC CONTSEC
            
            BNE LOOP3
            
            BSET CONTSEC,$0A
            LDX #DCB
            LDAA X
            STAA PORTB
            INY
            LDAB Y
            STAB PORTA
            DEC CONTMIN
            BNE LOOP3
            
            RTS
            
TOGGLEMOTOR
            BSET DURACAO,$02
            BRCLR PORTE,$80,ON
            BRSET PORTE,$80,OFF
ON          BSET PORTE,$80
            BRA SEGUE
OFF         BCLR PORTE,$80
            BRA SEGUE
            
            
            
            
            
                       




DELAY1SEC:
            
            PSHD                          
            LDAA  #$80
            STAA  TSCR1                   ;Inicializa time system control 1
            LDAA  #$00
            STAA  TSCR2                   ;Inicializa time system control 2 com prescaler = 1
            
            BSET  TIOS,%00010000          ;Inicializa bit4 como output compare
            
            LDAA  #$01                    ;Indica a ação que quer que faça quando TCNT = TC4 (1=toggle, 2=clear, 3=set)
            STAA  TCTL1                                   
                                          
            LDD   TCNT                    ;Lê o free timer running
            
            ADDD  #2000
                               ; 
            STAA   TC4                     ;Delay de 1s

HERE        BRCLR TFLG1,%00010000,HERE   ;Branch HERE se for zero. 
            BSET  TFLG1,%00010000         ;Seta o Bit4 para poder reiniciar a operação realizada pelo codigo
            
            PULD
            RTS
            
            

            
            

            
                                  


            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
