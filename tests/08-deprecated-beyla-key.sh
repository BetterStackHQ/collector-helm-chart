#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123)
assert_contains "$output" "name: collector-host" "Expected collector-host container to be present when using beyla key"

pass
