#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

render --set-json 'collector.envFrom=[{"secretRef":{"name":"my-secret"}}]' > /dev/null

pass
