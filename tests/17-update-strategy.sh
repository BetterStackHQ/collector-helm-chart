#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set 'collector.updateStrategy.type=RollingUpdate' \
  --set 'collector.updateStrategy.rollingUpdate.maxUnavailable=25%' \
  --set 'collector.updateStrategy.rollingUpdate.maxSurge=0')

assert_contains "$output" 'updateStrategy:' "Missing updateStrategy block on DaemonSet"
assert_contains "$output" 'type: RollingUpdate' "Missing updateStrategy.type"
assert_contains "$output" 'maxUnavailable: 25%' "Missing maxUnavailable override"
assert_contains "$output" 'maxSurge: 0' "Missing maxSurge override"

pass
