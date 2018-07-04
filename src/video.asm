; set_txt_mode - Set text mode (80x25x16 colors)
set_text_mode:
	push ax
	mov ax, 0x3
	int 0x10
	pop ax
	ret

; puts - Print text line
; Put buffer address in SI
puts:
	push ax

.loop:
	lodsb
	cmp al, 0x0
	je .end

	mov ah, 0x0E
	int 0x10

	jmp .loop

.end:
	pop ax
	ret

; putc - print single character to screen
; Put char to display in AL
putc:
	push ax

	mov ah, 0x0E
	int 0x10

	pop ax
	ret

; Prints a new line
newline:
	push ax

	mov al, 0x0a
	call putc

	mov al, 0x0d
	call putc

	pop ax
	ret

disable_cursor:
	push ax
	push cx

	; call BIOS to disable cursor, set cursor shape to 3F (none)
	mov ah, 0x01
	mov ch, 0x3F
	int 0x10

	pop cx
	pop ax
	ret

enable_cursor:
	push ax
	push cx

	mov ah, 0x01
	mov ch, 0x0
	int 0x10

	pop cx
	pop ax
	ret
