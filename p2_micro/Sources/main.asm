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
            
Entry:
            BSET DDRA,$06
            BCLR DDRA,$07
            BSET DDRB,$FF
VERIFICA            
            BRSET PORTA,$01,BOTAO1
            BRSET PORTA,$02,BOTAO2
            BRSET PORTA,$03,BOTAO3
            BRSET PORTA,$04,BOTAO4            
          
            BRA VERIFICA
            
            
BOTAO1:     BSET PORTA,$06

            ;contagem crescente em segundos no display

            ;só para com interrupção do botao 1
         
           
BOTAO2:

            RTS
            
BOTAO3: 

            RTS
            
BOTAO4:     BSET PORTA,$06
CONTINUA    NOP

            ;contagem crescente em segundos no display

            ;para se tiver interrupção do botao 1

            BRSET PORTA,$04,CONTINUA
            BCLR PORTA,$06

            RTS                                   


            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
