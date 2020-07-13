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
            
BCD         DC.B $3F,$06,$5B,$4F,$66,$6D,$7D,$07,$7F,$67      ;valores BCD convertidos para mostrar no display de 0 a 9
DCB         DC.B $67,$7F,$07,$7D,$6D,$66,$4F,$5B,$06,$3F      ;valores BCD convertidos para mostrar no display de 9 a 0
CONTSEC     DS.B 1                                            ;contador 1
CONTMIN     DS.B 1                                            ;contador 2
DURACAO     DS.B 1                                            ;contador 3
            
Entry:      
                        
            BSET DDRE,$80                  ;define o bit 7 da PORTE como saída
            BCLR DDRE,$39                  ;define os bits 0,3,4 e 5 da PORTE como entrada
            BSET DDRB,$FF                  ;define todos os bits da PORTB como saída. Dígito 1 BCD
            BSET DDRA,$FF                  ;define todos os bits da PORTA como saída. Dígito 2 BCD
            
            CLI                            ;ativa interrupção
            
            LDS #RAMEnd+1                  ;inicializa stack pointer
            ANDCC #%10111111               ;habilita XIRQ no CCR
            
            
VERIFICA     
            BRCLR PORTE,$01,N1             ;verifica se o botao 1 está apertado
            BRCLR PORTE,$08,N2             ;verifica se o botao 2 está apertado
            BRCLR PORTE,$10,N3             ;verifica se o botao 3 está apertado                                            
            BRCLR PORTE,$20,N4             ;verifica se o botao 4 está apertado   
          
            BRA VERIFICA
  
            
N1          JSR BOTAO1                     ;importante notar que o botão 1 está conectado no pino XIRQ PE0
            BRA VERIFICA
            
N2          JSR BOTAO2
            BRA VERIFICA
                         
N3          JSR BOTAO3
            BRA VERIFICA
            
N4          JSR BOTAO4                     
            BRA VERIFICA 
            
 
 
 
            
BOTAO1:     BSET PORTE,$80                 ;liga o motor

            BSET CONTSEC,$0A               ;carrega contador de unidade de segundos para subrotina do display
            BSET CONTMIN,$09               ;carrega contador de dezena de segundos para subrotina do display
            JSR DISPLAYINC                 ;pula para subrotina de atualização de display
            
            BCLR PORTE,$80                 ;desliga motor
            BCLR PORTB,$FF                 ;apaga numero do display 0
            BCLR PORTA,$FF                 ;apaga numero do display 1
            RTS                            ;retornar para o polling
         
           
BOTAO2:     BSET PORTE,$80                 ;liga o motor
            LDX #DCB+4                     ;carrega a posição de memória referente ao numero 5
            LDY #DCB+7                     ;carrega a posição de memória referente ao numero 2
            BSET CONTSEC,$05               ;carrega contador de unidade de segundos para subrotina do display
            BSET CONTMIN,$03               ;carrega contador de dezena de segundos para subrotina do display
            
            BSET PORTE,$80                 ;liga o motor
            BSET DURACAO,$03               ;carrega contador que controla a alternancia de estado do motor
            JSR DISPLAYDEC                 ;pula para subrotina de atualização de display
            
            
            BCLR PORTE,$80                 ;desliga motor
            BCLR PORTB,$FF                 ;apaga numero do display 0
            BCLR PORTA,$FF                 ;apaga numero do display 1
            RTS                            ;retornar para o polling
            

BOTAO3      BSET PORTE,$80                 ;liga o motor
            LDX #DCB+9                     ;carrega a posição de memória referente ao numero 0
            LDY #DCB+3                     ;carrega a posição de memória referente ao numero 6
            BSET CONTSEC,$01               ;carrega contador de unidade de segundos para subrotina do display
            BSET CONTMIN,$07               ;carrega contador de dezena de segundos para subrotina do display
            
            BSET PORTE,$80                 ;liga o motor
            BSET DURACAO,$03               ;carrega contador que controla a alternancia de estado do motor
            JSR DISPLAYDEC                 ;pula para subrotina de atualização de display
                       
            BCLR PORTE,$80                 ;desliga motor
            BCLR PORTB,$FF                 ;apaga numero do display 0
            BCLR PORTA,$FF                 ;apaga numero do display 1
            RTS                            ;retornar para o polling
            

BOTAO4      BSET PORTE,$80                 ;liga o motor

            BSET CONTSEC,$0A               ;carrega contador de unidade de segundos para subrotina do display
            BSET CONTMIN,$09               ;carrega contador de dezena de segundos para subrotina do display
            JSR DISPLAYINC2                ;pula para subrotina de atualização de display
            BCLR PORTE,$80                 ;desliga motor

            BCLR PORTB,$FF                 ;apaga numero do display 0
            BCLR PORTA,$FF                 ;apaga numero do display 1
            RTS
            
            
            
            
;Subrotina 1 de Atualização de Display            
            
DISPLAYINC:
            LDX #BCD                       ;carrega a posição de memória referente ao numero 0
            LDY #BCD                       ;carrega a posição de memória referente ao numero 0
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            
LOOP        LDAA X
            STAA PORTB                     ;Atualiza display 0
            INX                            ;incrementa posição de memória do indexador X
            
            
            JSR DELAY1SEC                  ;delay 1 segundo
            
            
            
            DEC CONTSEC                    ;decrementa em 1 o contador 1
            
            BNE LOOP                       ;loop até contador 1 zerar
            
            BSET CONTSEC,$0A               ;reseta valor do contador 1 para 10
            LDX #BCD                       ;carrega a posição de memória referente ao numero 0
            LDAA X
            STAA PORTB                     ;Atualiza display 0
            INY                            ;incrementa posição de memória do indexador Y
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            DEC CONTMIN                    ;decrementa em 1 o contador 2
            BNE LOOP                       ;loop até contador 2 zerar
            
            RTS
            

;Subrotina 2 de Atualização de Display
            
DISPLAYINC2:
            LDX #BCD                       ;carrega a posição de memória referente ao numero 0
            LDY #BCD                       ;carrega a posição de memória referente ao numero 0
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            
LOOP2       BRCLR PORTE,$20,DESLIGA        ;verifica se botão 4 está desligado
            
            LDAA X
            STAA PORTB                     ;Atualiza display 0
            INX                            ;incrementa posição de memória do indexador X
            JSR DELAY1SEC                  ;delay 1 segundo            
            DEC CONTSEC                    ;decrementa em 1 o contador 1                
            BNE LOOP2                      ;loop até contador 1 zerar
            
            BSET CONTSEC,$0A               ;reseta valor do contador 1 para 10
            LDX #BCD                       ;carrega a posição de memória referente ao numero 0
            LDAA X
            STAA PORTB                     ;Atualiza display 0
            INY                            ;incrementa posição de memória do indexador Y
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            DEC CONTMIN                    ;decrementa em 1 o contador 2
            BNE LOOP2                      ;loop até contador 2 zerar
            
DESLIGA     RTS



;Subrotina 3 de Atualização de Display

DISPLAYDEC:
            
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            
LOOP3        LDAA X                        ;Atualiza display 0
            STAA PORTB                     ;incrementa posição de memória do indexador X
            INX
            
            
            JSR DELAY1SEC                  ;delay 1 segundo
            
            DEC DURACAO                    ;decrementa contador 3
            BRCLR DURACAO,$FF,TOGGLEMOTOR  ;verifica se o contador 3 está zerado, caso positivo pula para função TOGGLEMOTOR
SEGUE            
            DEC CONTSEC                    ;decrementa contador 1
            
            BNE LOOP3                      ;loop até contador 1 zerar
            
            BSET CONTSEC,$0A               ;reseta valor do contador 1 para 10
            LDX #DCB                       ;carrega a posição de memória referente ao numero 9
            LDAA X
            STAA PORTB                     ;Atualiza display 0
            INY                            ;incrementa posição de memória do indexador Y
            LDAB Y
            STAB PORTA                     ;Atualiza display 1
            DEC CONTMIN                    ;decrementa em 1 o contador 2
            BNE LOOP3                      ;loop até contador 2 zerar
            
            RTS
                                           ;função para alternar estado do motor entre ligado e desligado
TOGGLEMOTOR
            BSET DURACAO,$03               ;reseta contador 3
            LDAA PORTE
            EORA #$80                      
            STAA PORTE                     ;alterna estado do motor
            BRA SEGUE                      ;retorna para função de atualização do display
            
            
            
            
            
;Subrotina de Delay                      

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

HERE        BRCLR TFLG1,%00010000,HERE    ;Branch HERE se for zero. 
            BSET  TFLG1,%00010000         ;Seta o Bit4 para poder reiniciar a operação realizada pelo codigo
            
            PULD
            RTS
            
            
;-----------ISR for XIRQ
                                          
XIRQ_EDGE:  CLR CONTSEC                   ;zera contador 1 fazendo a atualização de display terminar e o motor desligar em qualquer função
            CLR CONTMIN                   ;zera contador 2 fazendo a atualização de display terminar e o motor desligar em qualquer função
            
            RTI                           
            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
                                                                   
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
            ORG   $FFF4
            DC.W  XIRQ_EDGE
