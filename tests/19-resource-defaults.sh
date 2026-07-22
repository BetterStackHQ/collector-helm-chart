#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/helpers.sh"

output=$(render --set collector.env.COLLECTOR_SECRET=test123)

collector_resources='        resources:
          limits:
            cpu: 1200m
            memory: 1Gi
          requests:
            cpu: 200m
            memory: 512Mi'
ebpf_resources='        resources:
          limits:
            cpu: 1000m
            memory: 2Gi
          requests:
            cpu: 200m
            memory: 1536Mi'

if [[ "$output" != *"$collector_resources"* ]]; then
  echo "FAIL: Collector default resources do not match"
  exit 1
fi

if [[ "$output" != *"$ebpf_resources"* ]]; then
  echo "FAIL: eBPF default resources do not match"
  exit 1
fi

pass
