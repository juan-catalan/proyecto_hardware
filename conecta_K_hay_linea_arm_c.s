	AREA DATOS, DATA
	
deltas_fila DCB 0, -1, -1, 1
deltas_columna DCB -1, 0, -1, -1
TRUE EQU 1
K_SIZE EQU 4
N_DELTAS EQU 4
	
	AREA codigo, CODE
	EXPORT conecta_K_hay_linea_arm_c
	PRESERVE8 {TRUE}
	
	
conecta_K_hay_linea_arm_c
	; r0 = t, r1 = fila, r2 = columna r3= color
	STMDB SP!, {r4-r10, FP, LR}
	ldr r4, =deltas_fila 					; r4 = vector deltas_fila
	ldr r5, =deltas_columna 				; r5 = vector deltas_columna
	mov r6, #0 								; r6 = i = 0
	mov r7, #0 								; r7 = linea = 0(FALSE) 
	mov r8, #0								; r8 = long_linea = 0
	
	; buscar linea en fila, columna y 2 diagonales
	
ini_buc 
	cmp r6, #N_DELTAS						; si i == N_DELTAS 
	beq fin_bucle							; sale del bucle
	cmp r7, #1								; si linea == TRUE
	beq fin_bucle							; sale del bucle
	ldrb r9, [r4, r6]						; r9 = deltas_fila[i]
	ldrb r10, [r5, r6]						; r10 = deltas_columna[i]
	push {r0-r3}							; push de los registros scratch
	push {r9-r10}							; push de delta_fila[i] y delta_columna[i]
	IMPORT conecta_K_buscar_alineamiento_c
	bl conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila, col, del_fila[i], del_col[i])
	mov r8, r0								; long_linea = conecta_K_buscar_alineamiento(...)
	pop {r9-r10}							; recuperamos los registros
	pop {r0-r3}								; recuperamos los registros scratch
	ldr r12, =K_SIZE						; r12 = K_SIZE
	cmp r8, r12								; si long_linea >= K_SIZE
	movge r7, #1							; entonces linea = TRUE
	bge fin_bucle							; sale del bucle (continue)
	; si linea = FALSE
	push {r0-r2, r12}
	sub r1, r1, r9							; fila - deltas_fila[i]
	and r1, r1, #0xFF						; aplicamos mascara						
	sub r2, r2, r10							; columna - deltas_columna[i]
	and r2, r2, #0xFF						; aplicamos mascara
	mov r12, #0								; r12 = 0 (SE HA CHAFADO K_SIZE)
	sub r9, r12, r9							; -deltas_fila[i]
	and r9, r9, #0XFF						; aplicamos máscara
	sub r10, r12, r10						; -deltas_columna[i]
	and r10, r10, #0xFF						; aplicamos máscara
	push {r9-r10}							; push de -deltas_fila[i] y deltas_columna[i]
	bl conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila-del_fila[i], col-del_col[i], -del_fila[i], -del_col[i])
	add r8, r8, r0							; long_linea += ...
	pop {r9-r10}							; recuperamos los registros
	pop {r0-r2, r12}						; recuperamos los registros
	ldr r12, =K_SIZE						; r12 = K_SIZE
	cmp r8, r12								; si long_linea >= K_SIZE
	movge r7, #1							; entonces linea = TRUE
	add r6, r6, #1							; i++
	b ini_buc
fin_bucle
	mov r0, r7								; return linea
	LDMIA SP!, {r4-r10, FP, PC}
	END
	
	
	
	
	
		
	