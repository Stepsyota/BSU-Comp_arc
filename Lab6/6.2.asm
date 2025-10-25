; Нормировать заданный вектор x, т. е. разделить каждый его элемент на
; длину вектора |x| = sqrt(sigma from k = 1 to n of pow(x_k, 2)

option casemap:none

.DATA
	ALIGN 16
	X real4 2.0, -3.2, 4.2, 10.2
	X_res real4 4 DUP(?)

.CODE
	task6_2 PROC
		movaps xmm0, [X]
		movaps xmm1, xmm0	; X
		movaps xmm2, xmm0	; X

		mulps xmm2, xmm2	; X^2
		; Горизонтальное суммирование xmm2 = [ f3| f2| f1| f0]
		haddps xmm2, xmm2 ; xmm2 = [f3+f2|f1+f0|f3+f2|f1+f0]
		haddps xmm2, xmm2 ; xmm2 = [ sum| sum| sum| sum]

		sqrtps xmm2, xmm2

		divps xmm1, xmm2
		movaps X_res, xmm1
		lea rax, [X_res]
		ret
	task6_2 ENDP
END