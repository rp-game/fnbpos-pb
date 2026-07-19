#!/usr/bin/env bash
# Generate Go code from proto. Independent contract — no mantik dependency.
set -euo pipefail
cd "$(dirname "$0")"

export PATH="$PATH:$(go env GOPATH)/bin"

command -v protoc >/dev/null || { echo "protoc not found"; exit 1; }
command -v protoc-gen-go >/dev/null || { echo "protoc-gen-go not found (go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.36.11)"; exit 1; }

PROTOS=$(find proto -name '*.proto' | sort)

protoc -I proto \
  --experimental_allow_proto3_optional \
  --go_out=. \
  --go_opt=module=github.com/rp-game/fnbpos-pb \
  --go_opt=Mgoogle/protobuf/timestamp.proto=google.golang.org/protobuf/types/known/timestamppb \
  $PROTOS

echo "generated:"
echo "$PROTOS"
