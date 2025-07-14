# [Better Stack](https://betterstack.com/logs) Collector Helm chart

Integrate your Kubernetes cluster with Better Stack.
Collect eBPF-based OpenTelemetry-native traces, metrics, and Kubernetes logs to gain observability with zero code changes.
Ship your own traces, metrics, and logs to Better Stack.

[<img width="2663" height="1176" alt="Telemetry-tracing-hero" src="https://github.com/user-attachments/assets/a9b8be6a-d90f-4e8a-9863-3dc06cf0dbb5" />](https://betterstack.com/tracing)

[![MIT License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

**Tracing reimagined with eBPF & OpenTelemetry**  
Instrument your cluster without making any code changes. Ingest everything at a fraction of the cost.  
[Learn more ⇗](https://betterstack.com/tracing)

## Quick Start

```bash
helm repo add better-stack https://betterstackhq.github.io/collector-helm-chart
helm repo update
helm install better-stack-collector better-stack/better-stack-collector \
  --set collector.env.COLLECTOR_SECRET="your-collector-secret-here"
```

## Documentation

For detailed configuration options, see the [values.yaml](values.yaml) file.

[Getting started ⇗](https://betterstack.com/docs/logs/collector)

## Need help?
Please let us know at [hello@betterstack.com](mailto:hello@betterstack.com). We're happy to help!

---

[MIT license](LICENSE)
