.PHONY: check
check:
	find . -name "*.s" | xargs -I {} nasm -Xgnu -I. -o/dev/null {}

