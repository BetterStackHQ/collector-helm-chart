{{/*
Expand the name of the chart.
*/}}
{{- define "better-stack-collector.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "better-stack-collector.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "better-stack-collector.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "better-stack-collector.labels" -}}
helm.sh/chart: {{ include "better-stack-collector.chart" . }}
{{ include "better-stack-collector.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "better-stack-collector.selectorLabels" -}}
app.kubernetes.io/name: {{ include "better-stack-collector.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "better-stack-collector.serviceAccountName" -}}
{{- if .Values.rbac.create }}
{{- default (include "better-stack-collector.fullname" .) .Values.rbac.serviceAccountName }}
{{- else }}
{{- default "default" .Values.rbac.serviceAccountName }}
{{- end }}
{{- end }}

{{/*
Validate required values
*/}}
{{- define "better-stack-collector.validateValues" -}}
{{- if and .Values.collector.envFrom (eq (kindOf .Values.collector.envFrom) "map") }}
{{- fail `Legacy envFrom format detected in collector.envFrom. The chart no longer supports the secretRefs/configMapRefs format.

Please update your values from:

    collector:
      envFrom:
        secretRefs: ["my-secret"]

To the standard Kubernetes envFrom format:

    collector:
      envFrom:
        - secretRef:
            name: my-secret` }}
{{- end }}
{{- $ebpf := include "better-stack-collector.ebpf" . | fromYaml -}}
{{- if and $ebpf.envFrom (eq (kindOf $ebpf.envFrom) "map") }}
{{- fail `Legacy envFrom format detected in ebpf.envFrom. The chart no longer supports the secretRefs/configMapRefs format.

Please update your values from:

    ebpf:
      envFrom:
        secretRefs: ["my-secret"]

To the standard Kubernetes envFrom format:

    ebpf:
      envFrom:
        - secretRef:
            name: my-secret` }}
{{- end }}
{{- if not (or .Values.collector.env.COLLECTOR_SECRET (gt (len .Values.collector.envFrom) 0)) }}
{{- fail "COLLECTOR_SECRET is required. Please provide your Better Stack collector secret either via collector.env.COLLECTOR_SECRET or through collector.envFrom (standard Kubernetes envFrom format). Find your collector secret here: https://telemetry.betterstack.com/team/0/collectors." }}
{{- end }}
{{- end }}

{{/*
eBPF config - supports both 'ebpf' (preferred) and 'beyla' (deprecated) keys.
When 'ebpf' is partially set (e.g. only resources), merges over 'beyla' defaults
so that image, env, etc. are still present.
*/}}
{{- define "better-stack-collector.ebpf" -}}
{{- if .Values.ebpf -}}
{{- mustMergeOverwrite (deepCopy .Values.beyla) .Values.ebpf | toYaml -}}
{{- else -}}
{{- .Values.beyla | toYaml -}}
{{- end -}}
{{- end -}}

{{/*
eBPF security context - supports both 'ebpf' (preferred) and 'beyla' (deprecated) keys
*/}}
{{- define "better-stack-collector.ebpf.securityContext" -}}
{{- if .Values.securityContext.ebpf -}}
{{- .Values.securityContext.ebpf | toYaml -}}
{{- else -}}
{{- .Values.securityContext.beyla | toYaml -}}
{{- end -}}
{{- end -}}

{{/*
Check if eBPF is enabled - supports both 'ebpf' and 'beyla' keys.
Uses the merged config so that partially setting 'ebpf' (e.g. only resources)
doesn't accidentally disable eBPF by shadowing the 'beyla.enabled' default.
*/}}
{{- define "better-stack-collector.ebpf.enabled" -}}
{{- $ebpf := include "better-stack-collector.ebpf" . | fromYaml -}}
{{- $ebpf.enabled -}}
{{- end -}}

{{/*
Check if using deprecated 'beyla' key
*/}}
{{- define "better-stack-collector.ebpf.usingDeprecatedKey" -}}
{{- if and (not .Values.ebpf) .Values.beyla -}}
true
{{- end -}}
{{- end -}}