; set_txt_mode - Set text mode (80x25x16 colors)
set_text_mode:
	pusha
	mov ax, 0x3
	int 0x10
	popa
	ret

; puts - Print text line
; Put buffer address in SI
puts:
	pusha

.loop:
	lodsb
	cmp al, 0x0
	je .end

	mov ah, 0x0E
	int 0x10

	jmp .loop

.end:
	popa
	ret

; putc - print single character to screen
; Put char to display in AL
putc:
	pusha

	mov ah, 0x0E
	int 0x10

	popa
	ret

; Prints a new line
newline:
	pusha

	mov al, 0x0a
	call putc

	mov al, 0x0d
	call putc

	popa
	ret
