#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123 --set collectOtel.grpcPort=4317 --set collectOtel.httpPort=4318)

assert_contains "$output" 'kind: Service' "Missing Service resource"
assert_contains "$output" 'internalTrafficPolicy: Local' "Missing internalTrafficPolicy: Local"
assert_contains "$output" 'name: otel-grpc' "Missing otel-grpc port name in Service"
assert_contains "$output" 'name: otel-http' "Missing otel-http port name in Service"
assert_contains "$output" 'port: 4317' "Missing port 4317 in Service"
assert_contains "$output" 'port: 4318' "Missing port 4318 in Service"

pass
