#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set ebpf.resources.requests.cpu=400m \
  --set ebpf.resources.limits.cpu=800m)

assert_contains "$output" "name: ebpf" "Expected ebpf container when setting ebpf.resources without ebpf.enabled"
assert_contains "$output" "ghcr.io/betterstackhq/collector-ebpf" "Expected default ebpf image from beyla defaults"

pass
