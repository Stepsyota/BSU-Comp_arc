;  double avx_cosh(double x, double eps);

option casemap:none

extern POW_AVX:PROC
extern FACTORIAL:PROC

.CODE
	avx_cosh PROC
		; IN:
		;	XMM0 - x
		;	XMM1 - eps
		; OUT: 
		;	XMM0 - result
		;	
		; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		; First ex
		; cosh(x) = sum from n = 0 to infinity of ( x^(2n) / (2n)! )

		vmovsd xmm6, xmm0, xmm0 ; x
		vmovsd xmm7, xmm1, xmm1 ; eps
		mov rdx, 0
		call ITERATION_AVX
		vmovsd xmm2, xmm0, xmm0 ; текущее значение
		vmovsd xmm3, xmm2, xmm2 ; значение следующей итерации
		
		xor r9, r9

	loop_start:
		inc rdx
		vmovsd xmm0, xmm6, xmm6
		call ITERATION_AVX
		vaddsd xmm3, xmm3, xmm0	; i+1 значение
		vmovsd xmm4, xmm0, xmm0	
		vucomisd xmm4, xmm7
		jb loop_end
		jmp loop_start

	loop_end:
		vmovsd xmm0, xmm3, xmm3
		ret
	avx_cosh ENDP

	ITERATION_AVX PROC
		; USES RCX RDX R8 XMM0 XMM1 XMM2
		; IN:
		;	XMM0 - x
		;	RDX - n
		; OUT: 
		;	XMM0 - result

		mov r8, rdx
		imul rdx, 2
		
		CALL POW_AVX

		vmovsd xmm2, xmm0, xmm0 ; x^(2n)


		mov rcx, rdx
		CALL FACTORIAL

		vcvtsi2sd xmm1, xmm1, rax ; (2n)!
		vdivsd xmm2, xmm2, xmm1 ; x^(2n) / (2n)!
		vmovsd xmm0, xmm2, xmm2
		mov rdx, r8
		ret
	ITERATION_AVX ENDP
END

; Third ex
; y = 10 + sum from k = 1 to n of ( -1^(k + 1) * (2k - 1) * x^(2k - 1) )