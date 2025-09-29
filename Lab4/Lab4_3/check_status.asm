;  int8_t check_status(uint8_t k, uint8_t l, uint8_t m, uint8_t n);

option casemap:none

.CODE
  check_status PROC
    ; На поле (k, l) стоит ладья, на поле (m, n) — пешка. Определить, бьет ли
    ; ладья пешку, пешка — ладью или фигуры не угрожают друг другу.
    ; cl - k
    ; dl - l
    ; r8b - m
    ; r9b - n

    mov al, cl
    mov bl, dl
    mov cl, r8b
    mov dl, r9b

      ; if (k,l,m,n > 8)
      ;  Неправильные координаты
      cmp al, 8
      ja ERROR
      cmp bl, 8
      ja ERROR
      cmp cl, 8
      ja ERROR
      cmp dl, 8
      ja ERROR
      ; if (k,l,m,n == 0)
      ;  Неправильные координаты
      cmp al, 0
      je ERROR
      cmp bl, 0
      je ERROR
      cmp cl, 0
      je ERROR
      cmp dl, 0
      je ERROR

      ; if (k == m):
      ;  if (l == n):
      ;    Фигуры стоят на одной клетке
      cmp al, cl
      jne Rook_check
      cmp bl, dl
      jne Rook_check
      jmp ERROR

    Rook_check:
      ; if (k == l or n == m):
      ;  Ладья бьет пешку  
      cmp al, cl
      je ROOK
      cmp bl, dl
      je ROOK
      jmp Pawn_check_y

    Pawn_check_y:
      ; if (k == m + 1 or k == m - 1) and (l == n + 1):
      ;  Пешка бьет ладью
      ;
      ; if (l == n + 1):
      mov dh, dl
      add dh, 1
      cmp dh, 8
      jg PEACEFUL
      cmp bl, dh
      jne PEACEFUL
      jmp Pawn_check_x_1

      ; if (k == m + 1):
    Pawn_check_x_1:
      mov ch, cl
      add ch, 1
      cmp ch, 8
      jg Pawn_check_x_2
      cmp al, ch
      je PAWN

      ; if (k == m - 1):
    Pawn_check_x_2:
      mov ch, cl
      sub ch, 1
      jz PEACEFUL
      cmp al, ch
      je PAWN
      jmp PEACEFUL

    PAWN:
      mov al, 1
      ret
    ROOK:
      mov al, 2
      ret
    PEACEFUL:
      mov al, 0 
      ret

    ERROR:
      mov al, -1
      ret
  check_status ENDP
END
