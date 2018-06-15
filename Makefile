NASM 		= nasm
QEMU 		= qemu-system-i386
QEMU_DRIVE 	= a

NAME 		 = retrokern
FILENAME 	 = $(NAME).img

IMAGE 		= build/$(FILENAME)
ISO_IMAGE 	= build/iso/$(FILENAME)
ISO 		= build/$(NAME).iso
ISO_DIR 	= build/iso

BOOT 		= src/boot.asm

all: $(IMAGE)

$(IMAGE): $(BOOT)
	$(NASM) -isrc/ -f bin -o $(IMAGE) $(BOOT)

floppy:
	dd bs=512 count=2880 if=/dev/zero of=$(ISO_IMAGE)
	dd status=noxfer conv=notrunc if=$(IMAGE) of=$(ISO_IMAGE)

iso:
	$(MAKE) floppy
	genisoimage -quiet -V 'FLOPPYBIRD' -input-charset iso8859-1 -o $(ISO) -b $(FILENAME) $(ISO_DIR)

clean:
	rm -f $(IMAGE)
	rm -f $(ISO_IMAGE)
	rm -f $(ISO)

