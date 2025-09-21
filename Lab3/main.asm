.DATA
	; First ex
	array qword 1, 4, 6, 13, 2, 8, 14
	array_el_size = TYPE array
	count = ($ - array) / TYPE array

.CODE
	main PROC
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; First ex
	; Найти сумму 3 наибольших элементов массива.

		mov rcx, Count
		dec rcx
	L1: 
		push rcx ; сохранить счетчик внешнего цикла
		lea rsi, array ; ESI указывает на первый элемент
	L2: 
		mov eax, [rsi] ; взять число из массива
		cmp [rsi+4], eax ; сравнить со следующим
		jg L3 ; if ([ESI+4] > [ESI]) не обменивать
		xchg eax,[rsi+4] ; обменять значения соседних
		mov [rsi], eax ; элементов массива
	L3: 
		add rsi,4 ; cдвинуть указатель на следующий элемент
		loop L2 ; внутренний цикл
		pop rcx ; восстановить счетчик внешнего цикла
		loop L1 ; повторить внешний цикл
	L4:
		ret
	main ENDP
END