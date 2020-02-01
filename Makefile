.PHONY: check
check:
	find . -name "*.s" | xargs -I {} nasm -Xgnu -I./src/include -o/dev/null {}

