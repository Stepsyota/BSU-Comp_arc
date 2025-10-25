;  double fma_poly(double x, int n)

option casemap:none

extern POW_AVX:PROC
.DATA
    ten real8 10.0

.CODE
	fma_poly PROC
		; USES XMM0 RDX
		; IN:
		;	XMM0 - x
		;	RDX - n
		; OUT: 
		;	XMM0 - result
		; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
		; y = y + (+ or -)(2k - 1) * x^(2k - 1)

        vmovsd xmm1, xmm1, xmm0             ; xmm1 = x
        vmovsd xmm6, qword ptr [ten]        ; xmm5 = y = 10.0

        mov r8, rdx                        ; r8 = n (кол-во итераций)
        mov r9, 1                          ; r9 = k = 1

loop_start:
        cmp r9, r8
        jg loop_end                        ; если k > n - конец цикла

        ; R11 = sign = (-1)^(k+1)
        mov r10, r9
        add r10, 1
        test r10, 1
        jz sign_pos
        mov r11, -1
        jmp sign_ready
sign_pos:
        mov r11, 1
sign_ready:

        ; RAX = (2k - 1)
        mov rax, r9
        imul rax, 2
        sub rax, 1                        

        ; XMM4 = pow(x, 2k - 1)
        mov rdx, rax                       ; rdx = (2k - 1)
        vmovsd xmm0, xmm1, xmm1            ; xmm2 = x
        call POW_AVX                       ; XMM0 = x^(2k - 1)
        vmovsd xmm4, xmm4, xmm0            ; XMM44 = pow(x, 2k - 1)

        ; xmm3 = sign * (2k - 1) = r11 * rax
        vcvtsi2sd xmm2, xmm2, rax          ; xmm2 = (2k - 1)
        vcvtsi2sd xmm5, xmm5, r11          ; xmm5 = sign
        vmulsd xmm3, xmm2, xmm5      ; xmm3 = xmm2 * xmm5

        ; y = y + xmm3 * xmm4
        vfmadd231sd xmm6, xmm3, xmm4       ; xmm0 = (xmm3 * xmm4) + xmm6

        ; k += 1
        inc r9
        jmp loop_start

loop_end:
        vmovsd xmm0, xmm6, xmm6
        ret
    fma_poly ENDP
END