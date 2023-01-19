{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bex-hermes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bex-hermes.fullname" -}}
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
{{- define "bex-hermes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "bex-hermes.labels" -}}
helm.sh/chart: {{ include "bex-hermes.chart" . }}
{{ include "bex-hermes.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "bex-hermes.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bex-hermes.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "bex-hermes.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bex-hermes.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "bex-hermes.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-hermes.image" -}}
   "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}

{{/*
Faucet Port
*/}}
{{- define "bex-hermes.api" -}}
    {{ .Values.service.port }}
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-hermes.hermesnode-image" -}}
{{- if eq (include "bex-hermes.net" .) "testnet" -}}
{{- .Values.hermes.testnet.image -}}:{{ .Values.hermes.testnet.tag }}
{{- else -}}
{{- .Values.hermes.mainnet.image -}}:{{ .Values.hermes.mainnet.tag }}@sha256:{{ .Values.hermes.mainnet.hash}}
{{- end -}}
{{- end -}}


{{/*
chain id
*/}}
{{- define "bex-hermes.chainID" -}}
{{- if eq (include "bex-hermes.net" .) "testnet" -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}

{{/*
Postgressql Docker image
*/}}
{{- define "bex-hermes-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}

{{/*
Fiber Port
*/}}
{{- define "bex-hermes.api" -}}
    {{ .Values.service.fiber }}
{{- end -}}