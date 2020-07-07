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
            BSET DDRA,$06                  ;define o bit 3 da PORTA como saída
            BCLR DDRA,$07                  ;define os bits 0,1 e 2 da PORTA como entrada
            BSET DDRB,$FF                  ;define todos os bits da POTB como saída
VERIFICA            
            BRSET PORTA,$01,BOTAO1         ;verifica se o botao 1 está apertado
            BRSET PORTA,$02,BOTAO2         ;verifica se o botao 2 está apertado
            BRSET PORTA,$03,BOTAO3         ;verifica se o botao 3 está apertado
            BRSET PORTA,$04,BOTAO4         ;verifica se o botao 4 está apertado   
          
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
