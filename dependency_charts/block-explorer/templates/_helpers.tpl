{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "block-explorer-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "block-explorer-daemon.fullname" -}}
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
{{- define "block-explorer-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "block-explorer-daemon.labels" -}}
helm.sh/chart: {{ include "block-explorer-daemon.chart" . }}
{{ include "block-explorer-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.testnet }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "block-explorer-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "block-explorer-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "block-explorer-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "block-explorer-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "block-explorer-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}


{{/*
Image
*/}}
{{- define "block-explorer-daemon.image" -}}
{{- if eq (include "block-explorer-daemon.net" .) "testnet" -}}
    "{{ .Values.image.name }}:{{ .Values.image.testnet }}@sha256:{{ .Values.image.testnet_hash }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.mainnet }}@sha256:{{ .Values.image.mainnet_hash }}"
{{- end -}}
{{- end -}}


{{/*
HTTP Port
*/}}
{{- define "block-explorer-daemon.http" -}}
    {{ .Values.service.port.testnet.http }}
{{- end -}}

