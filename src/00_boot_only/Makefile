.PHONY: compile
compile:
	nasm boot.s -o boot.img -l boot.lst

.PHONY: run/qemu
run/qemu:
	qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

.PHONY: run/bochs
run/bochs:
	bochs -q -f ../../env/bochsrc.bxrc -rc ../../env/cmd.init
