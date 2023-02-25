# My OS-Development Note

I followed this [document](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf) + [tutorial](https://github.com/cfenollosa/os-tutorial).

Enverionment: 
* Ubuntu20.03
* QEMU
* NASM

## 1 Boot Computer

At the beginning, computer need to boot firstly. And of course, there is a way for computer do achieve this goal.

Computer will use BIOS to check if it is 0XAA55 at the bytes 511 and 512. If it is, then we say this computer is "bootable".

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

```
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
|                                       |
|                                       |
|                                       |
|               FREE                    |
|                                       |
|                                       |
|_______________________________________|<--0x100000
|            BIOS(256KB)                |
|_______________________________________|<--0xC0000
|         Video Memory(128KB)           |
|_______________________________________|<--0xA0000
|      Extended BIOS Data Area(638KB)   |
|_______________________________________|<--0x9FC00
|              Free(638KB)              |
|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|<--0x7E00
|      Loaded Boot Sector(512 Bytes)    |
|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|<--0x7C00
|                                       |
|_______________________________________|<--0x500
|         BIOS Data Area(256Bytes)      |
|_______________________________________|<--0x400
|      Interrupt Vector Table(1KB)      |
|_______________________________________|<--0x0

```


```
je target ; jump if equal ( i.e. x == y )

jne target ; jump if not equal ( i.e. x != y )

jl target ; jump if less than ( i.e. x < y )

jle target ; jump if less than or equal ( i.e. x <= y )

jg target ; jump if greater than ( i.e. x > y )

jge target ; jump if greater than or equal ( i.e. x >= y )
```

es ds cs ss

es:[address]/address before setting ds

Next, we need to load our disk content to our computer. How to do this? Computer will scan the disk 512KB per sector, and of course, powerful BIOS will help us to deal with this problem. We can use the regular disk scanning scheme which is already defined in BIOS by using interrupt features.

Because our boot program is written on the first sector of our boot disk, so we need to change our segment registers to access higher physical address. And use interrupt features to let computer to scan right sector with CHS scheme(Cylinder Header Sector).

After that, we can alter real mode to protected mode. As a result, we are able to use 32 or even 64 mode.
