{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bex-single-msg.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bex-single-msg.fullname" -}}
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
{{- define "bex-single-msg.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "bex-single-msg.labels" -}}
helm.sh/chart: {{ include "bex-single-msg.chart" . }}
{{ include "bex-single-msg.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "bex-single-msg.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bex-single-msg.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "bex-single-msg.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bex-single-msg.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "bex-single-msg.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-single-msg.image" -}}
   "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-single-msg.hermesnode-image" -}}
{{- if eq (include "bex-single-msg.net" .) "testnet" -}}
{{- .Values.hermes.testnet.image -}}:{{ .Values.hermes.testnet.tag }}
{{- else -}}
{{- .Values.hermes.mainnet.image -}}:{{ .Values.hermes.mainnet.tag }}@sha256:{{ .Values.hermes.mainnet.hash}}
{{- end -}}
{{- end -}}


{{/*
chain id
*/}}
{{- define "bex-single-msg.chainID" -}}
{{- if eq (include "bex-single-msg.net" .) "testnet" -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}

{{/*
Fiber Port
*/}}
{{- define "bex-single-msg.api" -}}
    {{ .Values.service.fiber }}
{{- end -}}

{{/*
Postgressql Docker image
*/}}
{{- define "bex-single-msg-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}