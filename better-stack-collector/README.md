# Better Stack Collector Helm Chart

This Helm chart deploys the Better Stack Collector monitoring solution on a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Better Stack account with a collector secret

## Installation

### Add the repository

```bash
helm repo add better-stack https://betterstackhq.github.io/collector-helm-chart
helm repo update
```

### Install from repository

```bash
helm install better-stack-collector better-stack/better-stack-collector \
  --set collector.env.COLLECTOR_SECRET="your-collector-secret-here"
```

### Install from local directory

1. Clone this repository:
```bash
git clone https://github.com/BetterStackHQ/collector-helm-chart.git
cd collector-helm-chart/better-stack-collector
```

2. Create a values override file (`my-values.yaml`):
```yaml
collector:
  env:
    COLLECTOR_SECRET: "your-collector-secret-here"
```

3. Install the chart:
```bash
helm install better-stack-collector . -f my-values.yaml
```

### Install with custom namespace

```bash
kubectl create namespace monitoring
helm install better-stack-collector . -f my-values.yaml -n monitoring
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `collector.image.repository` | Collector image repository | `better-stack-collector` |
| `collector.image.tag` | Collector image tag | `latest` |
| `collector.env.COLLECTOR_SECRET` | Your Better Stack collector secret (required) | `""` |
| `collector.env.BASE_URL` | Better Stack API URL | `https://telemetry.betterstack.com` |
| `collector.env.CLUSTER_COLLECTOR` | Enable cluster collector mode | `true` |
| `collector.resources` | CPU/Memory resource requests/limits | See values.yaml |
| `beyla.enabled` | Enable Beyla eBPF tracing | `true` |
| `beyla.image.repository` | Beyla image repository | `grafana/beyla` |
| `beyla.image.tag` | Beyla image tag | `2.2.4` |
| `beyla.resources` | Beyla CPU/Memory resource requests/limits | See values.yaml |
| `rbac.create` | Create RBAC resources | `true` |

## Upgrading

To upgrade an existing release:

```bash
helm upgrade better-stack-collector . -f my-values.yaml
```

## Uninstallation

To uninstall/delete the deployment:

```bash
helm uninstall better-stack-collector
```

## Architecture

This chart deploys:

1. **Collector Deployment**: A single replica deployment running the Better Stack collector
2. **Beyla DaemonSet**: Runs on every node for eBPF-based application tracing
3. **Service**: Exposes the collector's OTLP endpoint for Beyla
4. **RBAC**: ServiceAccount with necessary permissions for monitoring the cluster

## Security Considerations

- The collector deployment requires access to host paths for monitoring
- Beyla requires privileged access and host PID namespace for eBPF tracing
- Store your `COLLECTOR_SECRET` securely and never commit it to version control

## Troubleshooting

### Check pod status
```bash
kubectl get pods -l app.kubernetes.io/name=better-stack-collector
```

### View collector logs
```bash
kubectl logs -l app.kubernetes.io/component=collector
```

### View Beyla logs
```bash
kubectl logs -l app.kubernetes.io/component=beyla
```

### Verify RBAC permissions
```bash
kubectl auth can-i --list --as=system:serviceaccount:default:better-stack-collector
```

## Building the Docker Image

If you need to build the Docker image locally:

```bash
docker build -t better-stack-collector:latest ../..
```

Then update your values to use the local image:

```yaml
collector:
  image:
    repository: better-stack-collector
    tag: latest
    pullPolicy: Never  # For local images
```