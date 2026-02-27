#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

helm lint "$CHART_DIR" --set collector.env.COLLECTOR_SECRET=test123

pass
