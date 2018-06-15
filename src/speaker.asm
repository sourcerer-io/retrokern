; beep
; Put note in AX, delay in DX
beep:
	push bx
	mov bx, ax

	mov al, 0xb6
	out 0x43, al

	mov ax, bx
	out 0x42, al
	mov al, ah
	out 0x42, al

	in al, 0x61
	or al, 0x03
	out 0x61, al

	call sleep

	in al, 0x61
	and al, 0x0FC
	out 0x61, al

	pop bx
	ret
