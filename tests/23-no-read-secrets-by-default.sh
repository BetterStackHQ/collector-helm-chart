#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123)

assert_not_contains "$output" '^ *- secrets$' "ClusterRole must not grant access to secrets by default"

pass
