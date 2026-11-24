#!/usr/bin/env bash
# The collector container is Ready only while its health check passes, so a
# collector that sends nothing shows as Not Ready.
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

if ! command -v yq >/dev/null; then
  echo "FAIL: yq is required for this test"
  exit 1
fi

container() {
  local name="$1"
  shift
  render --set collector.env.COLLECTOR_SECRET=test123 "$@" --show-only templates/daemonset.yaml |
    NAME="$name" yq '.spec.template.spec.containers[] | select(.name == strenv(NAME))'
}

assert_equal() {
  local actual="$1" expected="$2" message="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL: $message (expected: $expected, got: $actual)"
    exit 1
  fi
}

collector=$(container collector)

readiness_script=$(echo "$collector" | yq '.readinessProbe.exec.command[2]')
assert_contains "$readiness_script" '/var/lib/better-stack/collector/healthcheck.sh --readiness' "Readiness probe must run the collector health check in readiness mode"
# Readiness mode writes no files; the liveness run keeps writing the result other processes read.
if [[ "$(echo "$collector" | yq '.livenessProbe.exec.command[2]')" == *--readiness* ]]; then
  echo "FAIL: Liveness probe must not pass --readiness"
  exit 1
fi
# The script arrives from Better Stack after the container starts; until then the pod isn't Ready.
if [[ ! -e /var/lib/better-stack/collector/healthcheck.sh ]] && /bin/sh -c "$readiness_script" >/dev/null 2>&1; then
  echo "FAIL: Readiness probe must fail while the health check script is missing"
  exit 1
fi
assert_equal "$(echo "$collector" | yq '.readinessProbe.initialDelaySeconds')" 10 "Default readiness initialDelaySeconds"
assert_equal "$(echo "$collector" | yq '.readinessProbe.periodSeconds')" 15 "Default readiness periodSeconds"
assert_equal "$(echo "$collector" | yq '.readinessProbe.timeoutSeconds')" 10 "Default readiness timeoutSeconds"
assert_equal "$(echo "$collector" | yq '.readinessProbe.failureThreshold')" 4 "Default readiness failureThreshold"

assert_equal "$(echo "$collector" | yq '.livenessProbe.initialDelaySeconds')" 180 "Liveness probe must stay as it was"
assert_equal "$(echo "$collector" | yq '.livenessProbe.periodSeconds')" 60 "Liveness probe must stay as it was"
assert_equal "$(echo "$collector" | yq '.livenessProbe.failureThreshold')" 5 "Liveness probe must stay as it was"

overridden=$(container collector \
  --set collector.readinessProbe.initialDelaySeconds=30 \
  --set collector.readinessProbe.periodSeconds=20 \
  --set collector.readinessProbe.timeoutSeconds=8 \
  --set collector.readinessProbe.failureThreshold=6)
assert_equal "$(echo "$overridden" | yq '.readinessProbe.initialDelaySeconds')" 30 "Overridden readiness initialDelaySeconds"
assert_equal "$(echo "$overridden" | yq '.readinessProbe.periodSeconds')" 20 "Overridden readiness periodSeconds"
assert_equal "$(echo "$overridden" | yq '.readinessProbe.timeoutSeconds')" 8 "Overridden readiness timeoutSeconds"
assert_equal "$(echo "$overridden" | yq '.readinessProbe.failureThreshold')" 6 "Overridden readiness failureThreshold"

# helm upgrade --reuse-values keeps an older release's values, which have no readinessProbe block.
reused=$(container collector --set collector.readinessProbe=null)
assert_equal "$(echo "$reused" | yq '.readinessProbe.periodSeconds')" 15 "Readiness probe must fall back to defaults without collector.readinessProbe"
assert_equal "$(echo "$reused" | yq '.readinessProbe.failureThreshold')" 4 "Readiness probe must fall back to defaults without collector.readinessProbe"
zero=$(container collector --set collector.readinessProbe.initialDelaySeconds=0)
assert_equal "$(echo "$zero" | yq '.readinessProbe.initialDelaySeconds')" 0 "An explicit 0 must be kept"

assert_equal "$(container collector-host | yq '.readinessProbe')" null "collector-host container must have no readiness probe"

pass
