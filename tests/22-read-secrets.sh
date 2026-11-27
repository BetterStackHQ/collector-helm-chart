#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render \
  --set collector.env.COLLECTOR_SECRET=test123 \
  --set rbac.readSecrets=true)

secrets_rule='  - apiGroups: [""]
    resources:
      - secrets
    verbs: ["get"]'

if [[ "$output" != *"$secrets_rule"* ]]; then
  echo "FAIL: ClusterRole does not grant get on secrets with rbac.readSecrets=true"
  exit 1
fi

# The get-only rule above must be the only one that names secrets: no list, no watch.
count=$(echo "$output" | grep -c -e '^ *- secrets$' || true)
if [[ "$count" != "1" ]]; then
  echo "FAIL: Expected exactly one rule naming secrets, found $count"
  exit 1
fi

pass
