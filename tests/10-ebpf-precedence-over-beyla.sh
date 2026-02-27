#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# When only beyla values are set, they should override ebpf defaults (backward compat)
output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set beyla.image.tag=custom-tag)

assert_contains "$output" "custom-tag" "Expected beyla.image.tag to override ebpf default"
assert_contains "$output" "name: ebpf" "Expected ebpf container to be present"

pass
