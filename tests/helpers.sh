#!/usr/bin/env bash
set -euo pipefail

CHART_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

render() {
  helm template test "$CHART_DIR" "$@"
}

assert_contains() {
  local output="$1" expected="$2" message="$3"
  if ! echo "$output" | grep -q "$expected"; then
    echo "FAIL: $message (expected to find: $expected)"
    exit 1
  fi
}

assert_not_contains() {
  local output="$1" unexpected="$2" message="$3"
  if echo "$output" | grep -q "$unexpected"; then
    echo "FAIL: $message (unexpected match: $unexpected)"
    exit 1
  fi
}

assert_fail() {
  if "$@" 2>/dev/null; then
    echo "FAIL: Expected command to fail: $*"
    exit 1
  fi
}

pass() {
  echo "PASS: $(basename "${BASH_SOURCE[1]}" .sh)"
}
