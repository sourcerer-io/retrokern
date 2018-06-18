; Keyboard scan codes
%define K_UP 	"w"
%define K_DOWN 	"s"
%define K_LEFT	"a"
%define K_RIGHT "d"

; START MAIN PROGRAM

	; clear the screen
	call set_text_mode
	call disable_cursor

	; main loop
.mainloop:
	; display the player avatar
	call display_player

.inputloop:

	; This could be done with non-blocking code by setting
	; al to 0x1, but this is fine for our purposes

	xor ax, ax
	int 0x16

	; AL will have ascii code

	; if up
	cmp al, K_UP
	je .key_up

	; if down
	cmp al, K_DOWN
	je .key_down

	; if left
	cmp al, K_LEFT
	je .key_left

	; if right
	cmp al, K_RIGHT
	je .key_right

	; go back to the main loop
	jmp .inputloop

.key_up:
	call display_player_void
	dec byte [player_y]
	jmp .mainloop

.key_down:
	call display_player_void
	inc byte [player_y]
	jmp .mainloop

.key_left:
	call display_player_void
	dec byte [player_x]
	jmp .mainloop

.key_right:
	call display_player_void
	inc byte [player_x]
	jmp .mainloop

; END MAIN PROGRAM

; Display the character's avatar
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

; Clear the avatar display
display_player_void:
	pusha

	; set cursor
	mov ah, 0x02
	; mov player_y to dh
	mov dh, [player_y]
	; mov player_x to dl
	mov dl, [player_x]
	int 0x10

	; print a blank space
	mov al, 0
	call putc

	popa
	ret

; Player location
player_x: db 39
player_y: db 12

; Avatar character
avatar: db 1

; Empty character
empty_char: db 0
