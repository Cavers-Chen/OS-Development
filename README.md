# My OS-Development Note

I followed this [tutorial](https://github.com/cfenollosa/os-tutorial).

Enverionment: 
* Ubuntu20.03
* QEMU
* NASM

## 1 Boot Computer

At the beginning, computer need to boot firstly. And of course, there is a way for computer do achieve this goal.

Computer will use BIOS to check if it is 0XAA55 at the bytes 511 and 512. If it is, then I say this computer is "bootable".

At the meantime, before 0XAA55, those codes would be boot code.

Such like: 

E9 D5 FF ... (your boot code in 16-bits value) ... AA 55 (that is the end) 

this is a very simple boot program, in assembler code, it will be:
```
; Infinite loop (e9 fd ff)
loop:
    jmp loop 

; Fill with 510 zeros minus the size of the previous code
times 510-($-$$) db 0
; Magic number
dw 0xaa55 
```
Copy this to a file, named xxx.asm, then use nasm to compile this file.

```
nasm -f bin xxx.asm -o xxx.bin
```
Then you will have a binary file, run it with qemu.
```
qemu xxx.bin
```
You will see a black window without error.

As we know, in assemble language, we can use AL register to print some letter by calling interrupt 0x10. So, let's do this.

```
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
```

This time, when computer boot, you will see "Cavers"


