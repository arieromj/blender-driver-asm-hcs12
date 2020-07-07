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
            BSET DDRA,$04
            BCLR DDRA,$03
            BSET DDRB,$FF
VERIFICA            
            BRSET PORTB,$01,BOTAO1
            BRSET PORTB,$02,BOTAO2
            BRSET PORTB,$03,BOTAO3
            BRSET PORTB,$04,BOTAO4            
          
            BRA VERIFICA
            
            
BOTAO1:     
         
            RTS
           
BOTAO2:

            RTS
            
BOTAO3: 

            RTS
            
BOTAO4: 

            RTS                                   

            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
