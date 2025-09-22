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
		mov eax, [rsi] ; ����� ����� �� �������
		cmp [rsi+first_el_size], eax ; �������� �� ���������
		jg L3 ; if ([ESI+4] > [ESI]) �� ����������
		xchg eax,[rsi+first_el_size] ; �������� �������� ��������
		mov [rsi], eax ; ��������� �������
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
		
		xor ecx, ecx
		add ecx, [rsi]
		sub rsi, first_el_size
		add ecx, [rsi]
		sub rsi, first_el_size
		add ecx, [rsi]
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
		mov eax, [rsi]
		cmp eax, 0
		jle L6
		mov [rdi], eax
		add rdi, second_el_size
	L6:
		add rsi, second_el_size
		loop L5
		jmp L7

	L7: ; ��������� ��� ��������� �����
		mov rcx, second_count
		lea rsi, second_array
	L8:
		mov eax, [rsi] ; movsx �� ��������!
		cmp eax, 0
		jg L9
		mov [rdi], eax
		add rdi, second_el_size
	L9:
		add rsi, second_el_size
		loop L8
		jmp L10
	L10:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Third ex
	; ����������� ������ ������� �� ����������� �� ��������� ���������.
		ret
	main ENDP
END