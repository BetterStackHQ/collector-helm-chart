#!/usr/bin/env bash
# The cluster agent runs kube-state-metrics, which lists and watches these
# resources. Without them it logs "forbidden" and sends no metrics for them.
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

if ! command -v yq >/dev/null; then
  echo "FAIL: yq is required for this test"
  exit 1
fi

cluster_role=$(render --set collector.env.COLLECTOR_SECRET=test123 --show-only templates/rbac.yaml |
  yq 'select(.kind == "ClusterRole")')

assert_can_read() {
  local group="$1" resource="$2"
  local matches
  matches=$(echo "$cluster_role" | GROUP="$group" RESOURCE="$resource" yq '[.rules[] |
    select(.apiGroups[] == strenv(GROUP)) |
    select(.resources[] == strenv(RESOURCE)) |
    select(.verbs[] == "get") | select(.verbs[] == "list") | select(.verbs[] == "watch")] | length')
  if [[ "$matches" -lt 1 ]]; then
    echo "FAIL: ClusterRole can't get, list and watch $resource in API group \"$group\""
    exit 1
  fi
}

assert_can_read storage.k8s.io volumeattachments
assert_can_read apiextensions.k8s.io customresourcedefinitions
assert_can_read source.toolkit.fluxcd.io gitrepositories
assert_can_read source.toolkit.fluxcd.io ocirepositories
assert_can_read source.toolkit.fluxcd.io helmrepositories
assert_can_read source.toolkit.fluxcd.io helmcharts
assert_can_read helm.toolkit.fluxcd.io helmreleases
assert_can_read kustomize.toolkit.fluxcd.io kustomizations
assert_can_read fluxcd.controlplane.io resourcesets

write_verbs=$(echo "$cluster_role" | yq '[.rules[].verbs[] | select(. != "get" and . != "list" and . != "watch")] | length')
if [[ "$write_verbs" -ne 0 ]]; then
  echo "FAIL: ClusterRole grants verbs other than get, list and watch"
  exit 1
fi

pass
