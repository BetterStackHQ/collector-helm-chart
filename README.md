# [Better Stack](https://betterstack.com/logs) Collector Helm chart

[![Better Stack dashboard](https://github.com/user-attachments/assets/3975906e-0131-4e55-bc57-5b2cf079f24c)](https://betterstack.com/tracing)

[![Apache 2.0 License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE.md)

Better Stack collector is the easiest and recommended way of integrating Better Stack into your Kubernetes cluster. 

**Leverage eBPF to instrument your Kubernetes** to gather logs, metrics, and OpenTelemetry traces **without code changes**. Ingest everything at a fraction of the cost. [Learn more ⇗](https://betterstack.com/tracing)

## Documentation

[Getting started ⇗](https://betterstack.com/docs/logs/collector/#getting-started)

## System Requirements

### Memory Requirements

The Better Stack collector runs as a DaemonSet with two containers per node:
- **Collector container**: 512MB-2GB memory
- **eBPF container** (eBPF tracing): 1.5GB memory reserved

**Minimum recommended node specifications:**
- 4GB total memory per node
- 2GB available memory after system and other critical workloads

**Important notes:**
- The eBPF container requires 1.5GB memory reservation to ensure stable eBPF-based tracing
- In memory-constrained or heavily overcommitted clusters, the collector may experience restarts
- Both containers are configured with Guaranteed QoS class to prevent eviction under memory pressure

## Need help?

Please let us know at [hello@betterstack.com](mailto:hello@betterstack.com). We're happy to help!

## Thank you, open source contributors!

Better Stack collector wouldn't be possible without the open source community. We are grateful to all the contributors of OpenTelemetry, Cilium, Vector, Beyla, Coroot among others who enabled us to build upon their work. Thank you!

[Apache 2.0 License](LICENSE.md)

[Releasing a new version of this chart](./how-to-release.md)
