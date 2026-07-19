.PHONY: gen build tidy verify ci

gen:
	./gen.sh

tidy:
	go mod tidy

build:
	go build ./...

# Verify generated code is up-to-date and compiles.
verify: gen tidy build
	git diff --exit-code -- v1 || (echo "generated code out of date — run make gen and commit"; exit 1)

# CI entrypoint.
ci: verify
