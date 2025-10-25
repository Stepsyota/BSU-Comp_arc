.DATA
    ALIGN 16
    one real4 1.0, 1.0, 1.0, 1.0

.CODE
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