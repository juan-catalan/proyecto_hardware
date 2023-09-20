	AREA DATOS, DATA
	
deltas_fila DCB 0 -1 -1 1
deltas_columna DCB -1 0 -1 -1
	
	AREA codigo, CODE
	
conecta_K_hay_linea_c_arm
	
	; STMDB de los registros necesarios, fp y lr. 
	; suponer empezar desde registro r4 -> r0 = t, r1 = fila, r2 = columna???
	mov r4, #4								; r4 = N_DELTAS
	ldr r5, =deltas_fila 					; r5 = vector deltas_fila
	ldr r6, =deltas_columna 				; r6 = vector deltas_columna
	mov r7, #0 								; r7 = i = 0
	mov r8, #0 								; r8 = linea = 0(FALSE) 
	mov r9, #0								; r9 = long_linea = 0
	
	; buscar linea en fila, columna y 2 diagonales
	
ini_buc 
	cmp r7, r4								; si i == N_DELTAS 
	beq fin_bucle							; sale del bucle
	cmp r8, #1								; si linea == TRUE
	beq fin_bucle							; sale del bucle
	ldrb r10, [r5, r7]						; r10 = deltas_fila[i]
	ldrb r11, [r6, r7]						; r11 = deltas_columna[i]
	; push registros t, fila, columna
	push {r10, r11}							; push de delta_fila[i] y delta_columna[i]
	bl conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila, col, del_fila[i], del_col[i])
	pop {r10, r11}							; recuperamos los registros
	; pop registros t, fila, columna
	; mov r9, r? - registro en el que se guarde long_linea
	ldr r12, =K_SIZE						; creo que no puedo <-----------------
	cmp r9, r12								; si long_linea >= K_SIZE
	movge r8, #1							; entonces linea = TRUE
	bge fin_bucle							; sale del bucle (continue)
	; si linea = FALSE
	sub r1, r1, r10							; fila - deltas_fila[i]
	; mascara??
	sub r2, r2, r11							; columna - deltas_columna[i]
	; mascara??
	mov r12, #0								; r12 = 0 (SE HA CHAFADO K_SIZE)
	sub r10, r12, r10						; -deltas_fila[i]
	sub r11, r12, r11						; -deltas_columna[i]
	push {r10, r11}							; push de -deltas_fila[i] y deltas_columna[i]
	bl conecta_K_buscar_alineamiento_c		; llamada a conecta_K_buscar_alineamiento_c(t, fila-del_fila[i], col-del_col[i], -del_fila[i], -del_col[i])
	pop {r10, r11}							; recuperamos los registros
	; mas pops??
	; add r9, r9, r?						; long_linea += 
	ldr r12, =K_SIZE						; creo que no puedo <-----------------
	cmp r9, r12								; si long_linea >= K_SIZE
	movge r8, #1							; entonces linea = TRUE
	add r7, r7, #1							; i++
	b ini_bucle
fin_bucle
	mov r0, r8								; return linea
	; restaurar pila
	END
	
	
	
	
	
	
		
	