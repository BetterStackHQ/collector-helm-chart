#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set-json 'beyla.envFrom=[{"secretRef":{"name":"beyla-secret"}}]')

assert_contains "$output" "beyla-secret" "Expected beyla-secret in envFrom"

pass
