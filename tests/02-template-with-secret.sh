#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

render --set collector.env.COLLECTOR_SECRET=test123 > /dev/null

pass
