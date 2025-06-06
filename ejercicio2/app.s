.equ SCREEN_WIDTH, 		640
		.equ SCREEN_HEIGH, 		480
		.equ BITS_PER_PIXEL,  	32
	
		.equ GPIO_BASE,      0x3f200000
		.equ GPIO_GPFSEL0,   0x00
		.equ GPIO_GPLEV0,    0x34
	
		.globl main
	
	main:
			// x0 contiene la direccion base del framebuffer
			mov x20, x0	// Guarda la dirección base del framebuffer en x20
		// Inicializo las posiciones del sol	
			mov x27,80 // centro y del sol
			mov x29,80 // centro x del sol
			mov x23, 410
		    mov x24, 70
	//----------------------------Datos de cielo----------------------------
		movz w10, 0x90, lsl 16		// defino color
		movk w10, 0xD6F5, lsl 00	// completo color
		mov x2, 220   // Solo borro el cielo (la parte superior)
	cielo1:
		mov x1, SCREEN_WIDTH         // tamaño x
	cielo0:
		str w10,[x0]		// colorear el pixel N
		add x0,x0,4		// siguiente pixel
		sub x1,x1,1		// decrementar contador X
		cbnz x1,cielo0		// si no terminó la fila, salto
		sub x2,x2,1		// decrementar contador Y
		cbnz x2,cielo1		// si no es la última fila, salto
	//----------------------------Datos de nubes----------------------------
		mov x10, 2		// cantidad nubes
		mov x1, 280		// centro x
		mov x2, 80		// centro y
		mov x13, 30		// radio

	
	nube:
		mov x14, SCREEN_WIDTH	// x14 = 640
		sub x15, x14, x2	// x15 = 640 - x2
		mov x14, 4		// x14 = 4
		mul x15, x15, x14	// x15 = (640 - x2) * 4
		movz w7, 0xEF, lsl 16		// defino color
		movk w7, 0xEFEF, lsl 00		// completo color
		mov x11, x1		// centro x
		mov x12, x2		// centro y
		bl circulo		// dibuja parte profunda de la nube
		movz w7, 0xF5, lsl 16		// defino color
		movk w7, 0xF5F5, lsl 00		// completo color
		sub x11, x11, 40	// centro x
		bl circulo		// dibuja parte media de la nube
		add x11, x11, 40	// centro x
		sub x12, x12, 20	// centro y
		bl circulo		// dibuja parte media de la nube
		add x11, x11, 40	// centro x
		add x12, x12, 20	// centro y
		bl circulo		// dibuja parte media de la nube 
		movz w7, 0xFF, lsl 16		// defino color
		movk w7, 0xFFFF, lsl 00		// completo color
		sub x11, x11, 120	// centro x
		bl circulo		// dibuja parte frontal de la nube
		add x11, x11, 40	// centro x
		sub x12, x12, 20	// centro y
		bl circulo		// dibuja parte frontal de la nube
		add x11, x11, 40	// centro x
		sub x12, x12, 10	// centro y
		bl circulo		// dibuja parte frontal de la nube
		add x11, x11, 40	// centro x
		add x12, x12, 10	// centro y
		bl circulo		// dibuja parte frontal de la nube
		add x11, x11, 40	// centro x
		add x12, x12, 20	// centro y
		bl circulo		// dibuja parte frontal de la nube

		add x1, x1, 240		// cambio la posición en x de la nube
		subs x10, x10, 1	// descuento cantidad de nubes
		cbnz x10, nube		// repito proceso si me quedan nubes por dibujar

    //-----------------DATOS DE MAR-------------------------------
		mov x0, x20		// vuelvo a direccion base del framebuffer
		movz w10, 0x3F, lsl 16		// defino el color
		movk w10, 0xA1CB, lsl 00	// completo color
		mov x3, 220		// posición y
		mov x8, SCREEN_WIDTH	// x8 = 640
		mul x3, x3, x8		// x3 = 300 * 640
		mov x4, 0		// x4 = 0
		add x3, x3, x4		// x3 = (300 * 640) + 0
		lsl x3, x3, 2		// x3 = (300 * 640) * 4
		add x0, x20, x3		// x0 = x0 + (300 * 640) * 4
		mov x2, SCREEN_HEIGH	// x2 = 480
	mar1:
		mov x1, SCREEN_WIDTH	// x1 = 640
	mar0:
		str w10, [x0]		// Colorear el pixel N
		add x0, x0, 4		// Siguiente pixel
		sub x1, x1, 1		// Decrementar contador X
		cbnz x1, mar0		// Si no terminó la fila, salto
		sub x2, x2, 1		// Drementar contador Y
		subs xzr, x2, 380	// FLAGS = x2 - 380
		b.hi mar1		// comprueba si x2 > 380

	//----------------------------Datos de arena----------------------------
		// Base arena
		mov x0, x20		// vuelvo a direccion base del framebuffer
		mov x3,320		// x3 = 320, es decir, y = 320
	    	mov x8,SCREEN_WIDTH	// x8 = 640
	    	mul x3,x3,x8		// x3 = 320 * 640
		mov x4,0		// x4 = 0, es decir, x = 0
	    	add x3, x3, x4		// x3 = (300 * 640) + 0
	    	lsl x3, x3, 2		// x3 = (300 * 640) * 4
		    	add x0, x20, x3		// x0 = x0 + (300 * 640) * 4
		movz w10, 0xF2, lsl 16		// defino el color
		movk w10, 0xCE9E, lsl 00	// completo color
		mov x2, SCREEN_HEIGH	// x2 = 480
	arena1:
		mov x1, SCREEN_WIDTH	// x1 = 640
	arena0:
		str w10,[x0]		// Colorear el pixel N
		add x0,x0,4		// Siguiente pixel
		sub x1,x1,1		// Decrementar contador X
		cbnz x1,arena0		// Si no terminó la fila, salto
		sub x2,x2,1		// Drementar contador Y
		subs xzr, x2, 200	// FLAGS = x2 - 380
		b.hi arena1		// comprueba si x2 > 380
	arena3:
		mov x1, SCREEN_WIDTH	// x1 = 640
	arena2:
		str w10,[x0]		// Colorear el pixel N
		add x0,x0,108		// Siguiente pixel
		sub x1,x1,1		// Decrementar contador X
		cbnz x1,arena2		// Si no terminó la fila, salto
		sub x2,x2,1		// Drementar contador Y
		subs xzr, x2, 200	// FLAGS = x2 - 380
		b.hi arena3		// comprueba si x2 > 380

//----------------------------Datos de efecto orilla----------------------------
		// Orilla azul
		movz w7, 0x26, lsl 16		// defino el color
		movk w7, 0x7EA4, lsl 00		// completo color
		mov x1,4		// x1 = 4 (ancho del cuadrado)
		mov x2,135		// x2 = 135 (largo del cuadrado)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)

		mov x3,293		// x3 = 293 (posición y)
		mov x4,0		// x4 = 0 (posición x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		mov x3,290		// x3 = 300 (posición y)
		mov x4,128		// x4 = 100 (posición x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		mov x3,293		// x3 = 300 (posición y)
		mov x4,256		// x4 = 100 (posición x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		mov x3,290		// x3 = 300 (posición y)
		mov x4,383		// x4 = 100 (posición x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		mov x3,293		// x3 = 300 (posición y)
		mov x4,512		// x4 = 100 (posición x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		// Orilla blanca
		movz w7, 0xFF, lsl 16		// defino el color
		movk w7, 0xFFFF, lsl 00		// completo color
		mov x1,15		// x1 = 110 (ancho del cuadrado)
		mov x2,180		// x2 = 150 (largo del cuadrado)
		mov x3,320		// x3 = 300 (posición y)
		mov x4,0		// x4 = 100 (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		mov x3,316		// x3 = 300 (posición y)
		mov x4,180		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca principal

		mov x3,320		// x3 = 300 (posición y)
		mov x4,360		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca principal

		mov x3,316		// x3 = 300 (posición y)
		mov x4,480		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca principal

		movz w7, 0xF5, lsl 16		// defino el color
		movk w7, 0xF5F5, lsl 00		// completo color
		mov x3,306		// x3 = 300 (posición y)
		mov x4,0		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca secundaria

		mov x3,302		// x3 = 300 (posición y)
		mov x4,180		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca secundaria

		mov x3,306		// x3 = 300 (posición y)
		mov x4,360		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca secundaria

		mov x3,302		// x3 = 300 (posición y)
		mov x4,480		// x4 = 100 (posición x)
		bl cuadrado		// dibujo orilla blanca secundaria
		
	//----------------------------Datos de ODC----------------------------
	
		
		movz w7, 0x9C, lsl 16		// defino color
		movk w7, 0x9C9C, lsl 00		// completo color
		
		
	    // o piedra
		mov x11, 480		// centro x
 	   	mov x12, 400		// centro y
 	   	mov x13, 10       // radio
		bl circulo		// dibujo piedra
 	   	add x12, x12,5		// centro y
		bl circulo		// dibujo piedra

		// d piedra
		mov x11, 499		// centro x
  	  	mov x12, 407		// centro y
  	  	mov x13, 7		// radio
		bl circulo		// dibujo piedra
		mov x1,20		// x1 = 20 (ancho del cuadrado)
		mov x2,5		// x2 = 5 (largo del cuadrado)
		mov x3,390		// x3 = (posición y)
		mov x4,501		// x4 =  (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo piedra

		// C piedra
		mov x11, 519		// centro x
 	   	mov x12, 400		// centro y
 	   	mov x13, 10		// radio
		bl circulo		// dibujo piedra
 	   	add x12, x12,5		// centro y
		bl circulo		// dibujo piedra

	// 2 piedra
		mov x10, 2		// cantidad piedras
		mov x4,445		// x4 =  (posición x)
	piedra:
		mov x1,25		// x1 = 25 (ancho del cuadrado)
		mov x2,20		// x2 = 20 (largo del cuadrado)
		mov x3,418		// x3 =  (posición y)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo piedra
		add x4,x4,54		// cambio la posición en x de la piedra
		subs x10,x10,1		// descuento cantidad de piedras
		cbnz x10,piedra		// repito proceso si me quedan piedras por dibujar

		// 0 piedra
		mov x11, 481		// centro x
 	   	mov x12, 427		// centro y
 	   	mov x13, 10		// radio
		bl circulo		// dibujo piedra
 	   	add x12, x12,6		// centro y
		bl circulo		// dibujo piedra

		//5
		mov x1,25		// x1 = 25 (ancho del cuadrado)
		mov x2,20		// x2 = 20 (largo del cuadrado)
		mov x3,418		// x3 =  (posición y)
		mov x4,525		// x4 = (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo cuadrado y vuelvo

		movz w7, 0xF2, lsl 16		// defino color
		movk w7, 0xCE9E, lsl 00		// completo color

		// O arena
		mov x11,480		// centro x
 	   	mov x12,400		// centro y
 	   	mov x13,5		// radio
		bl circulo		// dibujo arena
 	   	add x12,x12,5		// centro y
		bl circulo		// dibujo arena

		// d arena
		mov x11, 499		// centro x
 	   	mov x12, 407		// centro y
 	   	mov x13, 4		// radio
		bl circulo		// dibujo arena

		// C arena
		mov x11,519		// centro x
 	   	mov x12,400		// centro y
 	   	mov x13,4		// radio
		bl circulo		// dibujo arena
 	   	add x12,x12,5		// centro y
		bl circulo		// dibujo arena
		mov x1,6		// x1 = 6 (ancho del cuadrado)
		mov x2,14		// x2 = 14 (largo del cuadrado)
		mov x3,400		// x3 =  (posición y)
		mov x4,520		// x4 =  (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo arena

	// 2 arena
		mov x10, 2		// cantidad arena
		mov x1,7		// x1 = 7 (ancho del cuadrado)
		mov x2,11		// x2 = 11 (largo del cuadrado)
		mov x3,421		// x3 =  (posición y)
		mov x4,445		// x4 =  (posición x)
	arena_de_piedra0:
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo arena
		mov x3,433		// x3 =  (posición y)
		mov x4,455		// x4 = (posición x)
		subs x10,x10,1		// descuento cantidad de arena
		cbnz x10,arena_de_piedra0		// repito proceso si me quedan arena por dibujar

		// O arena
		mov x11,481		// centro x
	    mov x12,427		// centro y
	    mov x13,6		// radio
		bl circulo		// dibujo arena
	    add x12,x12,6		// centro y
		bl circulo		// dibujo arena

		// 2 arena
		mov x10, 2		// cantidad arena
		mov x3,421		// x3 = (posición y)
		mov x4,498		// x4 = (posición x)
	arena_de_piedra1:
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo arena
		mov x3,432		// x3 = (posición y)
		mov x4,508		// x4 = (posición x)
		subs x10,x10,1		// descuento cantidad de arena
		cbnz x10,arena_de_piedra1	// repito proceso si me quedan arena por dibujar

		// 5 arena
		mov x3,421		// x3 = (posición y)
		mov x4,534		// x4 = (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo arena
		mov x1,7		// x1 = 7
		mov x2,11		// x2 = 11
		mov x3,433		// x3 = (posición y)
		mov x4,525		// x4 = (posición x)
		bl cuadrado		// dibujo arena
		
	loop_animacion:
		// Restauro x0 al inicio del framebuffer para redibujar todo
		mov x0, x20
    //-----DIBUJO SOL--------------------//
    	mov x11, x29         // Centro X del sol
    	mov x12, x27       // Centro Y del sol
    	mov x13, 50        // Radio 
   		bl borrar_y_dibujar_sol_cangrejo
		
    skip_volver: //etiqueta para volver despues de hacer la funcion

	//-------------ANIMACION SOL Y CANGREJO-----------------------
    	add x29, x29, 1    // incremento la posicion X del sol
		add x27, x27, 1    // Incremento la posicion Y del sol	    
		add x24, x24, 1    // incremento la posicion X del cangrejo
		sub x23, x23, 1    // Incremento la posicion Y del cangrejo
    	cmp x27, 260       // hasta donde el sol se esconde
		b.ge end_anim     // Si x27 >= 260 termina mi animacion
    	movk x28, 0x00DF, lsl 16  // velocidad en la que baja el sol	
	
   
    delay_loop:
    	subs x28, x28, 1 // le resta 1 a x28, si el resultado es 0 establece la bandera de cero 
    	cbnz x28, delay_loop // si la bandera no esta activada, salta a delay_loop
    	b loop_animacion       // Vuelve al inicio del bucle para volver a dibujar/borrar

    end_anim:
    	mov x0, 0 //genero un retorno en x0
        ret

borrar_y_dibujar_sol_cangrejo:
	
	
	//efecto cielo 
	movz w7,0x11, lsl 16		// defino el color
	movk w7, 0x1222, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,155	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado		// dibujo parte mas clara del mar

	
	//efecto cielo 
	movz w7,0x17, lsl 16		// defino el color
	movk w7, 0x252D, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,150	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado

	//efecto cielo 
	movz w7,0x1D, lsl 16		// defino el color
	movk w7, 0x2A37, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,145	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	//efecto cielo 
	movz w7,0x23, lsl 16		// defino el color
	movk w7, 0x3041, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,140	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	//efecto cielo 
	movz w7,0x29, lsl 16		// defino el color
	movk w7, 0x364B, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,135 // x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 
	

	//efecto cielo 
	movz w7,0x2F, lsl 16		// defino el color
	movk w7, 0x3C56, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,130	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 


        //efecto cielo 
	movz w7,0x35, lsl 16		// defino el color
	movk w7, 0x4260, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,125	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	//efecto cielo 
	movz w7,0x3B, lsl 16		// defino el color
	movk w7, 0x486A, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,120	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

		//efecto cielo 
	movz w7,0x41, lsl 16		// defino el color
	movk w7, 0x5E75, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,115	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 
	
		//efecto cielo 
	movz w7,0x47, lsl 16		// defino el color
	movk w7, 0x6580, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,110	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 


		//efecto cielo 
	movz w7,0x4D, lsl 16		// defino el color
	movk w7, 0x6B8A, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,105	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	//efecto cielo 
	movz w7,0x53, lsl 16		// defino el color
	movk w7, 0x7194, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,100	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

        //efecto cielo 
	movz w7,0x59, lsl 16		// defino el color
	movk w7, 0x779E, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,95	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	 //efecto cielo 
	movz w7,0x5F, lsl 16		// defino el color
	movk w7, 0x7DA9, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,90	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 
	
	//efecto cielo 
	movz w7,0x65, lsl 16		// defino el color
	movk w7, 0x93B3, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,85	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 
	
	//efecto cielo 
	movz w7,0x6B, lsl 16		// defino el color
	movk w7, 0x99BD, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,80	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 
	

	//efecto cielo 
	movz w7,0x71, lsl 16		// defino el color
	movk w7, 0xA0C8, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,75	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	//efecto cielo 
	movz w7,0x77, lsl 16		// defino el color
	movk w7, 0xA6D2, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,70	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 


	//efecto cielo 
	movz w7,0x7D, lsl 16		// defino el color
	movk w7, 0xADD7, lsl 00		// completo color
	mov x1,25 	// x1 = 42 (ancho del cuadrado)
	mov x2,SCREEN_WIDTH	   // x2 = 42 (largo del cuadrado)
	sub x3,X27,64	// x3 = 220 (posicion y)
	mov x4,320	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado 

	
	//borro cielo
    movz w7, 0x90, lsl 16    // Color del cielo
    movk w7, 0xD6F5, lsl 00   // Pinto el color del cielo
    mov x13, 42              // Radio de lo que borro
    bl circulo
	//dibujo sol
    movz w7, 0xF7, lsl 16    // Color del borde
    movk w7, 0x9E19, lsl 00
    mov x13, 40           // Radio del borde
    bl circulo
	movz w7, 0xFF, lsl 16    // Color del nucleo
    movk w7, 0xDA1B, lsl 00
    mov x13, 37              // Radio del nucleo
    bl circulo
	
	//borro arena
	
	movz w7,0xF2, lsl 16		// defino el color
	movk w7, 0xCE9E, lsl 00		// completo color
	mov x1,250 	// x1 = 42 (ancho del cuadrado)
	mov x2,350	   // x2 = 42 (largo del cuadrado)
	mov x3,330	// x3 = (posicion y)
	mov x4,25	// x4 = (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado		// dibujo parte mas clara del mar

	//borro orilla 

    movz w7,0xFF, lsl 16		// defino el color
	movk w7, 0xFFFF, lsl 00		// completo color
	mov x1,15  	// x1 = 42 (ancho del cuadrado)
	mov x2,180	   // x2 = 42 (largo del cuadrado)
	mov x3,320	// x3 = (posicion y)
	mov x4,25	// x4 = (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado		// dibujo parte mas clara del mar

	mov x3,316		// x3 = (posición y)
	mov x4,180		// x4 = (posición x)
	bl cuadrado		// dibujo otra parte de la orilla
	movz w7, 0xF5, lsl 16		// defino el color
	movk w7, 0xF5F5, lsl 00		// completo color
	mov x3,306		// x3 = (posición y)
	mov x4,0		// x4 =  (posición x)
	bl cuadrado		// dibujo orilla blanca secundaria

	mov x3,302		// x3 =  (posición y)
	mov x4,155		// x4 =  (posición x)
	bl cuadrado		// dibujo orilla blanca secundaria

	//dibujo cangrejo
	
	//---PATA IZQUIERDA-----
		movz w7, 0xFF, lsl 16		// defino el color
		movk w7, 0x0000, lsl 00		// completo color
		mov	x1,10		// x1 = 10 (ancho del cuadrado)
		mov x2,7		// x2 = 7 (largo del cuadrado)
		add x3,x23,#40		// x3 = (posición y)
		sub x4,x24,#30		// x4 = (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo pata izquiera
	


		mov x1,20		// x1 = 20 (modifico ancho del cuadrado)
		mov x2,7		// x2 = 7 (largo del cuadrado)
		add x3,x23,#40		// x3 =  (posición y)
		sub x4,x24,#20		// x4 = 70 (modifica posición x)
		bl cuadrado		// dibujo pata izquiera

	

		// Patas derecha del cangrejo
		mov x1,10		// x1 = 10 (ancho del cuadrado)
		mov x2,7		// x2 = 7 (largo del cuadrado)
		add x3,x23,#40		// x3 = 400 (posición y)
		add x4,x24,#103		// x4 = 193 (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo pata derecha

	

		mov x1,20		// x1 = 20 (modifico ancho del cuadrado)
		mov x2,7		// x2 = 7 (largo del cuadrado)
		add x3,x23,#40		// x3 = 400 (posición y)
		add x4,x24,#92		// x4 = 182 (modifica posición x)
		bl cuadrado		// dibujo pata derecha	

		// Parte baja del cangrejo
		movz w7, 0xF0, lsl 16		// defino el color
		movk w7, 0x5117, lsl 00		// completo color
		mov x1,50		// x1 = 50
		mov x2,80		// x2 = 80
		add x3,x23,#0		// x3 = 360
		add x4,x24,#0		// x4 = 90
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte baja del cangrejo


		//Parte arriba del cangrejo
		movz w7, 0xFF, lsl 16		// defino el color
		movk w7, 0x0000, lsl 00		// completo color
		mov x1,40		// x1 = 40 (ancho del cuadrado)
		mov x2,100		// x2 = 100 (largo del cuadrado)
		add x3,x23,#0		// x3 = 360 (posición y)
		sub x4,x24,#10		// x4 = 80 (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte arriba del cangrejo


		// Ojos del cangrejo
		movz w7, 0x00, lsl 16		// defino el color
		movk w7, 0x0000, lsl 00		// completo color
    	add x11,x24,#30
    	add x12,x23,#10
    	mov x13, 5		// radio
		bl circulo		// dibujo ojo izquierdo
    	add x11,x24,#50
        add x12,x23,#10	// centro y
    	mov x13, 5		// radio
		bl circulo		// dibujo ojo derecho


		//Pinzas del cangrejo
		movz w7, 0xCC, lsl 16		// defino el color
		movk w7, 0x0000, lsl 00		// completo color
		mov x1,10		// x1 = 10 (ancho del cuadrado)
		mov x2,40		// x2 = 40 (largo del cuadrado)
		add x3,x23,#10		// x3 = 370 (posición y)
		sub x4,x24,#30		// x4 = 60 (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte de la pinza (superior)

		add x3,x23,#30		// x3 = 390 (modifico posición y)
		bl cuadrado		// dibujo parte de la pinza (inferior)

		mov x1,30		// x1 = 30 (ancho del cuadrado)
		mov x2,20		// x2 = 20 (largo del cuadrado)
		add x3,x23,#10		// x3 = 370 (posición y)
		sub x4,x24,#30		// x4 = 60 (posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte de la pinza (union de superior e inferior)
	
		mov x1,10		// x1 = 10 (ancho del cuadrado)
		mov x2,40		// x2 = 40 (largo del cuadrado)
		add x3,x23,#10		// x3 = 370 (posición y)
		add x4,x24,#70		// x4 = 160 (modifico posición x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte de la pinza (superior)


		add x3,x23,#30		// x3 = 390 (modifico posicion y)
		bl cuadrado		// dibujo parte de la pinza (inferior)


		mov x1,30		// x1 = 30 (ancho del cuadrado)
		mov x2,20		// x2 = 20 (largo del cuadrado)
		add x3,x23,#10		// x3 = 370 (posicion y)
		add x4,x24,#90		// x4 = 180 (posicion x)
		mov x14,SCREEN_WIDTH	// x14 = 640
		sub x15,x14,x2		// x15 = 640 - x2
		mov x14,4		// x14 = 4
		mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
		bl cuadrado		// dibujo parte de la pinza (union de superior e inferior)

	//Borro el sol en el mar
	movz w7,0x3F, lsl 16		// defino el color
	movk w7,  0xA1CB, lsl 00		// completo color
	mov x1,84		// x1 = 42 (ancho del cuadrado)
	mov x2,205	   // x2 = 42 (largo del cuadrado)
	mov x3,220	// x3 = 220 (posicion y)
	mov x4,160	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado		// dibujo parte mas clara del mar

	//dibujar efecto orilla  defino el color 
	
	movz w7,0x26, lsl 16		// defino el color
	movk w7,  0x7EA4, lsl 00		// completo color
	mov x1,4		// x1 = 42 (ancho del cuadrado)
	mov x2,205	   // x2 = 42 (largo del cuadrado)
	mov x3,290	// x3 = 290 (posicion y)
	mov x4,160	// x4 = 160 (posicion x)
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4 (al tratarse de un cuadrado x15 guarda la siguiente posición de la columna x)
	bl cuadrado		// dibujo efecto del agua

	
		
    b skip_volver

//----------------------------Función de circulo----------------------------
circulo:
		mov x0, x20		// vuelvo a la posición base del framebuffer
		mul x14, x13, x13	// r^2
		mov x15, 0		// coordenada Y del píxel que se está evaluando.
circle_y_loop:
		mov x16, 0		// coordenada X del píxel que se está evaluando.
circle_x_loop:
		sub x17, x16, x11	// x17 = x16 - 160
		mul x17, x17, x17	// x17 = (x16 - 160)^2
		sub x18, x15, x12	// x18 = x15 - 200
		mul x18, x18, x18	// x18 = (x15 - 200)^2
		add x19, x17, x18	// x19 = (x16 - 160)^2 + (x15 - 200)^2
		cmp x19, x14		// FLAGS = [(x16 - 160)^2 + (x15 - 200)^2] - 60^2
		b.ge skip_pixel
		mov x21, SCREEN_WIDTH	// x21 = 640
		mul x22, x15, x21	// x21 = x15 * 640
		add x22, x22, x16	// x21 = (x15 * 640) + x16
		lsl x22, x22, 2		// x21 = [(x15 * 640) + x16] * 4
		add x0, x20, x22	// x0 = x0 + [(x15 * 640) + x16] * 4
		str w7, [x0]		// pinto x0
skip_pixel:
		add x16, x16, 1		// x16 = x16 + 1
		cmp x16, SCREEN_WIDTH	// FLAGS = x16 - 640
		b.lt circle_x_loop
		add x15, x15, 1		// x15 = x15 + 1
		cmp x15, SCREEN_HEIGH	// FLAGS = x15 - 480
		b.lt circle_y_loop
		ret

//----------------------------Función de cuadrado----------------------------
cuadrado:
		mov x0, x20		// vuelvo a direccion base del framebuffer
		mov x8, SCREEN_WIDTH	// x8 = 640
		mul x3, x3, x8		// x3 = 300 * 640
		add x3, x3, x4		// x3 = (300 * 640) + 100
		lsl x3, x3, 2		// x3 = [(300 * 640) + 100] * 4
		add x0, x20, x3		// x0 = x0 + [(300 * 640) + 100] * 4
		mov x5, x1		// x5 = 110
draw_row:
		mov x6, x2		// x6 = 150
draw_col:
		str w7, [x0]		// pinto el pixel
		add x0, x0, 4		// paso al siguiente pixel
		subs x6, x6, 1		// decremento la cantidad de filas que quedan
		b.ne draw_col		// si x6 != 1 salta a draw_col
next_col:
		add x0, x0, x15 	// paso a la siguiente columna
		subs x5, x5, 1		// decremento la cantidad de columnas que quedan
		b.ne draw_row		// si x5 != 1 salta a draw_row
		ret			// retorno (instrucción de ARMv8)
	
