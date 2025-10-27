; ƒл€ заданных массивов A, B и C дл€ каждого i,
; если A[i] четное, C[i] := A[i] + B[i],
; иначе C[i] := A[i] Ц B[i].

option casemap:none

DataSeg SEGMENT ALIGN(32)
        A sqword 2, 2, 5, -1
        B sqword -4, 1, 2, 8
        C sdword 8 DUP(?)
        one dword 8 DUP(1)

.CODE
    task7_1 PROC

    vmovdqa ymm0, ymmword ptr [A]                  ; ymm0 = A
    vmovdqa ymm1, ymmword ptr [B]                  ; ymm1 = B

    vpand ymm2, ymm0, ymmword ptr [one]            ; ymm2 = A[i] & 1 (0 Ч четное, 1 Ч нечетное)

    vpaddd ymm3, ymm0, ymm1                        ; ymm3 = A + B
    vpsubd ymm4, ymm0, ymm1                        ; ymm4 = A - B

    vpcmpeqd ymm5, ymm2, ymmword ptr [one]         ; ymm5 = дл€ нечетных = 11...1, дл€ четных = 00...0

    ; ≈сли четное берем из ymm4 (A+B), иначе из ymm5 (A-B)
    vpand ymm6, ymm5, ymm4                         ; ymm6 = (A-B) дл€ нечЄтных
    vpandn ymm7, ymm5, ymm3                        ; ymm7 = (A+B) дл€ чЄтных
    vpor ymm6, ymm6, ymm7                          ; ymm7 = результат

    vmovdqa ymmword ptr [C], ymm6

    lea rax, [C]
    ret
    task7_1 ENDP
END
