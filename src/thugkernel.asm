org 0x8000 
bits 16

_start:
	call clearScreen		; Clear the screen
	call setCursor			; Set cursor
	mov si, logo			; Load the thugcrowd logo
	call printNullTerminatedString
	call repeat

	jmp $   			; This freezes the system, best for testing
	hlt				; This makes a real system halt
	ret     			; This makes qemu halt, to ensure everything works we add both

printCharacter:
					; Before calling this function al must be set to the character to print
	mov bh, 0x00 			; Page to write to, page 0 is displayed by default
	mov bl, 0x00			; Colour attribute
	mov ah, 0x0E 			; Print character function
	int 0x10 			; int 0x10, 0x0E = print character in al
	ret

delay:
	pusha
	mov al, 0
	mov ah, 0x86			; Wait function
	mov cx, 0			; Seconds
	mov dx, 5			; Milliseconds
	int 0x15			; int 0x15, 0x86 = wait for cx,dx seconds
	popa
	ret
	
printNullTerminatedString:
	pusha
	.loop:
		lodsb 			; Loads byte from si into al and increases si
		test al, al 		; Test if al is 0 which would mean the string reached it's end
		jz .end
		call printCharacter 	; Print character in al
		call delay
	jmp .loop 			; Print next character
	.end:
	popa
	ret

repeat:
	pusha
	mov ah, 0x0			; Wait for keypress function
	int 0x16			; int 0x16, 0x0 = wait for key press
	jmp _start			; Loop back to _start after key is pressed

clearScreen:
	pusha
	mov ah, 0x06			; Scroll up function
	xor al, al			; Clear entire screen
	xor cx, cx			; Upper left corner
	mov dx, 0x184F			; Lower right corner
	mov bh, 0x05			; Colour: (1 = Blue) , (7 = White)
	int 0x10			; int 0x10, 0x06 = Scroll up
	popa
	ret

setCursor:
	pusha
	mov ah, 0x2			; Set cursor function
	mov bh, 0x0			; Video page
	mov dl, 0			; Column 0 (left side of screen)
	mov dh, 2			; Row 2 (almost top of screen)
	int 0x10			; int 0x10, 0x2 = Set cursor
	popa
	ret

logo db 	'                 ______________     ______      ___', 0xA, 0xD, '                 \   _    _   /----/     /_____/   \________', 0xA, 0xD, '                 /___/    /___\  _/     //    /    /   _    \', 0xA, 0xD, '                    /    //      \     //    /    /    /    /', 0xA, 0xD, '                   /_____\       /_____\ _________\_____   /', 0xA, 0xD, '                          \_____/       \/     \___________\', 0xA, 0xD, 0xA, 0xD, '              _________  ___________ ________ _______   _________', 0xA, 0xD, '            _/        /_ )   ._    //  __    X      /___\______  \', 0xA, 0xD, '            \     |__/  \_   |/  _/     /   //     /      /   /   >', 0xA, 0xD, '             \    |       /  /    \_   /    /_    /\     /   /   /', 0xA, 0xD, '              \__________/   \      /______/ /____/\___  X      /', 0xA, 0xD, '                        \___/ \____/                   \/ \____/', 0xA, 0xD, 0xA, 0xD, '                              www.thugcrowd.com', 0

times 1024-($-$$) db 0 			; Kernel must have size multiple of 512 so let's pad it to the correct size