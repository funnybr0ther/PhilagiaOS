%define BASE 0x100 ; 0x0100:0x0 = 0x1000
%define KSIZE 50 ; nombre de secteurs de 512 a charger

bits 16
org 0x0

jmp start
%include "UTIL.INC"
start:
    mov ax, 0x07c0 ; set up 4K stack space after this bootloader
    mov ds, ax
    mov es, ax
    mov ax, 0x8000 ; stack en 0xffff
    mov ss, ax
    mov sp, 0xf000

    mov [bootdrv], dl

    mov si, message
    call afficher

; charger le noyau
    xor ax, ax
    int 0x13

    push es
    mov ax, BASE
    mov es, ax
    mov bx, 0
    mov ah, 2
    mov al, KSIZE
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrv]
    int 0x13
    pop es

    ; initialisation du pointeur sur la GDT
    mov ax, gdtend ; calcule la limite de GDT
    mov bx, gdt
    sub ax, bx
    mov word [gdtptr], ax

    xor eax, eax ; calcule l'adresse lineaire de GDT
    xor ebx, ebx
    mov ax, ds
    mov ecx, eax
    shl ecx, 4
    mov bx, gdt
    add ecx, ebx
    mov dword [gdtptr+2], ecx

    ; passage en modep
    cli
    lgdt [gdtptr] ; charge la gdt
    mov eax, cr0
    or ax, 1
    mov cr0, eax

    jmp next
next:
    mov ax, 0x10 ; segment de donne
    mov ds, ax
    mov fs, ax
    mov gs, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x9f000

    jmp dword 0x8:1000 ; reinitialise le segment de code

; ---
bootdrv: db 0
message: db "Chargement du Kernel", 13, 10, 0
; ---
gdt: db 0, 0, 0, 0, 0, 0, 0, 0
gdt_cs: db 0xff, 0xff, 0x0, 0x0, 0x0, 10011011b, 11011111b, 0x0
gdt_ds: db 0xff, 0xff, 0x0, 0x0, 0x0, 10010011b, 11011111b, 0x0
gdtend:
; ---
gdtptr:
    dw 0 ; limite
    dd 0 ; base

; for a 512 bytes binary file
times 510-($-$$) nop
dw 0xAA55
