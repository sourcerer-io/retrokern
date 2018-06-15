; Reboot the system
reboot:
	mov ax, 0x0
	int 0x19
	ret


