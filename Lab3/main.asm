.DATA
	; First ex
	array qword 1, 4, 6, 13, 2, 8, 14
	array_el_size = TYPE array
	count = ($ - array) / TYPE array

.CODE
	main PROC
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; First ex
	; ����� ����� 3 ���������� ��������� �������.

		mov rcx, Count
		dec rcx
	L1: 
		push rcx ; ��������� ������� �������� �����
		lea rsi, array ; ESI ��������� �� ������ �������
	L2: 
		mov eax, [rsi] ; ����� ����� �� �������
		cmp [rsi+4], eax ; �������� �� ���������
		jg L3 ; if ([ESI+4] > [ESI]) �� ����������
		xchg eax,[rsi+4] ; �������� �������� ��������
		mov [rsi], eax ; ��������� �������
	L3: 
		add rsi,4 ; c������� ��������� �� ��������� �������
		loop L2 ; ���������� ����
		pop rcx ; ������������ ������� �������� �����
		loop L1 ; ��������� ������� ����
	L4:
		ret
	main ENDP
END