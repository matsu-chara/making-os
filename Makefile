gPHONY: ci
ci:
	find "." -mindepth 3 -maxdepth 3 -name Makefile | sort -n | xargs -I {} sh -c 'cd $$(dirname {}); make build'
