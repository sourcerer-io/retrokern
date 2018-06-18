; START MAIN PROGRAM

	; clear the screen
	call set_text_mode
	call disable_cursor

	; main loop
.mainloop:
	; display the player avatar
	call display_player

	; halt the CPU until the next interrput
	hlt

	jmp .mainloop
	ret

; END MAIN PROGRAM

display_player:
	pusha

	; set cursor
	mov ah, 0x02
	; mov player_y to dh
	mov dh, [player_y]
	; mov player_x to dl
	mov dl, [player_x]
	int 0x10

	; print the avatar
	mov al, [avatar]
	call putc

	popa
	ret

player_x: db 39
player_y: db 12
avatar: db 1
