.PHONY: check
check:
	find . -name "*.s" | grep -v src/modules/real/reboot.s | xargs -I {} nasm -Xgnu -I./src/include -o/dev/null {}

