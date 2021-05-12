#!/bin/bash

set -euo pipefail

# generate json lists for all probe build targets
./pleasew run parallel --include generate_targets_list //...

# merge json lists into one
json_lists=($(find "$PWD/plz-out/github/targets/" -type f -name '*.json'))
./pleasew run //third_party/binary:jq -- -c 'reduce inputs as $i (.; . += $i)' "${json_lists[@]}" > plz-out/github/targets/all.json

# remove targets which have already been built...

# trim down to 256
# let's trim down to 5 for now for sanity
./pleasew run //third_party/binary:jq -- -c '.[:5]' plz-out/github/targets/all.json > plz-out/github/targets/all.json.new
mv plz-out/github/targets/all.json.new plz-out/github/targets/all.json
