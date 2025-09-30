.DATA
	; First ex
	first_array qword 1, 4, 6, 13, 2, 8, 14
	first_el_size = TYPE first_array
	first_count = ($ - first_array) / TYPE first_array
	first_summa dword ?

	; Second ex
	second_array sqword 1, -7, 0, 13, 2, -4
	second_count = ($ - second_array) / TYPE second_array
	second_el_size = TYPE second_array
	second_result_array sqword ?, ?, ?, ?, ?, ?

	; Third ex
	third_array_2D qword 1, 4, 8
	third_row_size = ($ - third_array_2D)
				   qword 2, 7, 3
				   qword 4, 6, 7
	third_total_size = ($ - third_array_2D)
	third_el_size = TYPE third_array_2D

.CODE
	main PROC
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; First ex
	; ����� ����� 3 ���������� ��������� �������.

		mov eax, first_count ; ���� ������ ������� < 3 ���������
		cmp eax, 3
		jl SKIP_FIRST

		mov rcx, first_count
		dec rcx
	L1: 
		push rcx ; ��������� ������� �������� �����
		lea rsi, first_array ; ESI ��������� �� ������ �������
	L2: 
		mov rax, [rsi] ; ����� ����� �� �������
		cmp [rsi+first_el_size], eax ; �������� �� ���������
		jg L3 ; if ([ESI+4] > [ESI]) �� ����������
		xchg rax,[rsi+first_el_size] ; �������� �������� ��������
		mov [rsi], rax ; ��������� �������
	L3: 
		add rsi,first_el_size ; c������� ��������� �� ��������� �������
		loop L2 ; ���������� ����
		pop rcx ; ������������ ������� �������� �����
		loop L1 ; ��������� ������� ����
	L4:
		lea rsi, first_array
		mov rax, first_el_size
		mov rbx, first_count
		dec rbx
		mul rbx
		add rsi, rax ; ������� ��������� ������� �������
		
		xor rcx, rcx
		add rcx, [rsi]
		sub rsi, first_el_size
		add rcx, [rsi]
		sub rsi, first_el_size
		add rcx, [rsi]
		mov first_summa, ecx

	SKIP_FIRST:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Second ex
	; ��� ������ ����� �����, ���������� n ���������. �������� ������, �
	; ������� �������� ������� ��� ������������� �����, ����� ��� ������-
	; ������� ����� � ����, �������� ������� ����������.

		mov rcx, second_count
		lea rsi, second_array
		lea rdi, second_result_array
	L5: ; ��������� �� ������ ������ ������ ����� > 0
		mov rax, [rsi]
		cmp rax, 0
		jle L6
		mov [rdi], rax
		add rdi, second_el_size
	L6:
		add rsi, second_el_size
		loop L5
		jmp L7

	L7: ; ��������� ��� ��������� �����
		mov rcx, second_count
		lea rsi, second_array
	L8:
		mov rax, [rsi]
		cmp rax, 0
		jg L9
		mov [rdi], rax
		add rdi, second_el_size
	L9:
		add rsi, second_el_size
		loop L8
		jmp L10
	L10:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Third ex
	; ����������� ������ ������� �� ����������� �� ��������� ���������.
		; third_total_size / third_row_size - ���������� �����
		; third_row_size / third_el_size - ���������� ��������

		lea rsi, third_array_2D
		mov rax, third_total_size - third_row_size
		
		mov rcx, third_row_size / third_el_size
	OUTER_CYCLE:
		mov rax, third_total_size - third_row_size
	INNER_CYCLE:
		mov r8, [rsi +  rax  - third_el_size]				  ; ��������� ������� i ������
		mov r9, [rsi + rax + third_row_size  - third_el_size] ; ��������� ������� i + 1 ������
		mov rdx, rax ; ������� �������� �� ����� i-�� ����
		mov r10, third_row_size / third_el_size
		cmp r8, r9
		ja SWAP_ROW

	TO_NEXT_ROW:
		sub rax, third_row_size
		test rax, rax
		jnz INNER_CYCLE
		loop OUTER_CYCLE
		jmp SKIP_THIRD

	SWAP_ROW:
		; ��� ����� ���-�� �������� ������ i � i + 1 �������
		mov r8, [rsi + rdx - third_row_size]  ; �������� ������ ������� i ������
		xchg r8, [rsi +  rdx]				  ; �������� ������ ������� i + 1 ������
		mov [rsi + rdx - third_row_size], r8  ; �������� ������ ������� i ������
		add rdx, third_el_size
		dec r10
		test r10, r10
		jnz SWAP_ROW	
		jmp TO_NEXT_ROW

	SKIP_THIRD:
		ret
	main ENDP
END