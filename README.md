# [Better Stack](https://betterstack.com/logs) Collector Helm chart

[![Better Stack dashboard](https://github.com/user-attachments/assets/3975906e-0131-4e55-bc57-5b2cf079f24c)](https://betterstack.com/tracing)

[![Apache 2.0 License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE.md)

Better Stack collector is the easiest and recommended way of integrating Better Stack into your Kubernetes cluster. 

**Leverage eBPF to instrument your Kubernetes** to gather logs, metrics, and OpenTelemetry traces **without code changes**. Ingest everything at a fraction of the cost. [Learn more ⇗](https://betterstack.com/tracing)

## Documentation

[Getting started ⇗](https://betterstack.com/docs/logs/collector/#getting-started)

## System requirements

The chart runs the collector and, by default, an eBPF container on each node with these resources:

| Container | CPU request | Memory request | CPU limit | Memory limit |
| --- | ---: | ---: | ---: | ---: |
| Collector | 200m | 512Mi | 1200m | 1Gi |
| eBPF | 200m | 1536Mi | 1000m | 2Gi |
| **Full-tracing total** | **400m** | **2Gi** | **2200m** | **3Gi** |

The collector-only configuration was validated on a **2 vCPU / 2 GiB node** with eBPF disabled. Use that as its planning guideline and a **4 vCPU / 4 GiB node** for full tracing. These are host/node sizing guidelines, not resource allocations: the requested capacity and enough headroom up to the limits must be available after Kubernetes, the operating system, and other workloads consume resources.

Kubernetes uses requests to schedule and reserve capacity, while limits cap each container's usage. The unequal request and limit values are intentional, so the default Pod has **Burstable** rather than Guaranteed QoS. A container can be CPU-throttled or OOM-killed at its limits, and Burstable Pods have lower eviction priority than Guaranteed Pods under node pressure.

## Need help?

Please let us know at [hello@betterstack.com](mailto:hello@betterstack.com). We're happy to help!

## Thank you, open source contributors!

Better Stack collector wouldn't be possible without the open source community. We are grateful to all the contributors of OpenTelemetry, Cilium, Vector, Beyla, Coroot among others who enabled us to build upon their work. Thank you!

[Apache 2.0 License](LICENSE.md)

[Releasing a new version of this chart](./how-to-release.md)
