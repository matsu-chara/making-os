.PHONY: check
check:
	find . -name "*.s" | xargs -I {} nasm -Xgnu -I. -o/dev/null {}

.PHONY: build
build: clean
	if [ -e kernel.s ]; then\
		nasm boot.s -o boot.bin -l boot.lst;\
		nasm kernel.s -o kernel.bin -l kernel.lst;\
		cat boot.bin kernel.bin > boot.img;\
	else\
		nasm boot.s -o boot.img -l boot.lst;\
	fi

.PHONY: clean
clean:
	rm -f boot.bin boot.lst kernel.bin kernel.lst boot.img

.PHONY: boot
boot: build
	qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

.PHONY: box
box: build
	bochs -q -f ../../env/bochsrc.bxrc -rc ../../env/cmd.init
