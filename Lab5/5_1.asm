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
	
	movq xmm3, 0
	movsd xmm3, xmm4
	subsd xmm4, 
		

		ret
	first_cosh ENDP

	ITERATION PROC

		ret
	ITERATION ENDP
END

; Third ex
; y = 10 + sum from k = 1 to n of ( -1^(k + 1) * (2k - 1) * x^(2k - 1) )