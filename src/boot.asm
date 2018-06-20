%define SECTORS 16
%define IMAGE_SIZE ((SECTORS + 1) * 512)	; SECTORS + 1 (~= 18) * 512 bytes
%define STACK_SIZE 256						; 4096 bytes in paragraphs

; Declare 16-bit mode
bits 16
; Boot sector entry point
;org 0x7C00

start:
	cli ; disable interrupts

	;
	; Notes:
	;  1 paragraph	= 16 bytes
	; 32 paragraphs = 512 bytes
	;
	; Skip past our SECTORS
	; Skip past our reserved video memory buffer (for double buffering)
	; Skip past allocated STACK_SIZE
	;

	mov ax, (((SECTORS + 1) * 32) + 4000 + STACK_SIZE)
	mov ss, ax
	mov sp, STACK_SIZE * 16 ; 4096 in bytes

	sti ; enable interrupts

	mov ax, 0x07C0		; point all segments to _start
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; dl contains the drive number

	mov ax, 0		; reset disk function
	int 0x13		; call BIOS interrupt
	jc disk_reset_error

	push es			; save es

	mov ax, 0x07E0		; destination location (address of _start)
	mov es, ax		; destination location
	mov bx, 0		; index 0

	mov ah, 2		; read sectors function
	mov al, SECTORS		; number of sectors
	mov ch, 0		; cylinder number
	mov dh, 0		; head number
	mov cl, 2		; starting sector number
	int 0x13		; call BIOS interrupt

	jc disk_read_error

	pop es			; restore es

	mov si, boot_msg	; display boot message
	call _puts

	jmp 07E0h:0000h		; jump to _start (a.k.a stage 2)

disk_reset_error:
	mov si, disk_reset_error_msg
	jmp fatal

disk_read_error:
	mov si, disk_read_error_msg

fatal:
	call _puts	; print message in [DS:SI]

	mov ax, 0	; wait for a keypress
	int 16h

	mov ax, 0	; reboot
	int 19h

; _puts - in-boot-sector put string function
; pointer in SI
_puts:
	lodsb		; move byte [DS:SI] into AL

	; is this the end of the string?
	cmp al, 0
	je .end

	; display character BIOS call
	mov ah, 0x0E 
	int 0x10

	; move to next character
	jmp _puts

.end:
	ret

disk_reset_error_msg: db 'Disk reset error.',0
disk_read_error_msg: db 'Disk read error.',0
boot_msg: db 'Booting Retrokern... ', 0

; Pad to 510 bytes, then 2 more magic bytes to fill the boot sector
times 510 - ($ - $$) db 0
dw 0xAA55

; entry point
_start:
	call main				; call main
	jmp $					; loop forever

%include 'console.asm';
%include 'timer.asm'
%include 'speaker.asm'
%include 'video.asm'
%include 'core.asm'

; main.asm contains the main loop
%include 'main.asm'

; pad to IMAGE_SIZE
times IMAGE_SIZE - ($ - $$) db 0
