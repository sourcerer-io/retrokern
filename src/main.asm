rk_version: db "1.00", 0

main:

.start:

	call set_text_mode
	call display_welcome

	; insert main program here

	; wait for keypress
	call getchar

.reboot:
	call reboot
	ret

display_welcome:

	mov si, welcome_msg
	call puts
	mov si, rk_version
	call puts
	call newline

	mov si, copyright_msg
	call puts
	call newline

	mov si, license_msg
	call puts
	call newline
	call newline

	ret


welcome_msg: db "Welcome to Retrokern Version ", 0
copyright_msg: db "Copyright (C) 2018 Sourcerer, All Rights Reserved.", 0
license_msg: db "Licensed under the GPLv3.", 0
