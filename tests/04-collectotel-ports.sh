#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123 --set collectOtel.grpcPort=4317 --set collectOtel.httpPort=4318)

assert_contains "$output" 'hostPort: 4317' "Missing hostPort 4317"
assert_contains "$output" 'hostPort: 4318' "Missing hostPort 4318"
assert_contains "$output" 'containerPort: 4317' "Missing containerPort 4317"
assert_contains "$output" 'containerPort: 4318' "Missing containerPort 4318"
assert_contains "$output" 'COLLECT_OTEL_GRPC_PORT' "Missing COLLECT_OTEL_GRPC_PORT env var"
assert_contains "$output" 'COLLECT_OTEL_HTTP_PORT' "Missing COLLECT_OTEL_HTTP_PORT env var"

pass
