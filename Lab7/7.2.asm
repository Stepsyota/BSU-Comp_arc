; Ќормировать заданный вектор x, т. е. разделить каждый его элемент на
; длину вектора |x| = sqrt(sigma from k = 1 to n of pow(x_k, 2)

option casemap:none

DataSeg SEGMENT ALIGN(32)
	X real4 2.0, -3.2, 4.2, 10.2, 12.3, 14.2, 3.01, 3.25
	X_res real4 8 DUP(?)

.CODE
	task7_2 PROC
		vmovaps ymm0, ymmword ptr [X]		; X
		vmulps ymm1, ymm0, ymm0				; X^2

		; ymm1 = [ a1 | a2 | a3 | a4 ]
		vextractf128 xmm2, ymm1, 1          ; [ a3 | a4]
		vaddps xmm1, xmm1, xmm2             ; [ a1 + a3 | a2 + a4 ]
		vhaddps xmm1, xmm1, xmm1
		vhaddps xmm1, xmm1, xmm1			; [ a1 + a3 + a2 + a4 | a2 + a4 + a1 + a3 ]

		vsqrtps xmm1, xmm1
		vbroadcastss ymm1, xmm1

		vdivps ymm2, ymm0, ymm1
		vmovaps ymmword ptr [X_res], ymm2
		lea rax, [X_res]
		ret
	task7_2 ENDP
END