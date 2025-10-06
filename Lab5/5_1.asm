;  int64_t first_cosh(uint64_t x, uint64_t n);

option casemap:none

.CODE
	first_cosh PROC
		; IN:
		;	XMM0 - x
		;	XMM1 - eps
		; OUT: 
		;	XMM0 - result
		;	
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		; First ex
		; cosh(x) = sum from n = 0 to infinity of ( x^(2n) / (2n)! )

		movsd xmm6, xmm0 ; eps
		movsd xmm7, xmm1 ; eps
		mov rdx, 0
		call ITERATION
		movsd xmm2, xmm0 ; текущее значение
		movsd xmm3, xmm2 ; значение следующей итерации
		
		xor r9, r9

	loop_start:
		inc rdx
		movsd xmm0, xmm6
		call ITERATION
		addsd xmm3, xmm0	; i+1 значение
		movsd xmm4, xmm0	
		ucomisd xmm4, xmm7
		jb loop_end
		jmp loop_start

	loop_end:
		movsd xmm0, xmm3
		ret
	first_cosh ENDP

	ITERATION PROC
		; USES RCX RDX R8 XMM0 XMM1 XMM2
		; IN:
		;	XMM0 - x
		;	RDX - n
		; OUT: 
		;	XMM0 - result

		mov r8, rdx
		imul rdx, 2
		
		CALL POW

		movsd xmm2, xmm0 ; x^(2n)


		mov rcx, rdx
		CALL FACTORIAL

		cvtsi2sd xmm1, rax ; (2n)!
		divsd xmm2, xmm1 ; x^(2n) / (2n)!
		movsd xmm0, xmm2
		mov rdx, r8
		ret
	ITERATION ENDP

	FACTORIAL PROC
		; USES RAX RCX
		; IN:
		;	RCX - n
		; OUT: 
		;	RAX - result
		test rcx, rcx
		jz case_0

		mov rax, rcx
		dec rcx
		jz loop_end
	loop_start:
		mul rcx
		dec rcx
		jnz loop_start
	loop_end:
		ret

	case_0:
		mov rax, 1
		ret
	FACTORIAL ENDP

	POW PROC
		; USES RCX RDX XMM0 XMM1
		; IN:
		;	XMM0 - x
		;	RDX - n
		; OUT: 
		;	XMM0 - result

		test rdx, rdx
		jz case_0

		mov rcx, rdx
		dec rcx
		jz loop_end

		movsd xmm1, xmm0
	loop_start:
		mulsd xmm0, xmm1
		dec rcx
		jnz loop_start
	loop_end:
		ret

	case_0:
		mov rcx, 1
		cvtsi2sd xmm0, rcx
		ret
	POW ENDP
END

; Third ex
; y = 10 + sum from k = 1 to n of ( -1^(k + 1) * (2k - 1) * x^(2k - 1) )