#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123)

assert_not_contains "$output" 'kind: Service$' "Service should not be present when collectOtel is not configured"

pass
