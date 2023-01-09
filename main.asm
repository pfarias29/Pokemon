.data
	.include "./Sprites/PokemonMenu.data"
	NUM: .word 330
	NOTAS: 74,1764,74,215,74,4,74,215,81,4,81,367,74,73,74,215,74,4,74,215,82,4,82,367,74,73,74,215,74,4,74,215,81,4,81,367,74,73,74,215,74,4,74,215,78,4,78,367,74,73,74,215,74,4,74,215,81,4,81,367,74,73,74,215,74,4,74,215,82,4,85,0,82,367,85,0,86,73,86,772,74,110,74,808,82,73,84,0,82,772,84,0,72,110,72,808,74,73,74,215,74,4,74,215,81,4,81,367,74,73,74,215,74,4,74,215,82,4,82,367,74,73,74,215,74,4,74,215,84,4,84,367,74,73,74,215,74,4,74,215,82,4,85,0,82,367,85,0,81,73,86,0,81,1691,86,0,98,73,98,367,67,845,67,105,71,4,71,160,74,4,74,160,78,4,78,105,69,1764,69,215,69,4,69,215,74,4,74,367,69,73,69,215,69,4,69,215,75,4,75,367,69,73,69,215,69,4,69,215,74,4,74,367,69,73,69,215,69,4,69,215,70,4,73,0,70,367,73,0,69,73,69,215,69,4,69,215,74,4,74,367,69,73,69,215,69,4,69,215,79,4,79,367,81,73,81,772,69,110,69,808,77,73,77,772,62,110,65,0,62,808,65,0,69,73,69,215,69,4,69,215,74,4,74,367,69,73,69,215,69,4,69,215,75,4,75,367,69,73,69,215,69,4,69,215,77,4,77,367,69,73,69,215,69,4,69,215,79,4,79,367,78,73,78,1691,62,73,62,367,86,2000

.text
# =================================================== # 
#							MENU				    		              #
# =================================================== # 
			la a0, PokemonMenu 		# label da sprite a ser impressa
			li a1, 0 					# pos em x
			li a2, 0 					# pos em y
			li a3, 0 					# frame
			jal Print 					# impressao no bitmap
	
			call PLAY_SONG

SONG_LOOP: j PLAY_SONG				# loop musica meu
.include "print.s"

# =================================================== # 
#		   				 MÚSICA  ABERTURA	 	   			      #
# =================================================== #
PLAY_SONG:	li a2, 3					# define o instrumento
			li a3, 127					# define o volume

			la s0, NUM				# define o endereco do numero de notas
			lw s1, 0(s0)				# le o numero de notas
			la s0, NOTAS				# define o endereco das notas
			li t0, 0					# zera o contador de notas
			li a2, 68					# define o instrumento
			li a3, 127					# define o volume
			j LOOP
			ret

LOOP: 		beq t0, s1, FIM				# contador chegou no final? entao  va para FIM
			lw a0, 0(s0)				# le o valor da nota
			lw a1, 4(s0)				# le a duracao da nota
			li a7, 31					# define a chamada de syscall
			ecall						# toca a nota

			mv a0, a1					# passa a duracao da nota para a pausa
			li a7, 32					# define a chamada de syscal 
			ecall						# realiza uma pausa de a0 ms

			addi s0, s0, 8				# incrementa para o endereco da proxima nota
			addi t0, t0, 1				# incrementa o contador de notas
			j LOOP					# volta ao loop
			ret
	
FIM:			li a0, 40					# define a nota
			li a1, 300					# define a duracao da nota em ms
			li a2, 127					# define o instrumento
			li a3, 127					# define o volume
			li a7, 33					# define o syscall
			ecall						# toca a nota
			ret
