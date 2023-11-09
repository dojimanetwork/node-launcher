{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "developer-docs-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "developer-docs-daemon.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "developer-docs-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "developer-docs-daemon.labels" -}}
helm.sh/chart: {{ include "developer-docs-daemon.chart" . }}
{{ include "developer-docs-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.testnet }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "developer-docs-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "developer-docs-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "developer-docs-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "developer-docs-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "developer-docs-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}


{{/*
Image
*/}}
{{- define "developer-docs-daemon.image" -}}
{{- if eq (include "developer-docs-daemon.net" .) "testnet" -}}
    "{{ .Values.image.name }}:{{ .Values.image.testnet }}@sha256:{{ .Values.image.testnet_hash }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.mainnet }}@sha256:{{ .Values.image.mainnet_hash }}"
{{- end -}}
{{- end -}}


{{/*
HTTP Port
*/}}
{{- define "developer-docs-daemon.http" -}}
    {{ .Values.service.port.testnet.http }}
{{- end -}}

