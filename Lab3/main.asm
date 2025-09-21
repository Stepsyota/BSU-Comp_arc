.DATA
	; First ex
	first_array qword 1, 4, 6, 13, 2, 8, 14
	first_el_size = TYPE first_array
	first_count = ($ - first_array) / TYPE first_array
	first_summa dword ?

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
		ret
	main ENDP
END