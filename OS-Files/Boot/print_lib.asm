print:
    ; input is address recorded in bx
    pusha

start:
    mov al, [bx]
    cmp al, 0
    je end

    mov ah, 0x0e
    int 0x10

    add bx, 1
    jmp start

end:
    popa
    ret


println:
    ; used to print a new line
    pusha

    mov ah, 0x0e
    mov al, 0x0a ; new line
    int 0x10
    mov al, 0x0d ; back to the first character
    int 0x10

    popa
    ret

; A-Z 0x41-0x5A
; a-z 0x7A-0x61
; 0-9 0x30-0x39

print_hex:
    ; used to print a heximal number
    ; heximal number should be saved in dx

    pusha

    mov cx, 0

hex_start:
    cmp cx, 4
    je hex_end

    mov ax, dx
    and ax, 0x000f
    add al, 0x30
    cmp al, 0x39 ; if it is a number 0~9
    jle setnum

    cmp al, 0x61 ; if it is a minimal alphabeta
    jge setmin

    add al, 0x07 ; if it is a capital alphabeta, add 7 to convert it to A-Z
    jmp setnum

setmin:
    add al, 0x2e ; 97 - 58 + 7 = 46 = 0x2E

setnum:
    mov bx, HEX_OUT + 5
    sub bx, cx
    mov [bx],al
    ror dx, 4 ; rotate 4 bits

    add cx, 1
    jmp hex_start

hex_end:
    mov bx, HEX_OUT
    call print

    popa
    ret


HEX_OUT:
db '0x0000', 0