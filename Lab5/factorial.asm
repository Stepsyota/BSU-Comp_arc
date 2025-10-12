.CODE
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
END