; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
;  double task7_3(double *x, int n)

option casemap:none

DataSeg SEGMENT ALIGN(32)
        one real4 8 DUP(1.0)
        ten real4 8 DUP(10.0)
        array1 real4 1.3, 2.4, 6.8, 7.2, 4.3, 4.2, 1.1, 0.6
        array1_length = ($ - array1) / TYPE array1
        res_arr1 real4 8 DUP(?)

.CODE
	task7_3 PROC
		; USES
		; IN:
        ;   RCX - n
		; OUT: 
		;	RAX - first el
		; y = 10 + sigma from k = 1 to n of (pow(-1, k + 1) * (2k - 1) * pow(x, 2k - 1))
		; y = y + (+ or -)(2k - 1) * x^(2k - 1)

        vmovaps ymm1, ymmword ptr [array1]          ; ymm1 = x
        vmovaps ymm6, ymmword ptr [ten]             ; ymm6 = y = 10.0

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

        ; RAX = (2k - 1)
        mov rax, r9
        imul rax, 2
        sub rax, 1                        

        ; YMM0 = pow(x, 2k - 1)
        mov rdx, rax                        ; rdx = (2k - 1)
        vmovaps ymm0, ymm1                  ; ymm0 = x
        call POW_AVX                        ; ymm0 = x^(2k - 1)

        ; ymm3 = sign * (2k - 1) = r11d * eax
        vcvtsi2ss xmm2, xmm2, rax       ; xmm2 = (2k - 1) = [ a | a]
        vbroadcastss ymm2, xmm2           ; ymm2 = [ xmm2 | xmm2 ] = [a,a,a,a]

        vcvtsi2ss xmm3, xmm3, r11       ; xmm3 = sign = [ a | a]
        vbroadcastss ymm3, xmm3           ; ymm3 = [a,a,a,a]

        vmulps ymm3, ymm3, ymm2         ; ymm3 = ymm3 * ymm2

        ; y = y + ymm3 * ymm0
        vfmadd231ps ymm6, ymm3, ymm0

        ; k += 1
        inc r9
        jmp loop_start

loop_end:
        vmovaps ymmword ptr [res_arr1], ymm6
        lea rax, res_arr1
        ret
    task7_3 ENDP

	POW_AVX PROC
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
		jz pow_loop_end

		vmovaps ymm1, ymm0          ; ymm1 = x
	pow_loop_start:
		vmulps ymm0, ymm0, ymm1     ; ymm0 *= ymm1
		dec rcx
		jnz pow_loop_start
	pow_loop_end:
		ret

	case_0:
		vmovaps ymm0, ymmword ptr [one]
		ret
	POW_AVX ENDP
END