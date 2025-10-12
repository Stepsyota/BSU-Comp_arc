.CODE
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
		jz loop_end

		vmovsd xmm1, xmm0, xmm0
	loop_start:
		vmulsd xmm0, xmm0, xmm1
		dec rcx
		jnz loop_start
	loop_end:
		ret

	case_0:
		mov rcx, 1
		vcvtsi2sd xmm0, xmm0, rcx
		ret
	POW_AVX ENDP
END