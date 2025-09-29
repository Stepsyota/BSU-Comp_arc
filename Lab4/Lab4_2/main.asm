includelib ucrt.lib
includelib legacy_stdio_definitions.lib

.DATA
	; First ex
	x1 sqword 20
	x2 sqword -4
	x3 sqword 2
	x4 sqword 7

	Output_info byte "x1 = %d, x2 = %d, x3 = %d, x4 = %d", 10, 0
	Output_result byte "Result: x1 = %d > x2 = %d > x3 = %d < x4 = %d", 10, 0
	Output_swap_x3x1 byte "x3 and x1 have been swapped", 10, 0
	Output_swap_x3x2 byte "x3 and x2 have been swapped", 10, 0
	Output_swap_x3x4 byte "x3 and x4 have been swapped", 10, 0


.CODE
	externdef printf:PROC

	main PROC

	; 4.2 Добавить в одну программу из лабораторных работ 1–3 вывод результата
	; на экран с помощью функции printf.
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; First ex
	; x1, x2, x3, x4 так, чтобы x1 > x2 > x3 < x4.
	;
	; if x3 > x1:
	;	x1, x3 = x3, x1
	; if x3 > x2:
	;	x2, x3 = x3, x2
	; if x3 > x4:
	;	x3, x4 = x4, x3


		push x4

		sub rsp, 32

		mov r9, x3
		mov r8, x2
		mov rdx, x1
		lea rcx, Output_info

		call printf

		add rsp, 32
		add rsp, 8

		mov r12, x1
		mov r13, x2
		mov r14, x3
		mov r15, x4


		cmp r14, r12 ; x3 > x1
		jg DoIF1
		jmp Next1

	DoIF1:	
			mov r8, r12		; swap(rax, rcx)
			mov r12, r14
			mov r14, r8

			sub rsp, 40
			lea rcx, Output_swap_x3x1
			call printf
			add rsp, 40

	Next1:
		cmp r14, r13 ; x3 > x2
		jg DoIF2
		jmp Next2

	DoIF2:
			mov r8, r13		; swap(rbx, rcx)
			mov r13, r14
			mov r14, r8

			sub rsp, 40
			lea rcx, Output_swap_x3x2
			call printf
			add rsp, 40

	Next2:
		cmp r14, r15 ; x3 > x4
		jg DoIF3
		jmp Next3

	DoIF3:	
			mov r8, r14		; swap(rcx, rdx)
			mov r14, r15
			mov r15, r8

			sub rsp, 40
			lea rcx, Output_swap_x3x4
			call printf
			add rsp, 40

	Next3:
		mov x1, r12
		mov x2, r13
		mov x3, r14
		mov x4, r15

		push r15
		sub rsp, 32
		
		mov r9, x3
		mov r8, x2
		mov rdx, x1
		lea rcx, Output_result

		call printf

		add rsp, 32
		add rsp, 8
		xor rax, rax
		ret
	main ENDP
END