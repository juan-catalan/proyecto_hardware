	AREA codigo, CODE
	EXPORT conecta_K_buscar_alineamiento_arm
	PRESERVE8 {TRUE}

conecta_K_buscar_alineamiento_arm
; prologo
	MOV IP, SP
	STMDB SP!, {r4-r10,FP,IP,LR,PC}
	SUB FP, IP, #4
	
; obtener delta_columna
; registros
; r0: t, r1: fila, r2: columna, r3: color, r4: delta_fila, r5: delta_columna

	; guardo los registros anbtes de la llamada a tablero_buscar_color
	STMDB FP!, {r0-r5}
	IMPORT tablero_buscar_color
	BL tablero_buscar_color
	; muevo el resultado a r6
	MOV r6, r0
	; recupero mis registros previos
	LDMDB FP, {r0-r5}
	
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