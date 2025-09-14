.DATA
		; First ex
		a sqword 10
		b sqword 12
		c sqword 4
		y sqword ?

		d qword 2
		T qword ?
		S qword ?
		res byte ?


		; Third ex
		n sdword 156782983

.CODE
	main PROC
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		; First ex
		; y = a · c / 2 – (a + b) / 2

		; a · c / 2
		mov rax, a
		mov rcx, c
		imul rcx
		mov rcx, 2
		idiv rcx
		mov r10, rax


		; (a + b) / 2
		mov rax, a
		add rax, b
		mov rcx, 2
		idiv rcx

		sbb r10, rax
		mov y, r10

		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		; Second ex
		; T = !(!a * b + c * !d)

		; r10 = !a * b 
		mov rax, a
		not rax
		and rax, b
		mov r10, rax

		; r11 = c * !d
		mov rax, d
		not rax
		and rax, c
		mov r11, rax
		
		; T = !(r10 + r11)
		or r10, r11
		not r10
		mov T, r10


		; S = (a + !b) * (!c + d)
		; r10 = (a + !b)
		mov rax, b
		not rax
		or rax, a
		mov r10, rax

		; r11 = (!c + d)
		mov rax, c
		not rax
		or rax, d
		mov r11, rax
		
		; S = r10 * r11
		and r10, r11
		mov S, r10

		mov r10, T
		mov r11, S
		cmp r10, r11
		sete al
		mov res, al
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		; Third ex
		; Задано число n в формате signed int. Инвертировать биты 1, 7.
		; n			= 0b00001001 01011000 01010001 10000111 = 156782983
		; result	= 0b00001001 01011000 01010001 00000101 = 156782853

		mov eax, n
		xor eax, 130 ; 130 = 0b00000000 00000000 10000010
		mov n, eax
		ret
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	main ENDP

END