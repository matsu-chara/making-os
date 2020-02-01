.PHONY: boot
boot:
	qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

.PHONY: box
box:
	bochs -q -f ../../env/bochsrc.bxrc -rc ../../env/cmd.init
