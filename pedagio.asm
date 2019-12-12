;Jogo pegadio de bixos

Letra: var #1
Pontos: var #1
nVidasBixo: var #1		; Contem a quantidade de vidas restantes do bixo
nPontos: var #1				; Contem a quantidade de pontos
posBixo: var #1
posCarro: var #1		; Contem a posicao atual do Alien
posMoeda: var #1
flagMoeda: var #1

init:
	loadn R1, #3
	store nVidasBixo, R1

	loadn R0, #0			; Contador para os Mods	= 0
	store nPontos, R0


main:
	call ApagaTela
	loadn R1, #tela1Linha0	; Endereco onde comeca a primeira linha do cenario!!
	loadn R2, #2816  			; cor branca!
	call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
	
	jmp Loop_Inicio
		
	Loop_Inicio:
		call DigLetra 		; Le uma letra
		
		loadn r0, #' '		; Espera que a tecla 'space' seja digitada para iniciar o jogo
		load r1, Letra
		cmp r0, r1
		jne Loop_Inicio
		
	Cenario:
		call ApagaTela
		loadn R1, #tela2Linha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #1536  			; cor branca!
		call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
    
		loadn R1, #tela3Linha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #2816  			; cor branca!
		call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
    
		loadn R1, #tela4Linha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn R2, #0   			; cor branca!
		call ImprimeTela2   		;  Rotina de Impresao de Cenario na Tela Inteira
		
		call ImprimeUI
		
		loadn r0, #900
		store posBixo, r0
		
		loadn r0, #319
		store posCarro, r0
		
		loadn r0, #0
		store flagMoeda, r0
		
		loadn r0, #0 ;Contador para divisoes
		loadn r2, #0 ;Utilizado para operacao == 0 dos modulos
	
	MoveLoop:
		
		loadn r1, #5
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/10)==0
		ceq MoveBixo
		
		loadn r1, #8
		mod r1, r0, r1
		cmp r1, r2		; if (mod(c/30) == 0
		ceq MoveCarroDireita
		
		loadn r1, #19
		mod r1, r0, r1
		cmp r1, r2
		ceq DropaMoeda
		
		;alterar condicao de colisao do bixo com a moeda pra acertar mesmo apos desenhada
		;alterar formato do contador pra receber numeros maiores que 9
		;alterar script da moeda pra redesenhar cenario por onde passa
		
		call Delay
		inc r0 	;c++
		
		jmp MoveLoop
		
exit_game:
	
	halt
	
;********************************************************
;                  	     DigLetra
;********************************************************

DigLetra:	; Espera que uma tecla seja digitada e salva na variavel global "Letra"
	push r0
	push r1
	loadn r1, #255	; Se nao digitar nada vem 255

   DigLetra_Loop:
		inchar r0			; Le o teclado, se nada for digitado = 255
		cmp r0, r1			;compara r0 com 255
		jeq DigLetra_Loop	; Fica lendo ate' que digite uma tecla valida

	store Letra, r0			; Salva a tecla na variavel global "Letra"

	pop r1
	pop r0
	rts

;********************************************************
;                    IMPRIME USER INTERFACE
;********************************************************
ImprimeUI:
	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3
	
	load r0, nVidasBixo
	load r2, nPontos
	
	loadn r1, #48
	add r0, r0, r1
	loadn r1, #47
	outchar r0, r1 ; imprime o numero de vidas
	
	;Se os pontos > 100 && < 1000
	loadn r1, #100
	div r3, r2, r1
	loadn r1, #0
	cmp r3, r1
	jgr Points1000
	
	;Se os pontos > 10 && < 100
	loadn r1, #10
	div r3, r2, r1
	loadn r1, #0
	cmp r3, r1
	jgr Points100
	
	;Se os potos > 0 && < 10
	loadn r1, #10
	div r3, r2, r1
	loadn r1, #0
	cmp r3, r1
	jeq Points10
	
	jmp ImprimeUI_END
	
	Points10:
		loadn R1, #48
		add R2, R2, R1
		loadn R1, #75
		outchar R2, R1 ; imprime os pontos
		jmp ImprimeUI_END
		
	Points100:
		
		;10^1
		loadn r1, #10
		load r2, nPontos
		div r3, r2, r1
		loadn R1, #48
		add R2, R3, R1
		loadn R1, #75
		outchar R2, R1 ; imprime os pontos
		
		;10^0
		loadn r1, #10
		load r2, nPontos
		mod r3, r2, r1
		loadn R1, #48
		add R2, R3, R1
		loadn R1, #76
		outchar R2, R1 ; imprime os pontos
		jmp ImprimeUI_END
		
	Points1000:
		;10^2
		loadn r1, #100
		load r2, nPontos
		div r3, r2, r1
		loadn R1, #48
		add R2, R3, R1
		loadn R1, #75
		outchar R2, R1 ; imprime os pontos
		
		;10^1
		loadn r1, #100
		load r2, nPontos
		mod r3, r2, r1
		loadn R1, #48
		add R2, R3, R1
		loadn R1, #75
		outchar R2, R1 ; imprime os pontos
		
		;10^0
		loadn r1, #10
		load r2, nPontos
		mod r3, r2, r1
		loadn R1, #48
		add R2, R3, R1
		loadn R1, #76
		outchar R2, R1 ; imprime os pontos
		jmp ImprimeUI_END
	
	ImprimeUI_END:
		pop r3
		pop r2
		pop r1
		pop r0
		rts
	
;********************************************************
;                    MOVE BIXO
;********************************************************
MoveBixo:
	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	
	load r0, posBixo
	
	loadn r1, #0
	inchar r1			; Le o teclado, se nada for digitado = 255
	loadn r2, #'a'
	cmp r1, r2
	jeq MoveBixo_A
	
	loadn r2, #'d'
	cmp r1, r2
	jeq MoveBixo_D
		
	loadn r2, #'w'
	cmp r1, r2
	jeq MoveBixo_W
		
	loadn r2, #'s'
	cmp r1, r2
	jeq MoveBixo_S
	
	MoveBixo_Fim:
		pop r2
		pop r1
		pop r0
		rts
	
	MoveBixo_A: 
		loadn r1, #40
		loadn r2, #0
		mod r1, r0, r1
		cmp r1, r2
		jeq MoveBixo_Fim
		call MoveBixo_Apaga
		dec R0
		store posBixo, r0
		call MoveBixo_Desenha
		jmp MoveBixo_Fim
		
	
	MoveBixo_D:
		loadn r1, #40
		loadn r2, #39
		mod r1, r0, r1
		cmp r1, r2
		jeq MoveBixo_Fim
		call MoveBixo_Apaga
		inc R0
		store posBixo, r0
		call MoveBixo_Desenha
		jmp MoveBixo_Fim
	
	MoveBixo_W:
		loadn r1, #640
		loadn r2, #40
		cmp r0, r1
		jle MoveBixo_Fim
		call MoveBixo_Apaga
		sub r0, r0, r2
		store posBixo, r0
		call MoveBixo_Desenha
		jmp MoveBixo_Fim
		
	MoveBixo_S:
		loadn r1, #919
		cmp r0, r1
		jgr MoveBixo_Fim
		call MoveBixo_Apaga
		loadn r2, #40
		add r0, r0, r2
		store posBixo, r0
		call MoveBixo_Desenha
		jmp MoveBixo_Fim
		
	MoveBixo_Desenha:
		push r0
		push r1
		
		loadn R1, #'%'	; Bixo
		load R0, posBixo
		outchar R1, R0
	
		pop R1
		pop R0
		rts
	
	MoveBixo_Apaga:
		push r0
		push r1
		
		loadn R1, #' '
		load R0, posBixo
		outchar r1, r0
		
		pop R1
		pop R0
		rts


;********************************************************
;                MOVE CARRO PRA DIREITA
;********************************************************		
MoveCarroDireita:
	push r0
	push r1
	push r2
	
	load r0, posCarro ;pos na tela
	loadn r1, #360 ;pos final na tela
	loadn r2, #' '
	
	outchar r2, r0
	inc r0
	store posCarro, r0
	cmp r0, r1
	jle MoveCarroDireita_Desenha
	jmp MoveCarroDireita_Volta
	
	MoveCarroDireita_Fim:
		pop r2
		pop r1
		pop r0
		rts

	MoveCarroDireita_Desenha:
		push r0
		push r1
		push r2

		load r0, posCarro ;cor
		loadn r1, #1024
		loadn r2, #'#'
		
		add r2, r1, r2
		
		outchar r2, r0
		pop r2
		pop r1
		pop r0
		jmp MoveCarroDireita_Fim
		
		
		
	MoveCarroDireita_Volta:
		push r0
		
		loadn r0, #319
		store posCarro, r0
		
		pop r0
		jmp MoveCarroDireita_Fim


DropaMoeda:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #0
	load r1, flagMoeda
	cmp r0, r1
	ceq DropaMoeda_NovoTiro
	
	load r0, posMoeda
	loadn r2, #' '
	outchar r2, r0
	
	loadn r1, #40
	loadn r2, #14 ;Linha do tracejado
	div r3, r0, r1
	cmp r3, r2
	ceq DropaMoeda_ReplaceChar
	
	add r0, r1, r0
	store posMoeda, r0
	
	load r2, posBixo
	cmp r0, r2
	jeq ContadorPontos
	
	loadn r1, #960
	cmp r0, r1
	jle DropaMoeda_DesenhaMoeda
	loadn r1, #0
	store flagMoeda, r1
	
	loadn r1, #919
	cmp r0, r0
	jeg ContadorVidas
	
	
	DropaMoeda_Fim:
		pop r3
		pop r2
		pop r1
		pop r0
		rts
	
	DropaMoeda_NovoTiro:
		push r0
		push r1
		
		load r0, posCarro
		loadn r1, #40
		add r0, r1, r0
		
		store posMoeda, r0
		
		loadn r1, #1
		store flagMoeda, r1
		
		pop r1
		pop r0
		rts
	
	DropaMoeda_DesenhaMoeda:
		push r0
		push r1
		push r2
		
		load r0, posMoeda
		loadn r1, #'&'
		
		outchar r1, r0
		
		pop r2
		pop r1
		pop r0
		jmp DropaMoeda_Fim
		
	DropaMoeda_ReplaceChar:
		push r0
		push r1
		
		load r0, posMoeda
		loadn r1, #'-'
		outchar r1, r0

		pop r1
		pop r0
		rts
			
ContadorPontos:
	push r0
	push r1
	
	load r0, nPontos
	inc r0
	store nPontos, r0
	call ImprimeUI
	
	loadn r1, #0
	store flagMoeda, r1
	
	pop r1
	pop r0
	jmp DropaMoeda_Fim
	
ContadorVidas:
	push r0
	push r1
	
	load r0, nVidasBixo
	dec r0
	store nVidasBixo, r0
	call ImprimeUI
	
	loadn r1, #0
	store flagMoeda, r1
	
	pop r1
	pop r0
	jmp DropaMoeda_Fim
	
;********************************************************
;                       DELAY
;********************************************************		


Delay:
						;Utiliza Push e Pop para nao afetar os Ristradores do programa principal
	Push R0
	Push R1
	
	Loadn R1, #12; a
   Delay_volta2:				;Quebrou o contador acima em duas partes (dois loops de decremento)
	Loadn R0, #5000	; b
   Delay_volta: 
	Dec R0					; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
	JNZ Delay_volta	
	Dec R1
	JNZ Delay_volta2
	
	Pop R1
	Pop R0
	
	RTS							;return

;-------------------------------
	
;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;---------------------------	
;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6			; Incrementa o ponteiro da String da Tela 0
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
	
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts
	
; Declara uma tela vazia que acomodará na memória os elementos contidos nas outras telas 

tela0Linha0  : string "                                        "
tela0Linha1  : string "                                        "
tela0Linha2  : string "                                        "
tela0Linha3  : string "                                        "
tela0Linha4  : string "                                        "
tela0Linha5  : string "                                        "
tela0Linha6  : string "                                        "
tela0Linha7  : string "                                        "
tela0Linha8  : string "                                        "
tela0Linha9  : string "                                        "
tela0Linha10 : string "                                        "
tela0Linha11 : string "                                        "
tela0Linha12 : string "                                        "
tela0Linha13 : string "                                        "
tela0Linha14 : string "                                        "
tela0Linha15 : string "                                        "
tela0Linha16 : string "                                        "
tela0Linha17 : string "                                        "
tela0Linha18 : string "                                        "
tela0Linha19 : string "                                        "
tela0Linha20 : string "                                        "
tela0Linha21 : string "                                        "
tela0Linha22 : string "                                        "
tela0Linha23 : string "                                        "
tela0Linha24 : string "                                        "
tela0Linha25 : string "                                        "
tela0Linha26 : string "                                        "
tela0Linha27 : string "                                        "
tela0Linha28 : string "                                        "
tela0Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres):
tela1Linha0  : string "                                        "
tela1Linha1  : string "                                        "
tela1Linha2  : string "  _____         _             _         "
tela1Linha3  : string " |  __ \\       | |           (_)        "
tela1Linha4  : string " | |__) |__  __| | __ _  __ _ _  ___    "
tela1Linha5  : string " |  ___/ _ \\/ _` |/ _` |/ _` | |/ _ \\   "
tela1Linha6  : string " | |  |  __/ (_| | (_| | (_| | | (_) |  "
tela1Linha7  : string " |_|   \\___|\\__,_|\\__,_|\\__, |_|\\___/   "
tela1Linha8  : string "                         __/ |          "
tela1Linha9  : string "                        |___/           "
tela1Linha10 : string "                   _                    "
tela1Linha11 : string "                  | |                   "
tela1Linha12 : string "                __| | ___               "
tela1Linha13 : string "               / _` |/ _ \\              "
tela1Linha14 : string "              | (_| | (_) |             "
tela1Linha15 : string "               \\__,_|\\___/              "
tela1Linha16 : string "        ____  _                         "
tela1Linha17 : string "       |  _ \\(_)                        "
tela1Linha18 : string "       | |_) |___  ____ _  ___          "
tela1Linha19 : string "       |  _ <| \\ \\/ / _` |/ _ \\         "
tela1Linha20 : string "       | |_) | |>  < (_| | (_) |        "
tela1Linha21 : string "       |____/|_/_/\\_\\__,_|\\___/         "
tela1Linha22 : string "                                        "
tela1Linha23 : string "                                        "
tela1Linha24 : string "      Aperte espaco para iniciar        "
tela1Linha25 : string "                                        "
tela1Linha26 : string "                                        "
tela1Linha27 : string "                                        "
tela1Linha28 : string "                                        "
tela1Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres):
tela2Linha0  : string "                                        "
tela2Linha1  : string "          PEDAGIO DO BIXAO              "
tela2Linha2  : string "                                        "
tela2Linha3  : string "                                        "
tela2Linha4  : string "                                        "
tela2Linha5  : string "                                        "
tela2Linha6  : string "                                        "
tela2Linha7  : string "                                        "
tela2Linha8  : string "                                        "
tela2Linha9  : string "                                        "
tela2Linha10 : string "                                        "
tela2Linha11 : string "                                        "
tela2Linha12 : string "                                        "
tela2Linha13 : string "                                        "
tela2Linha14 : string "                                        "
tela2Linha15 : string "                                        "
tela2Linha16 : string "                                        "
tela2Linha17 : string "                                        "
tela2Linha18 : string "                                        "
tela2Linha19 : string "                                        "
tela2Linha20 : string "                                        "
tela2Linha21 : string "                                        "
tela2Linha22 : string "                                        "
tela2Linha23 : string "                                        "
tela2Linha24 : string "                                        "
tela2Linha25 : string "                                        "
tela2Linha26 : string "                                        "
tela2Linha27 : string "                                        "
tela2Linha28 : string "                                        "
tela2Linha29 : string "                                        "

tela3Linha0  : string "========================================"
tela3Linha1  : string "|VIDA:  |                  |PONTOS:    |"
tela3Linha2  : string "========================================"
tela3Linha3  : string "                                        "
tela3Linha4  : string "                                        "
tela3Linha5  : string "                                        "
tela3Linha6  : string "                                        "
tela3Linha7  : string "                                        "
tela3Linha8  : string "                                        "
tela3Linha9  : string "                                        "
tela3Linha10 : string "                                        "
tela3Linha11 : string "                                        "
tela3Linha12 : string "                                        "
tela3Linha13 : string "                                        "
tela3Linha14 : string "                                        "
tela3Linha15 : string "                                        "
tela3Linha16 : string "                                        "
tela3Linha17 : string "                                        "
tela3Linha18 : string "                                        "
tela3Linha19 : string "                                        "
tela3Linha20 : string "                                        "
tela3Linha21 : string "                                        "
tela3Linha22 : string "                                        "
tela3Linha23 : string "                                        "
tela3Linha24 : string "                                        "
tela3Linha25 : string "                                        "
tela3Linha26 : string "                                        "
tela3Linha27 : string "                                        "
tela3Linha28 : string "                                        "
tela3Linha29 : string "                                        "

; Declara e preenche tela linha por linha (40 caracteres):
tela4Linha0  : string "                                        "
tela4Linha1  : string "                                        "
tela4Linha2  : string "                                        "
tela4Linha3  : string "|                                      |"
tela4Linha4  : string "|                                      |"
tela4Linha5  : string "|======================================|"
tela4Linha6  : string "                                        "
tela4Linha7  : string "                                        "
tela4Linha8  : string "                                        "
tela4Linha9  : string "                                        "
tela4Linha10 : string "                                        "
tela4Linha11 : string "                                        "
tela4Linha12 : string "                                        "
tela4Linha13 : string "                                        "
tela4Linha14 : string "----------------------------------------"
tela4Linha15 : string "                                        "
tela4Linha16 : string "                                        "
tela4Linha17 : string "                                        "
tela4Linha18 : string "                                        "
tela4Linha19 : string "                                        "
tela4Linha20 : string "                                        "
tela4Linha21 : string "                                        "
tela4Linha22 : string "                                        "
tela4Linha23 : string "                                        "
tela4Linha24 : string "========================================"
tela4Linha25 : string "|                                      |"
tela4Linha26 : string "|                                      |"
tela4Linha27 : string "|                                      |"
tela4Linha28 : string "|                                      |"
tela4Linha29 : string "|                                      |"