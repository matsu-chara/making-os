.PHONY: check
check:
	find . -name "*.s" | xargs -I {} nasm -Xgnu -I. -o/dev/null {}

.PHONY: build
build: clean
	nasm boot.s -o boot.img -l boot.lst

.PHONY: clean
clean:
	rm -f boot.img boot.lst

.PHONY: boot
boot: build
	qemu-system-i386 -rtc base=localtime -drive file=boot.img,format=raw -boot order=c

.PHONY: box
box: build
	bochs -q -f ../../env/bochsrc.bxrc -rc ../../env/cmd.init
