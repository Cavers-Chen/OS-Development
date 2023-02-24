mov ah, 0x0e ; tty mode
mov al, 'C'
int 0x10
mov al, 'a'
int 0x10
mov al, 'v'
int 0x10
mov al, 'e'
int 0x10
mov al, 'r'
int 0x10
mov al, 's'
int 0x10

jmp $ ; jump to current address = infinite loop

; padding and magic number
times 510 - ($-$$) db 0
dw 0xaa55 