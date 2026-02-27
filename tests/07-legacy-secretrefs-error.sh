#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set-json 'collector.envFrom={"secretRefs":["my-secret"]}' 2>&1 || true)
assert_contains "$output" "Legacy envFrom format detected" "Should reject legacy collector secretRefs format"

output=$(render --set collector.env.COLLECTOR_SECRET=test123 --set-json 'ebpf.envFrom={"secretRefs":["my-secret"]}' 2>&1 || true)
assert_contains "$output" "Legacy envFrom format detected" "Should reject legacy ebpf secretRefs format"

output=$(render --set collector.env.COLLECTOR_SECRET=test123 --set-json 'beyla.envFrom={"secretRefs":["my-secret"]}' 2>&1 || true)
assert_contains "$output" "Legacy envFrom format detected" "Should reject legacy beyla secretRefs format"

pass
