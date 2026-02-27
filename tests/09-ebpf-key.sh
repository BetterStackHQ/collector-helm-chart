#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set ebpf.enabled=true \
  --set ebpf.image.repository=ghcr.io/betterstackhq/collector-ebpf \
  --set ebpf.image.tag=v1.0.0 \
  --set ebpf.image.pullPolicy=Always \
  --set 'ebpf.env.GOMEMLIMIT=1400MiB' \
  --set ebpf.dockerprobe.enabled=false \
  --set ebpf.memoryRestartThreshold=1450 \
  --set-json 'ebpf.resources={"limits":{"cpu":"1000m","memory":"3000Mi"},"requests":{"cpu":"800m","memory":"1000Mi"}}' \
  --set securityContext.ebpf.privileged=true)

assert_contains "$output" "name: ebpf" "Expected ebpf container when using ebpf key"
assert_contains "$output" "v1.0.0" "Expected custom image tag v1.0.0"

pass
