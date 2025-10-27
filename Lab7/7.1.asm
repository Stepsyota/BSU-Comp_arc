; ��� �������� �������� A, B � C ��� ������� i,
; ���� A[i] ������, C[i] := A[i] + B[i],
; ����� C[i] := A[i] � B[i].

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

    vpand ymm2, ymm0, ymmword ptr [one]            ; ymm2 = A[i] & 1 (0 � ������, 1 � ��������)

    vpaddd ymm3, ymm0, ymm1                        ; ymm3 = A + B
    vpsubd ymm4, ymm0, ymm1                        ; ymm4 = A - B

    vpcmpeqd ymm5, ymm2, ymmword ptr [one]         ; ymm5 = ��� �������� = 11...1, ��� ������ = 00...0

    ; ���� ������ ����� �� ymm4 (A+B), ����� �� ymm5 (A-B)
    vpand ymm6, ymm5, ymm4                         ; ymm6 = (A-B) ��� ��������
    vpandn ymm7, ymm5, ymm3                        ; ymm7 = (A+B) ��� ������
    vpor ymm6, ymm6, ymm7                          ; ymm7 = ���������

    vmovdqa ymmword ptr [C], ymm6

    lea rax, [C]
    ret
    task7_1 ENDP
END
