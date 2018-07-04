; ticks - return number of ticks in DX
; Resolution is around 55ms
ticks:
	push ax
	mov ax, 0x0
	int 0x1A

	mov [.ticks], dx

	pop ax

	mov dx, [.ticks]
	ret

	.ticks dw 0

; sleep - sleep DX number of ms
sleep:
	push ax
	push bx
	push dx

	mov ax, 0x0
	mov bx, dx

	int 0x1A
	add bx, dx

.wait:
	int 0x1A

	cmp dx, bx
	; loop until DX ms 
	jne .wait

	pop dx
	pop bx
	pop ax
	ret
