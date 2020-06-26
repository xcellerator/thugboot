org 0x7C00                      ; Load into memory address 0x7c00, gives us 0x400 bytes to play with before the kernel is loaded at 0x8000

; Initialize registers and setup the stack for QEMU
;       cli                     ; Turn off maskable interrupts
;       xor ax, ax
;       mov ds, ax
;       mov ss, ax
;       mov es, ax
;       mov fs, ax
;       mov gs, ax
;       mov sp, 0x6ef0          ; QEMU requirement
;       sti                     ; Turn on maskable interrupts

; Reset Disks
;       mov ah, 0               ; AH = 0        ; Reset Floppy/Harddisk
;       mov dl, 0               ; DL = 0        ; Drive Number
;       int 0x13                ; Mass Storage Interrupt        ; AH = Status

; Read from Harddisk and write to RAM
        mov ah, 2               ; AH = 2        ; Read Floppy/Harddisk in CHS Mode
        mov al, 2               ; AL = 2        ; Number of sectors to read

        mov bx, 0x8000          ; BX = 0x8000   ; Location to store read data - Kernel gets loaded to 0x800

        mov ch, 0               ; CX = 0        ; Cylinder/Track
        mov cl, 2               ; CL = 2        ; Sector

        mov dh, 0               ; DH = 0        ; Head

        int 0x13                ; Mass Storage Interrupt        ; AH = Status, AL = Bytes Read

; Jump to the Kernel
        jmp 0x8000              ; Pass execution to the kernel


; MBR Signature
        times 510-($-$$) db 0   ; Fill remaining (up to byte 510) with 0x0      ; $ = Current Position, $$ = Beginning
        db 0x55                 ; Byte 511 = 0x55
        db 0xAA                 ; Byte 512 = 0xAA
