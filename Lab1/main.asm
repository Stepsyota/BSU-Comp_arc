.DATA
		; First ex
		a sqword 10
		b sqword 36
		c sqword 4
		y sqword ?
		
		a_2 byte 0
		b_2 byte 1
		c_2 byte 1
		d_2 byte 1
		T byte ?
		S byte ?
		result byte ?


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
		imul rax,rcx
		mov rcx, 2
		mov rdx,0
		idiv rcx
		mov r10, rax


		; (a + b) / 2
		mov rax, a
		add rax, b
		mov rcx, 2
		idiv rcx

		sub r10, rax
		mov y, r10

		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		; Second ex
		; T = !(!a * b + c * !d)

		; r10 = !a * b 
		mov al, a_2
		not al
		and al, 1
		and al, b_2
		mov r10b, al

		; r11 = c * !d
		mov al, d_2
		not al
		and al, 1
		and al, c_2
		mov r11b, al
		
		; T = !(r10 + r11)
		or r10b, r11b
		not r10b
		and r10b, 1
		mov T, r10b


		; S = (a + !b) * (!c + d)
		; r10 = (a + !b)
		mov al, b_2
		not al
		and al, 1
		or al, a_2
		mov r10b, al

		; r11 = (!c + d)
		mov al, c_2
		not al
		and al, 1
		or al, d_2
		mov r11b, al
		
		; S = r10 * r11
		and r10b, r11b
		mov S, r10b

		mov r10b, T
		mov r11b, S

		cmp r10b, r11b
		sete al

		mov result, al
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		; Third ex
		; Задано число n в формате signed int. Инвертировать биты 1, 7.
		; n				= 0b00001001 01011000 01010001 10000111 = 156782983
		; third_result	= 0b00001001 01011000 01010001 00000101 = 156782853

		mov eax, n
		xor eax, 10000010b ; 130 = 0b00000000 00000000 10000010
		mov n, eax
		ret
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	main ENDP

END