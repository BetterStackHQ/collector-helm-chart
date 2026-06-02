#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

# Default values must not emit an updateStrategy block, so Kubernetes
# applies its DaemonSet default and existing installs see no change.
output=$(render --set collector.env.COLLECTOR_SECRET=test123)

assert_not_contains "$output" 'updateStrategy:' \
  "Unexpected updateStrategy block when collector.updateStrategy is unset"

pass
