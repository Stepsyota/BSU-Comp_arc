;  double fma_poly(double x, int n);

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

			test rdx, rdx
			jz fma_error
			
			mov rcx, 1
			xchg rcx, rdx ; В RCX - n (кол-во итераций), в RDX - 1 (номер текущей итерации)

			vmovsd xmm6, xmm0, xmm0 ; значение x
			vxorps xmm7, xmm7, xmm7 ; будет храниться сумма итераций

			CALL FMA_ITER
			vmovsd xmm7, xmm7, xmm0 ; первая итерация

			loop_start:
				inc rdx
				vmovsd xmm0, xmm6, xmm6
				call FMA_ITER
				vaddsd xmm7, xmm7, xmm0
				cmp rdx, rcx
				jae loop_end
				jmp loop_start

			loop_end:
				vmovsd xmm0, xmm6, xmm6
				mov eax, 10
				vcvtsi2sd xmm6, xmm6, eax
				vaddsd xmm0, xmm0, xmm6
				ret

			fma_error:
				ret
	fma_poly ENDP

	FMA_ITER PROC
		; USES XMM0 RDX
		; IN:
		;	XMM0 - x
		;	RDX - k (текущая итерация)
		; OUT: 
		;	XMM0 - result
			mov rax, rdx
			mov r10, rdx
			div 2
			test rdx, rdx
			jz even_iter
			jmp odd_iter

		even_iter:
			; pow(-1, k + 1) == -1
			ret

		odd_iter:
			; pow(-1, k + 1) == 1
			ret

			ret
	FMA_ITER ENDP
END