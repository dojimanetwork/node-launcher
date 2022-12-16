{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "landing-page-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "landing-page-daemon.fullname" -}}
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
{{- define "landing-page-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "landing-page-daemon.labels" -}}
helm.sh/chart: {{ include "landing-page-daemon.chart" . }}
{{ include "landing-page-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.mainnet }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "landing-page-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "landing-page-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "landing-page-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "landing-page-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "landing-page-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}


{{/*
Image
*/}}
{{- define "landing-page-daemon.image" -}}
{{- if eq (include "landing-page-daemon.net" .) "testnet" -}}
    "{{ .Values.image.name }}:{{ .Values.image.testnet }}@sha256:{{ .Values.image.testnet_hash }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.mainnet }}@sha256:{{ .Values.image.mainnet_hash }}"
{{- end -}}
{{- end -}}


{{/*
HTTP Port
*/}}
{{- define "landing-page-daemon.http" -}}
    {{ .Values.service.port.mainnet.http }}
{{- end -}}

