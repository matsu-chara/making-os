.PHONY: check
check:
	find . -name "*.s" | xargs -I {} nasm -Xgnu -I. -o/dev/null {}

.PHONY: mk
mk:
	nasm boot.s -o boot.img -l boot.lst

