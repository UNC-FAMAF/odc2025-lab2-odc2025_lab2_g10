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

//Calculos de circulos
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
//Datos de cuadrado
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
