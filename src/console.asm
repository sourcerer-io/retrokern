; getchar()
; Returns keyboard press in AX
getchar:
	pusha
	mov ax, 0x0
	int 0x16

	mov [.chr], ax
	popa
	mov ax, [.chr]
	ret

	.chr: dw 0

; kbhit - returns key hit in AX (without wait)
kbhit:
	pusha

	mov al, 0			; check for any keys hit
	mov ah, 1			; but do not block (async)
	int 16h				; call BIOS interrupt
	jz .end				; if no keys hit jump to end

	mov ax, 0			; get key hit function
	int 16h				; call BIOS interrupt

	mov [.key], ax

	popa

	mov ax, [.key]
	ret

.end:
	popa

	mov ax, 0			; set AX to 0 if no keys hit
	ret

	.key: dw 0

