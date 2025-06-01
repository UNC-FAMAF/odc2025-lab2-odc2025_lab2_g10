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
	//---------------- CODE HERE ------------------------------------

//----------------------------Datos de cielo----------------------------
	// Cielo
	movz w10, 0x90, lsl 16		// defino color
	movk w10, 0xD6F5, lsl 00	// completo color
	mov x2, SCREEN_HEIGH         // tamaño y
cielo1:
	mov x1, SCREEN_WIDTH         // tamaño x
cielo0:
	str w10,[x0]		// colorear el pixel N
	add x0,x0,4		// siguiente pixel
	sub x1,x1,1		// decrementar contador X
	cbnz x1,cielo0		// si no terminó la fila, salto
	sub x2,x2,1		// decrementar contador Y
	cbnz x2,cielo1		// si no es la última fila, salto


	// Sol
	movz w7, 0xF7, lsl 16		// defino color
	movk w7, 0x9E19, lsl 00		// completo color
    	mov x11, 80		// centro x
    	mov x12, 80		// centro y
    	mov x13, 50		// radio
	bl circulo		// dibuja los "rayos" del sol
	movz w7, 0xFF, lsl 16		// defino color
	movk w7, 0xDA1B, lsl 00		// completo color
    	mov x11, 80		// centro x
    	mov x12, 80		// centro y
    	mov x13, 40		// radio
	bl circulo		// dibuja el "nucleo" del sol

	// Nubes
	mov x10, 2		// cantidad nubes
	mov x1,280		// centro x
	mov x2,80		// centro y
    	mov x13,30		// radio
nube:
	mov x14,SCREEN_WIDTH	// x14 = 640
	sub x15,x14,x2		// x15 = 640 - x2
	mov x14,4		// x14 = 4
	mul x15,x15,x14		// x15 = (640 - x2) * 4
	movz w7, 0xEF, lsl 16		// defino color
	movk w7, 0xEFEF, lsl 00		// completo color
	mov x11, x1		// centro x
    	mov x12, x2		// centro y
	bl circulo		// dibuja parte profunda de la nube
	movz w7, 0xF5, lsl 16		// defino color
	movk w7, 0xF5F5, lsl 00		// completo color
	sub x11,x11,40		// centro x
	bl circulo		// dibuja parte media de la nube
	add x11,x11,40		// centro x
    	sub x12,x12,20		// centro y
	bl circulo		// dibuja parte media de la nube
	add x11,x11,40		// centro x
    	add x12,x12,20		// centro y
	bl circulo		// dibuja parte media de la nube 
	movz w7, 0xFF, lsl 16		// defino color
	movk w7, 0xFFFF, lsl 00		// completo color
	sub x11,x11,120		// centro x
	bl circulo		// dibuja parte frontal de la nube
	add x11,x11,40		// centro x
    	sub x12,x12,20		// centro y
	bl circulo		// dibuja parte frontal de la nube
	add x11,x11,40		// centro x
    	sub x12,x12,10		// centro y
	bl circulo		// dibuja parte frontal de la nube
	add x11,x11,40		// centro x
    	add x12,x12,10		// centro y
	bl circulo		// dibuja parte frontal de la nube
	add x11,x11,40		// centro x
    	add x12,x12,20		// centro y
	bl circulo		// dibuja parte frontal de la nube

	add x1,x1, 240		// cambio la posición en x de la nube
	subs x10,x10,1		// descuento cantidad de nubes
	cbnz x10, nube		// repito proceso si me quedan nubes por dibujar
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

	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10
	and w11, w10, 0b10

	// w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
	// efectivamente, su valor representará si GPIO 2 está activo
	lsr w11, w11, 1

	//---------------------------------------------------------------
	// Infinite Loop
InfLoop:
	b InfLoop
