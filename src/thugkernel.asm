org 0x8000				; We are loaded from memory address 0x8000
bits 16					; 16-Bit Real Mode

; Entry Point
_start:
	call clearScreen
	call setCursor
	mov si, logo			; Load address of logo into SI register
	call printString		; Print the string stored in [SI]
	call waitForKeypress		; Wait for input to repeat logo animation

	jmp $   			; Freezes the system
	hlt				; Halt's a real machine
	ret     			; Halt's QEMU

; Prints an ASCII character stored in AL
printChar:
	mov ah, 0x0e			; AH = 0x0e		; Display Character (TTY Output)
	mov bh, 0x0 			; BH = 0x0		; Page to write to
	mov bl, 0x0			; BL = 0x0		; Foreground Colour
	int 0x10 			; Graphics Interrupt	; Nothing Returned
	ret

; Delay 5 milliseconds (used in-between printing characters for a cheap animation)
delay:
	pusha				; Prologue - Save registers to stack
	mov ah, 0x86			; AH = 0x86		; BIOS wait
	mov al, 0			; AL = 0		; Not used
	mov cx, 0			; CX = 0		; Seconds
	mov dx, 5			; DX = 5		; Milliseconds
	int 0x15			; Memory Interrupt	; AH = Status
	popa				; Epilogue - Restore registers from stack
	ret
	
; Print a NULL-terminated string with memory location stored in SI
printString:
	pusha				; Prologue - Save registers to stack
	.loop:
		lodsb 			; Loads 1 byte from SI into  AL, increments SI
		test al, al 		; Check for NULL byte
		jz .end
		call printChar 		; Print stored in character in AL
		call delay		; Wait 5 milliseconds
	jmp .loop
	.end:
		popa			; Epilogue - Restore registers from stack
		ret

; Sit idle until a keypress is received, then jump to 0x8000
waitForKeypress:
	pusha				; Prologue - Save registers to stack
	mov ah, 0x0			; AH = 0x0		; Get keystroke
	int 0x16			; Keyboard Interrupt	; AH = BIOS Scan Code, AL = ASCII Char
	popa				; Epilogue - Restore registers from stack
	jmp _start			; Jump to 0x8000 (Repeat the animation)

; Clear the entire screen (BIOS Splash, etc)
clearScreen:
	pusha				; Prologue - Save registers to stack
	mov ah, 0x06			; AH = 0x06		; Scroll Up Window
	xor al, al			; AL = 0x00		; Number of lines (0x00 to scroll entire window)
	mov bh, 0x03			; BH = 0x03		; Colour Attribute
	xor cx, cx			; CH = 0x00, CL = 0x00	; Row,Column of Upper-Left Hand Corner
	mov dx, 0x184F			; DH = 0x18, DL = 0x4F	; Row,Column of Lower-Right Hand Corner
	int 0x10			; Graphics Interrupt	; Nothing returned
	popa				; Epilogue - Restore registers from stack
	ret

; Position the cursor in the right position before we start printing text
setCursor:
	pusha				; Prologue - Save registers to stack
	mov ah, 0x02			; AH = 0x02		; Set Cursor Position
	mov bh, 0x00			; BH = 0x00		; Page Number (0x00 = Graphics Mode)
	mov dh, 2			; DH = 2		; Row (Almost the top of the screen)
	mov dl, 0			; DL = 2		; Column (Far left side of the screen)
	int 0x10			; Graphics Interrupt	; Nothing returned
	popa				; Epilogue - Restore registers from stack
	ret

logo db 	'                 ______________     ______      ___', 0xA, 0xD, '                 \   _    _   /----/     /_____/   \________', 0xA, 0xD, '                 /___/    /___\  _/     //    /    /   _    \', 0xA, 0xD, '                    /    //      \     //    /    /    /    /', 0xA, 0xD, '                   /_____\       /_____\ _________\_____   /', 0xA, 0xD, '                          \_____/       \/     \___________\', 0xA, 0xD, 0xA, 0xD, '              _________  ___________ ________ _______   _________', 0xA, 0xD, '            _/        /_ )   ._    //  __    X      /___\______  \', 0xA, 0xD, '            \     |__/  \_   |/  _/     /   //     /      /   /   >', 0xA, 0xD, '             \    |       /  /    \_   /    /_    /\     /   /   /', 0xA, 0xD, '              \__________/   \      /______/ /____/\___  X      /', 0xA, 0xD, '                        \___/ \____/                   \/ \____/', 0xA, 0xD, 0xA, 0xD, '                              www.thugcrowd.com', 0

times 1024-($-$$) db 0 			; Kernel needs to be a multiple of 512, so pad to correct size
