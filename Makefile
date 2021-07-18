.PHONY: ci
ci:
	find ./src/ -type d -depth 1 | grep "\d\d_*" | sort -n | xargs -I {} sh -c 'cd {}; make build'
