.PHONY: ci
ci:
	find "./src/" -maxdepth 1 -type d | grep "\d\d_*" | sort -n | xargs -I {} sh -c 'cd {}; make build'
