.DATA
	; First ex
	x1 sqword 20
	x2 sqword -4
	x3 sqword 2
	x4 sqword 7

	; Second ex
	k byte 7
	l byte 3
	m byte 2
	n byte 2
	p_r byte 0		; Pawn rook
	r_p byte 0		; Rook pawn
	peace byte 0	; No one hits

	; Third ex
	number_3 qword 4
	summa qword ?

	; Fourth ex
	number_4 qword 84519432
	k_4 qword 12
	summa_f qword 0
	summa_l qword 0
	equal byte 0

.CODE
	main PROC
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; First ex
	; x1, x2, x3, x4 так, чтобы x1 > x2 > x3 < x4.
	;
	; if x3 > x1:
	;	x1, x3 = x3, x1
	; if x3 > x2:
	;	x2, x3 = x3, x2
	; if x3 > x4:
	;	x3, x4 = x4, x3

		mov rax, x1
		mov rbx, x2
		mov rcx, x3
		mov rdx, x4


		cmp rcx, rax ; x3 > x1
		jg DoIF1
		jmp Next1

	DoIF1:	
			mov r8, rax		; swap(rax, rcx)
			mov rax, rcx
			mov rcx, r8		

	Next1:
		cmp rcx, rbx ; x3 > x2
		jg DoIF2
		jmp Next2

	DoIF2:
			mov r8, rbx		; swap(rbx, rcx)
			mov rbx, rcx
			mov rcx, r8

	Next2:
		cmp rcx, rdx ; x3 > x4
		jg DoIF3
		jmp Next3

	DoIF3:	
			mov r8, rcx		; swap(rcx, rdx)
			mov rcx, rdx
			mov rdx, r8

	Next3:
		mov x1, rax
		mov x2, rbx
		mov x3, rcx
		mov x4, rdx

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Second ex
	; На поле (k, l) стоит ладья, на поле (m, n) — пешка. Определить, бьет ли
	; ладья пешку, пешка — ладью или фигуры не угрожают друг другу.

		mov al, k
		mov bl, l
		mov cl, m
		mov dl, n


		; if (k > 8)
		;	Неправильные координаты
		; if (l > 8)
		;	Неправильные координаты
		; if (m > 8)
		;	Неправильные координаты
		; if (n > 8)
		;	Неправильные координаты
		cmp al, 8
		jg SKIP
		cmp bl, 8
		jg SKIP
		cmp cl, 8
		jg SKIP
		cmp dl, 8
		jg SKIP
		; if (k == 0)
		;	Неправильные координаты
		; if (l == 0)
		;	Неправильные координаты
		; if (m == 0)
		;	Неправильные координаты
		; if (n == 0)
		;	Неправильные координаты
		cmp al, 0
		je SKIP
		cmp bl, 0
		je SKIP
		cmp cl, 0
		je SKIP
		cmp dl, 0
		je SKIP

		; if (k == m):
		;	if (l == n):
		;		Фигуры стоят на одной клетке
		cmp al, cl
		jne Rook_check
		cmp bl, dl
		jne Rook_check
		jmp SKIP

	Rook_check:
		; if (k == l or n == m):
		;	Ладья бьет пешку	
		cmp al, cl
		je ROOK
		cmp bl, dl
		je ROOK
		jmp Pawn_check_y

	Pawn_check_y:
		; if (k == m + 1 or k == m - 1) and (l == n + 1):
		;	Пешка бьет ладью
		;
		; if (l == n + 1):
		mov dh, dl
		add dh, 1
		cmp dh, 8
		jg PEACEFUL
		cmp bl, dh
		jne PEACEFUL
		jmp Pawn_check_x_1

		; if (k == m + 1):
	Pawn_check_x_1:
		mov ch, cl
		add ch, 1
		cmp ch, 8
		jg Pawn_check_x_2
		cmp al, ch
		je PAWN

		; if (k == m - 1):
	Pawn_check_x_2:
		mov ch, cl
		sub ch, 1
		jz PEACEFUL
		cmp al, ch
		je PAWN
		jmp PEACEFUL

	PAWN:
		mov p_r, 1
		jmp SKIP
	ROOK:
		mov r_p, 1
		jmp SKIP
	PEACEFUL:
		mov peace, 1
		jmp SKIP


	SKIP:
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Third ex
	; Найдите сумму первых n натуральных чисел, которые делятся на 3 и 5.
	; base = 15

	; i = 0
	; while i < number_3:
	;	summa += base
	;	base += 15
	;	i+= 1

	mov rax, number_3
	mov rbx, summa
	mov rcx, 0
	mov rdx, 0

	do_while_3:
		cmp rdx, rax
		ja END_THIRD
		add rbx, rcx
		add rcx, 15
		inc rdx
		jmp do_while_3

	END_THIRD:
		mov summa, rbx

	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	; Fourth ex
	; Определить, равна ли сумма k первых цифр заданного натурального
	; числа, сумме k его последних цифр.

	mov r8, number_4
	mov r9, k_4
	mov r10, 0 ; length_of_number
	mov r11, 0 ; summa_last
	mov r12, 0 ; summa_first

	test r8, r8
	jz SKIP2
	test r9, r9
	jz EQUALLY

	; number_copy = number
	; length_of_number = 1
	; while(True):
	;	if (number_copy // 10 > 0):
	;		number_copy //= 10
	;		length_of_number += 1
	;	else: break
	mov rax, r8
	mov rbx, 10
	do_while_4:
		xor rdx, rdx
		inc r10
		div rbx
		test rax, rax
		jnz do_while_4
	
	; if k > length_of_number
	cmp r9, r10
	ja SKIP2


	; i = 0
	; while(i < k):
	;	summ_last += number % 10
	;	number //= 10
	;	i += 1
	; DIV, RAX / RBX, частное в RAX, остаток в RDX
	; MUL, RAX * RBX
	mov r13, 0		; i
	mov rax, r8
	mov rbx, 10
	Begin_while_4_1:
		xor rdx, rdx
		cmp r13, r9
		jnl End_while_4_1
		div rbx
		add r11, rdx
		inc r13
		jmp Begin_while_4_1
		
	End_while_4_1:

	; N = length_of_number - k
	; while (N > 0):
	;	number_copy //= 10
	;	N -= 1
	mov r13, r10
	sub r13, r9
	mov rax, r8
	mov rbx, 10
	Begin_while_4_2:
		xor rdx, rdx
		test r13, r13
		jz End_while_4_2
		div rbx
		dec r13
		jmp Begin_while_4_2
		
	End_while_4_2:
	Do_while_4_3:
		xor rdx, rdx
		div rbx
		add r12, rdx
		test rax, rax
		jnz Do_while_4_3
		jmp FOURTH_END

	EQUALLY:
		mov al, 1
		mov equal, al
		jmp SKIP2

	FOURTH_END:
		mov summa_f, r12
		mov summa_l, r11
		cmp r11, r12
		je EQUALLY

	SKIP2:
		ret
	main ENDP
END