#!/bin/bash

set -euo pipefail

target_version="$1"

if [ -z "$target_version" ]; then
    echo "target_version not set"
    exit 1
fi

echo "$target_version"

target="$(echo $target_version | cut -f1 -d,)"
version="$(echo $target_version | cut -f2 -d,)"

./pleasew run "${target}_build_ebpf_probe" -- "$version"
