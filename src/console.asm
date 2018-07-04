; getchar()
; Returns keyboard press in AX
getchar:
	push ax
	mov ax, 0x0
	int 0x16

	mov [.chr], ax
	pop ax
	mov ax, [.chr]
	ret

	.chr: dw 0

; kbhit - returns key hit in AX (without wait)
kbhit:
	push ax

	mov al, 0			; check for any keys hit
	mov ah, 1			; but do not block (async)
	int 16h				; call BIOS interrupt
	jz .end				; if no keys hit jump to end

	mov ax, 0			; get key hit function
	int 16h				; call BIOS interrupt

	mov [.key], ax

	pop ax

	mov ax, [.key]
	ret

.end:
	pop ax

	mov ax, 0			; set AX to 0 if no keys hit
	ret

	.key: dw 0

; Display message and wait for key
press_any_key:
	mov si, press_msg
	call puts
	call getchar
	ret

press_msg: db "Press any key to continue...", 0
