	AREA datos, DATA

deltas_fila DCD 0, -1, -1, 1
deltas_columna DCD -1, 0, -1, -1
EXITO EQU 0
ERROR EQU -1
FALSE EQU 0
TRUE  EQU 1
NUM_COLUMNAS EQU 7
NUM_FILAS 	EQU 7
MAX_NO_CERO EQU 6
COLUMNAS_SIZE EQU MAX_NO_CERO * NUM_FILAS
K_SIZE EQU 4
N_DELTAS EQU 4

	AREA codigo, CODE
	EXPORT conecta_K_hay_linea_arm_arm_rec
	PRESERVE8 {TRUE}
	
conecta_K_hay_linea_arm_arm_rec
	; r0 = t, r1 = fila, r2 = columna r3= color
	STMDB SP!, {r4-r10, FP, LR}
	LDR r4, =deltas_fila 					; r4 = vector deltas_fila
	LDR r5, =deltas_columna 				; r5 = vector deltas_columna
	MOV r6, #0 								; r6 = i = 0
	MOV r7, #0 								; r7 = linea = 0(FALSE) 
	MOV r8, #0								; r8 = long_linea = 0
	
	; buscar linea en fila, columna y 2 diagonales
	
ini_buc 
	CMP r6, #N_DELTAS						; si i == N_DELTAS 
	BEQ fin_bucle							; sale del bucle
	CMP r7, #1								; si linea == TRUE
	BEQ fin_bucle							; sale del bucle
	LDR r9, [r4, r6, LSL #2]					; r9 = deltas_fila[i]
	LDR r10, [r5, r6, LSL #2]				; r10 = deltas_columna[i]
	push {r0-r3}							; push de los registros scratch
	BL conecta_K_buscar_alineamiento_arm	; llamada a conecta_K_buscar_alineamiento_arm(t, fila, col, del_fila[i], del_col[i])
	MOV r8, r12								; long_linea = conecta_K_buscar_alineamiento(...)
	pop {r0-r3}								; recuperamos los registros scratch
	CMP r8, #K_SIZE							; si long_linea >= K_SIZE
	MOVGE r7, #1							; entonces linea = TRUE
	BGE fin_bucle							; sale del bucle (continue)
	; si linea = FALSE
	push {r0-r2}
	SUB r1, r1, r9							; fila - deltas_fila[i]
	SUB r2, r2, r10							; columna - deltas_columna[i]
	RSB r9, r9, #0							; -deltas_fila[i]
	RSB r10, r10, #0						; -deltas_columna[i]
	BL conecta_K_buscar_alineamiento_arm	; llamada a conecta_K_buscar_alineamiento_arm(t, fila-del_fila[i], col-del_col[i], -del_fila[i], -del_col[i])
	ADD r8, r8, r12							; long_linea += ...
	pop {r0-r2}								; recuperamos los registros
	CMP r8, #K_SIZE							; si long_linea >= K_SIZE
	MOVGE r7, #1							; entonces linea = TRUE
	ADD r6, r6, #1							; i++
	B ini_buc
fin_bucle
	MOV r0, r7								; return linea
	LDMIA SP!, {r4-r10, FP, PC}
	
	
; registros
; r0: t & t->columnas, r1: fila, r2: columna, r3: color,  r9: delta_fila, r10: delta_columna
; r6 : t->no_ceros, r4 : t->columnas[fila]; r8: col
conecta_K_buscar_alineamiento_arm
	; prologo
	STMDB SP!, {r4-r10,LR}
	; r12: registro acumulador del resultado
	mov r12, #0
	; calculo la posicion de t- > no_ceros
	ADD r6, r0, #COLUMNAS_SIZE

ini_buc_buscar_alineamiento
	; compruebo validez posicion
	CMP r1, #NUM_FILAS			; if !tablero_fila_valida(fila)
	CMPLO r2, #NUM_COLUMNAS 	; OR !tablero_columna_valida(columna)
	BHS fin		
	
	; si es una posicion valida		
	; busco columna en estructura dispersa
	mov r8, #0 ; r8: col
	; calculo la direccion de columnas[fila]
	MOV r4, #MAX_NO_CERO
	MLA r4, r1, r4, r0 ; r9 : direccion t->columnas[fila] (cada fila ocupa MAX_NO_CERO bytes)
	
buscar_columna			; while (pueda seguir buscando)
	; compruebo que no estemos buscando en una columna >= MAX_NO_CERO
	CMP r8, #MAX_NO_CERO	; if (col >= MAX_NO_CERO)
	BGE fin 					;  GOTO return ERROR;
	; recorro el vector de columnas para la fila correspondiente
	LDRB r5, [r4, r8] 		; r5: t->columnas[fila][col]
	CMP r5, r2				; if (t->columnas[fila][col] == columna)
	BEQ columna_encontrada		; GOTO columna_encontrada
	ADD r8, r8, #1			; col++
	B buscar_columna
	
columna_encontrada
	;  en r6 tengo la direccion de t->no_ceros 
	MOV r4, #MAX_NO_CERO
	MLA r7, r1, r4, r6 ; r7 : direccion t->no_ceros[fila]
	; accedo a no_ceros[fila][col] para obtener el color
	LDRB r4, [r7, r8] ; r9: t->no_ceros[fila][col]
	AND r4, r4, #0X3; aplico una mascara a r9 para eliminar el bit de ocupado de la celda
	CMP r4, r3 ; if (tablero_buscar_color != 0)
	BNE fin
		
	
color_encontrado	
	ADD r1, r1, r9 ; nueva_fila = fila + delta_fila
	ADD r2, r2, r10 ; nueva_columna = columna + delta_columna
	ADD r12, r12, #1 ; acumulo el resultado
	B ini_buc_buscar_alineamiento
	
; epilogo
fin
	LDMIA SP!, {r4-r10, PC}
	END
		