;  double fma_poly(double x, int n)

option casemap:none

extern POW_AVX:PROC

.CODE
	fma_poly PROC
		; USES XMM0 RDX
		; IN:
		;	XMM0 - x
		;	RDX - n
		; OUT: 
		;	XMM0 - result
		; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
		; y = 10 + (+ or -)(2k - 1) * x^(2k - 1)

			vmovmsd xmm1, xmm0, xmm0 ; xmm1 содержит x
			vmovmsd xmm0, 0 ; будет содержать результат
			mov r10, rdx ; n
			mov rdx, 1 ; rdx содержит текущую итерацию

			test rdx, 1


				ret
	fma_poly ENDP

	FMA_ITER PROC
		; USES XMM0 RDX
		; IN:
		;	XMM0 - x
		;	RDX - k (текущая итерация)
		; OUT: 
		;	XMM0 - result
		; (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1)
	
			mov r10, rdx	; temp rdx

			; (2k - 1)
			mov r11, rdx
			mov rax, 2
			mul r11
			inc rax
			xchg r11, rax

			mov rdx, r11
			CALL POW_AVX

			mov rax, rdx
			xchg rax, rdx
			div rdx
			test rdx, rdx
			jz even_iter
			jmp odd_iter

		even_iter:
			; pow(-1, k + 1) == -1
			imul r11, -1
			vcvtsi2sd xmm1, xmm1, rdx
			vmulsd xmm0, xmm0, xmm1
			ret

		odd_iter:
			; pow(-1, k + 1) == 1
			vcvtsi2sd xmm1, xmm1, rdx
			vmulsd xmm0, xmm0, xmm1
			ret

			ret
	FMA_ITER ENDP
END