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
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Second ex
	; Дан массив целых чисел, содержащий n элементов. Получить массив, в
	; котором записаны сначала все положительные числа, затем все отрица-
	; тельные числа и нули, сохраняя порядок следования.

		mov rcx, second_count
		lea rsi, second_array
		lea rdi, second_result_array
	L5: ; Добавляем во второй массив только числа > 0
		mov eax, [rsi]
		cmp eax, 0
		jle L6
		mov [rdi], eax
		add rdi, second_el_size
	L6:
		add rsi, second_el_size
		loop L5
		jmp L7

	L7: ; Добавляем все остальные числа
		mov rcx, second_count
		lea rsi, second_array
	L8:
		mov eax, [rsi] ; movsx не работает!
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
	; Упорядочить строки матрицы по возрастанию их последних элементов.
		ret
	main ENDP
END