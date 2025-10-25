; ƒл€ заданных массивов A, B и C дл€ каждого i,
; если A[i] четное, C[i] := A[i] + B[i],
; иначе C[i] := A[i] Ц B[i].

option casemap:none

.DATA
    ALIGN 16
        A sdword 2, 2, 5, -1
        B sdword -4, 1, 2, 8
        C sdword ?, ?, ?, ?
        n = ($ - A) / TYPE A
        one dword 4 DUP(1)

.CODE
    task6_1 PROC

    movdqa xmm0, xmmword ptr [A]            ; xmm0 = A
    movdqa xmm1, xmmword ptr [B]            ; xmm1 = B

    movdqa xmm2, xmm0                       ; A

    movdqa xmm3, xmmword ptr [one]          ; [1, 1, 1, 1]
    pand xmm2, xmm3                         ; xmm2 = A[i] & 1 (0 Ч четное, 1 Ч нечетное)

    movdqa xmm4, xmm0                       ; A
    paddd xmm4, xmm1                        ; xmm4 = A + B

    movdqa xmm5, xmm0                       ; A
    psubd xmm5, xmm1                        ; xmm5 = A - B

    pxor xmm6, xmm6
    pcmpeqd xmm6, xmm2                      ; xmm6 = дл€ четных = 11...1, дл€ нечетных = 00...0

    ; ≈сли четное берем из xmm4 (A+B), иначе  из xmm5 (A-B)
    movdqa xmm7, xmm6
    pand xmm7, xmm4                         ; xmm7 = (A+B) дл€ чЄтных
    pandn xmm6, xmm5                        ; xmm6 = (A-B) дл€ нечЄтных
    por xmm7, xmm6                          ; xmm7 = результат

    movdqa xmmword ptr [C], xmm7

    lea rax, [C]
    ret
    task6_1 ENDP
END
