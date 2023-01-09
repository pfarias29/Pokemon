.data

posicao_imagem_mapa:	.word 0, 0		#porção que será mostrada do mapa
posicao_boneco_mapa:	.word 98, 120

boneco_parado_baixo:	.word 24, 36 		#guarda a posição do boneco na imagem de sprites
boneco_andando_baixo1:	.word 8, 36		#guarda a posição do boneco na imagem de sprites
boneco_andando_baixo2:	.word 40, 36		#guarda a posição do boneco na imagem de sprites

boneco_parado_esquerda:		.word 24, 100
boneco_andando_esquerda1:	.word 8, 100
boneco_andando_esquerda2:	.word 40, 100
tamanho_boneco:		.word 16, 20

.include "./Sprites/PalletTown.data"
.include "./Sprites/Personagens.data"

.text
		la a3, boneco_parado_baixo	#primeira imagem do boneco a ser printada
		
INICIO:
		
		li s0, 0xff0			#frame 0
		slli s0, s0, 20
		
		la a0, PalletTown
		lw a1, 0(a0)			#tamanho colunas
		lw a2, 4(a0)			#tamanho linhas
		addi a0, a0, 8
		
		la a4, posicao_imagem_mapa	#calcula onde vai começar a ser printado o mapa
		lw t0, 4(a4)
		mul t0, a1, t0
		add a0, a0, t0
		
		lw t0, 0(a4)
		add a0, a0, t0
		
		li t0, 0			#condição de parada colunas
		li t1, 0			#condição de parada linhas
		
LOOP_MAPA:
		lw t2, 0(a0)
		sw t2, 0(s0)
		
		addi a0, a0, 4
		addi s0, s0, 4
		addi t0, t0, 4
		
		li t2, 320
		bne t2, t0, LOOP_MAPA
		
		#se for igual, reinicia a linha
		mv t0, zero
		
		add a0, a0, a1
		addi a0, a0, -320		#volta a mesma coluna
		addi t1, t1, 1
		
		li t2, 240
		bne t2, t1, LOOP_MAPA
		
		#chegou ao final de printar o mapa
		
		
BONECO:
		li s0, 0xff0			#frame 0
		slli s0, s0, 20
		
		la a0, posicao_boneco_mapa	#calcula onde vai começar a ser printado o boneco
		lw t0, 0(a0)
		add s0, s0, t0
		
		lw t0, 4(a0)
		li t1, 320
		mul t0, t1, t0
		add s0, s0, t0			#posição na tela que o boneco será printado
		
		la a0, Personagens
		lw a1, 0(a0)			#tamanho colunas imagem de sprites
		lw a2, 4(a0)			#tamanho linhas imagem de sprites
		addi a0, a0, 8
		
		#la a3, boneco_parado_baixo	#calcula onde está o boneco a ser printado
		lw t0, 4(a3)
		mul t0, a1, t0
		add a0, a0, t0
		
		lw t0, 0(a3)
		add a0, a0, t0
		
		la a3, tamanho_boneco
		lw a4, 0(a3)			#tamanho linhas de um boneco
		lw a5, 4(a3)			#tamanho colunas de um boneco
		
		li t0, 0			#condição de parada colunas
		li t1, 0			#condição de parada linhas
		
BONECO_LOOP:
		lh t2, 0(a0)
		sh t2, 0(s0)
		
		addi a0, a0, 2
		addi s0, s0, 2
		addi t0, t0, 2
		
		bne a4, t0, BONECO_LOOP
		
		#se for igual, reinicia a linha
		mv t0, zero
		
		addi s0, s0, 320
		sub s0, s0, a4
						
		add a0, a0, a1
		sub a0, a0, a4			#volta a mesma coluna
		addi t1, t1, 1
		
		bne a5, t1, BONECO_LOOP
		
	
KEY2:	
		li t1,0xFF200000		# carrega o endereço de controle do KDMMIO
		lw t0,0(t1)			# Le bit de Controle Teclado
		andi t0,t0,0x0001		# mascara o bit menos significativo
   		beq t0,zero,FIM   	   	# Se não há tecla pressionada então vai para FIM
  		lw t2,4(t1)  			# le o valor da tecla tecla
		sw t2,12(t1)  			# escreve a tecla pressionada no display
		j MOVE_BONECO
FIM:		
		j KEY2				# retorna

MOVE_BONECO:
		li t0, 'a'
		beq t0, t2, MOVE_ESQUERDA
		
		li t0, 'd'
		beq t0, t2, MOVE_DIREITA
		
		li t0, 'w'
		#beq t0, t2, MOVE_CIMA
		
		li t0, 's'
		#beq t0, t2, MOVE_BAIXO
			
		j KEY2
		
MOVE_ESQUERDA:		
		la a0, posicao_imagem_mapa
		lw a1, 0(a0)					#tamanho colunas
		
		bgt a1, zero, MOVE_TELA_ESQUERDA		#É SÓ PRINTAR A TELA DE NOVO SEMPRE		

CHECA_POSICAO_BONECO_ESQUERDA:
		la a0, posicao_boneco_mapa
		lw a1, 0(a0)
		
		li t0, 36
		ble a1, t0, KEY2
		
		addi a1, a1, -2
		sw a1, 0(a0)
		
		la a3, boneco_andando_esquerda2
		j INICIO
		
MOVE_TELA_ESQUERDA:
		addi a1, a1, -2
		sw a1, 0(a0)
		j CHECA_POSICAO_BONECO_ESQUERDA		
		
MOVE_DIREITA:
		la a0, posicao_imagem_mapa
		lw a1, 0(a0)					#tamanho colunas
		
		li t0, 64
		blt a1, t0, MOVE_TELA_DIREITA			#É SÓ PRINTAR A TELA DE NOVO SEMPRE		
		
CHECA_POSICAO_BONECO_DIREITA:
		la a0, posicao_boneco_mapa
		lw a1, 0(a0)
		
		li t0, 350
		bge a1, t0, KEY2
		
		addi a1, a1, 2
		sw a1, 0(a0)
		
		la a3, boneco_andando_esquerda2
		j INICIO
		
MOVE_TELA_DIREITA:
		addi a1, a1, 2
		sw a1, 0(a0)
		j CHECA_POSICAO_BONECO_DIREITA		
		
		
		li a7, 10
		ecall