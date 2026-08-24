#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set beyla.enabled=false)

assert_not_contains "$output" "name: collector-host" "Expected collector-host container to be absent when disabled"

pass
