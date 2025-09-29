.DATA	
		; First ex
		a sqword -4
		b sqword 8
		c sqword -2
		y sqword ?

		a_2 byte 1
		b_2 byte 1
		c_2 byte 0
		d_2 byte 1
		T_2 byte ?
		S_2 byte ?
		result_2 byte ?

		n_3 sdword 156782983
		result_3 sdword ?

.CODE
	main PROC

	; 4.1 ќформить одну программу из лабораторных работ 1Ц3 с использованием
	; простых процедур.
		
		mov rcx, a
		mov rdx, b
		mov r8, c

		call FIRST_TASK
		mov y, rax

		mov cl, a_2
		mov dl, b_2
		mov r8b, c_2
		mov r9b, d_2

		call SECOND_TASK
		mov result_2, al

		mov ecx, n_3

		call THIRD_TASK
		mov result_3, eax

		ret
	main ENDP

	FIRST_TASK PROC
		; IN:	rcx  - a
		;		rdx - b
		;		r8  - c
		; OUT:	rax 
		; y = a Ј c / 2 Ц (a + b) / 2

		mov r10, r8 ; c
		mov r9, rdx ; b
		mov r8, rcx ; a

		; r11 = a Ј c / 2
		mov rax, r8
		imul r10
		mov rcx, 2
		idiv rcx
		mov r11, rax

		; rax = (a + b) / 2
		mov rax, r8
		add rax, r9
		mov rcx, 2
		idiv rcx

		sub r11, rax
		mov rax, r11

		ret
	FIRST_TASK ENDP

	SECOND_TASK PROC
		; IN:	cl  - a_2
		;		dl  - b_2
		;		r8b - c_2
		;		r9b - d_2
		; OUT:	al

		call SECOND_TASK_T
		mov T_2, al
		mov bl, al
		call SECOND_TASK_S
		mov S_2, al

		cmp al, bl
		sete al

		ret
	SECOND_TASK ENDP

	SECOND_TASK_T PROC
	; IN:	cl  - a_2
	;		dl  - b_2
	;		r8b - c_2
	;		r9b - d_2
	; OUT:	al
	; T = !(!a * b + c * !d)

		; r10b = !a * b 
		mov r10b, cl
		xor r10b, 1
		and r10b, dl

		; r11b = c * !d
		mov r11b, r9b
		xor r11b, 1
		and r11b, r8b
		
		; al = !(r10b + r11b)
		mov al, r10b
		or al, r11b
		xor al, 1

		ret
	SECOND_TASK_T ENDP

	SECOND_TASK_S PROC
	; IN:	cl  - a_2
	;		dl  - b_2
	;		r8b - c_2
	;		r9b - d_2
	; OUT:	al
	; S = (a + !b) * (!c + d)

		; r10b = (a + !b)
		mov r10b, dl
		xor r10b, 1
		or r10b, cl

		; r11b = (!c + d)
		mov r11b, r8b
		xor r11b, 1
		or r11b, r9b

		; al = r10 * r11
		mov al, r10b
		and al, r11b

		ret
	SECOND_TASK_S ENDP

	THIRD_TASK PROC
	; «адано число n в формате signed int. »нвертировать биты 1, 7.
	; n_3			= 0b00001001 01011000 01010001 10000111 = 156782983
	; result_3		= 0b00001001 01011000 01010001 00000101 = 156782853

		mov eax,ecx 
		xor eax, 10000010b

		ret
	THIRD_TASK ENDP
END