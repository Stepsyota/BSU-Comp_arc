; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
;  double task7_3(double *x, int n)

option casemap:none

.DATA
    ALIGN 16
        one real4 1.0, 1.0, 1.0, 1.0
        ten real4 10.0, 10.0, 10.0, 10.0
        array1 real4 1.3, 2.4, 6.8, 7.2
        array1_length = ($ - array1) / TYPE array1
        res_arr1 real4 ?, ?, ?, ?  

.CODE
	task7_3 PROC
		; USES
		; IN:
        ;   RCX - n
		; OUT: 
		;	RAX - first el
		; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
		; y = y + (+ or -)(2k - 1) * x^(2k - 1)

        movaps xmm1, [array1]          ; xmm1 = x
        movaps xmm6, [ten]             ; xmm5 = y = 10.0

        mov r8, rcx                        ; r8 = n (кол-во итераций)
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

        ; EAX = (2k - 1)
        mov eax, r9d
        imul eax, 2
        sub eax, 1                        

        ; XMM4 = pow(x, 2k - 1)
        mov rdx, rax                       ; rdx = (2k - 1)
        movaps xmm0, xmm1                   ; xmm2 = x
        call POW_SSE                       ; XMM0 = x^(2k - 1)
        movaps xmm4, xmm0                   ; XMM4 = pow(x, 2k - 1)

        ; xmm3 = sign * (2k - 1) = r11d * eax
        cvtsi2ss xmm2, eax          ; xmm2 = (2k - 1)
        shufps xmm2, xmm2, 0       ; [a,a,a,a]
        cvtsi2ss xmm3, r11d          ; xmm3 = sign
        shufps xmm3, xmm3, 0    ; [a,a,a,a]
        mulps xmm3, xmm2      ; xmm3 = xmm3 * xmm2

        ; y = y + xmm3 * xmm4
        mulps xmm4, xmm3
        addps xmm6, xmm4

        ; k += 1
        inc r9
        jmp loop_start

loop_end:
        movaps [res_arr1], xmm6
        lea rax, res_arr1
        ret
    task7_3 ENDP

	POW_SSE PROC
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

		movaps xmm1, xmm0
	loop_start:
		mulps xmm0, xmm1
		dec rcx
		jnz loop_start
	loop_end:
		ret

	case_0:
		movaps xmm0, [one]
		ret
	POW_SSE ENDP
END