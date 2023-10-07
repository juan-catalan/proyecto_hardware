	AREA DATOS, DATA
	
deltas_fila DCD 0, -1, -1, 1
deltas_columna DCD -1, 0, -1, -1
TRUE EQU 1
K_SIZE EQU 4
N_DELTAS EQU 4
	
	AREA codigo, CODE
	EXPORT conecta_K_hay_linea_arm_c
	PRESERVE8 {TRUE}
	
	
conecta_K_hay_linea_arm_c
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
	LDR r9, [r4, r6, LSL #2]				; r9 = deltas_fila[i]
	LDR r10, [r5, r6, LSL #2]				; r10 = deltas_columna[i]
	push {r0-r3}							; push de los registros scratch
	push {r9-r10}							; push de delta_fila[i] y delta_columna[i]
	IMPORT conecta_K_buscar_alineamiento_c
	BL conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila, col, del_fila[i], del_col[i])
	MOV r8, r0								; long_linea = conecta_K_buscar_alineamiento(...)
	pop {r9-r10}							; recuperamos los registros
	pop {r0-r3}								; recuperamos los registros scratch
	CMP r8, #K_SIZE								; si long_linea >= K_SIZE
	MOVGE r7, #1							; entonces linea = TRUE
	BGE fin_bucle							; sale del bucle (continue)
	; si linea = FALSE
	push {r0-r2, r12}
	SUB r1, r1, r9							; fila - deltas_fila[i]				
	SUB r2, r2, r10							; columna - deltas_columna[i]
	RSB r9, r9, #0							; -deltas_fila[i]
	RSB r10, r10, #0						; -deltas_columna[i
	push {r9-r10}							; push de -deltas_fila[i] y deltas_columna[i]
	BL conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila-del_fila[i], col-del_col[i], -del_fila[i], -del_col[i])
	ADD r8, r8, r0							; long_linea += ...
	pop {r9-r10}							; recuperamos los registros
	pop {r0-r2, r12}						; recuperamos los registros
	CMP r8, #K_SIZE							; si long_linea >= K_SIZE
	MOVGE r7, #1							; entonces linea = TRUE
	ADD r6, r6, #1							; i++
	B ini_buc
fin_bucle
	MOV r0, r7								; return linea
	LDMIA SP!, {r4-r10, FP, PC}
	END
	
	
	
	
	
		
	