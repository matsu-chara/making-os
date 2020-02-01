.PHONY: run/qemu
run/qemu:
	qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

.PHONY: run/bochs
run/bochs:
	bochs -q -f ../../env/bochsrc.bxrc -rc ../../env/cmd.init
