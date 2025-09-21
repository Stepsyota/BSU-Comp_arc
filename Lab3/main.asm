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
	; Найти сумму 3 наибольших элементов массива.

		mov eax, first_count ; Если размер массива < 3 элементов
		cmp eax, 3
		jl SKIP_FIRST

		mov rcx, first_count
		dec rcx
	L1: 
		push rcx ; сохранить счетчик внешнего цикла
		lea rsi, first_array ; ESI указывает на первый элемент
	L2: 
		mov eax, [rsi] ; взять число из массива
		cmp [rsi+first_el_size], eax ; сравнить со следующим
		jg L3 ; if ([ESI+4] > [ESI]) не обменивать
		xchg eax,[rsi+first_el_size] ; обменять значения соседних
		mov [rsi], eax ; элементов массива
	L3: 
		add rsi,first_el_size ; cдвинуть указатель на следующий элемент
		loop L2 ; внутренний цикл
		pop rcx ; восстановить счетчик внешнего цикла
		loop L1 ; повторить внешний цикл
	L4:
		lea rsi, first_array
		mov rax, first_el_size
		mov rbx, first_count
		dec rbx
		mul rbx
		add rsi, rax ; Получил последний элемент массива
		
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