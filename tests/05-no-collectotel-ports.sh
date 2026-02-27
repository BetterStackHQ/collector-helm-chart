#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123)

assert_not_contains "$output" 'otel-grpc\|otel-http' "Unexpected otel ports when collectOtel ports are not set"
assert_not_contains "$output" 'COLLECT_OTEL_GRPC_PORT\|COLLECT_OTEL_HTTP_PORT' "Unexpected COLLECT_OTEL env vars when collectOtel ports are not set"

pass
