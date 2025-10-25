; Ќормировать заданный вектор x, т. е. разделить каждый его элемент на
; длину вектора |x| = sqrt(sigma from k = 1 to n of pow(x_k, 2)

option casemap:none

DataSeg SEGMENT ALIGN(32)
	X real8 2.0, -3.2, 4.2, 10.2
	X_res real8 4 DUP(?)

.CODE
	task7_2 PROC
		vmovapd ymm0, ymmword ptr [X]		; X
		vmulpd ymm1, ymm0, ymm0				; X^2

		; ymm1 = [ a1 | a2 | a3 | a4 ]
		vextractf128 xmm2, ymm1, 1          ; [ a3 | a4]
		vaddpd xmm1, xmm1, xmm2             ; [ a1 + a3 | a2 + a4 ]
		vhaddpd xmm1, xmm1, xmm1            ; [ a1 + a3 + a2 + a4 | a2 + a4 + a1 + a3 ]

		vsqrtpd xmm1, xmm1
		vbroadcastsd ymm1, xmm1

		vdivpd ymm2, ymm0, ymm1
		vmovapd ymmword ptr [X_res], ymm2
		lea rax, [X_res]
		ret
	task7_2 ENDP
END