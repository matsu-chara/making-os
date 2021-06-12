.PHONY: ci
ci:
	find . -name "*.s" | grep -v src/modules | xargs -I {} nasm -Xgnu -I./src/include -o/dev/null {}

