	AREA datos, DATA

EXITO EQU 0
ERROR EQU -1
FALSE EQU 0
TRUE  EQU 1
NUM_COLUMNAS EQU 7
NUM_FILAS 	EQU 7
MAX_NO_CERO EQU 6

	AREA codigo, CODE
	EXPORT conecta_K_buscar_alineamiento_arm
	PRESERVE8 {TRUE}


conecta_K_buscar_alineamiento_arm
; prologo
	MOV IP, SP
	STMDB SP!, {r4-r10,FP,IP,LR,PC}
	SUB FP, IP, #4
	LDR r4, [FP, #4]
	LDR r5, [FP, #8]
	
; obtener delta_columna
; registros
; r0: t & t->columnas, r1: fila, r2: columna, r3: color, r4: delta_fila, r5: delta_columna
; r7 : t->no_ceros
	; version asm de tablero_buscar_color
	; guardo en r6 el resultado
	; compruebo validez posicion
	CMP r1, #NUM_COLUMNAS	; if !tablero_fila_valida(fila)
	CMPLO r2, #NUM_FILAS 	; OR !tablero_columna_valida(columna)
	MOVGE r6, #ERROR		
	BGE color_encontrado
	
	; si es una posicion valida		
	; busco columna en estructura dispersa
	mov r8, #0 ; r8: col
	
buscar_columna			; while (pueda seguir buscando)
	; compruebo que no estemos buscando en una columna >= MAX_NO_CERO
	CMP r8, #MAX_NO_CERO	; if (col >= MAX_NO_CERO)
	BGE columna_no_encontrada ;  GOTO return ERROR;
	; recorro el vector de columnas para la fila correspondiente
	; calculo la direccion de columnas[fila][col]
	ADD r9, r0, r1, LSL #3 ; r9 : direccion t->columnas[fila]
	LDRB r10, [r9, r8, LSL #3] ; r10: t->columnas[fila][col]
	CMP r10, r2			; if (t->columnas[fila][col] == columna)
	BEQ columna_encontrada		; GOTO columna_encontrada
	ADD r8, r8, #1			; col++
	B buscar_columna
columna_no_encontrada
	MOV r6, #ERROR
	B color_encontrado
	
	
columna_encontrada
	; calculo la posicion de t- > no_ceros
	MOV r9, #MAX_NO_CERO
	MOV r10, #NUM_FILAS
	MUL r7, r9, r10  ; calculo cuanto ocupa columnas: 8bits * MAX_NO_CERO * NUM_FILAS
	ADD r7, r0, r7, LSL #3
	; ahora en r7 tengo la direccion de t->no_ceros 
	ADD r7, r7, r1, LSL #3 ; r7 : direccion t->no_ceros[fila]
	; accedo a no_ceros[fila][col] para obtener el color
	LDRB r9, [r7, r8, LSL #3] ; r9: t->no_ceros[fila][col]
	CMP r9, r3
	MOVEQ r6, #EXITO
	MOVNE r6, #ERROR
		
	
color_encontrado	
	; tengo el color guardado
	CMP r6, #0 ; if (tablero_buscar_color != 0)
	MOVNE r0, #0
	BNE fin ; return 0
	
	;
	ADD r1, r1, r4 ; nueva_fila = fila + delta_fila
	ADD r2, r2, r5 ; nueva_columna = columna + delta_columna
	
	BL conecta_K_buscar_alineamiento_arm
	ADD r0, r0, #1
	
			
; epilogo
fin
	LDMDB FP, {r4-r10,FP,SP,PC}
	END