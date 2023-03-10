{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "bex-fiber.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "bex-fiber.fullname" -}}
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
{{- define "bex-fiber.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "bex-fiber.labels" -}}
helm.sh/chart: {{ include "bex-fiber.chart" . }}
{{ include "bex-fiber.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "bex-fiber.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bex-fiber.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "bex-fiber.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "bex-fiber.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "bex-fiber.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-fiber.image" -}}
   "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}

{{/*
Image
*/}}
{{- define "bex-fiber.hermesnode-image" -}}
{{- if eq (include "bex-fiber.net" .) "testnet" -}}
{{- .Values.hermes.testnet.image -}}:{{ .Values.hermes.testnet.tag }}
{{- else -}}
{{- .Values.hermes.mainnet.image -}}:{{ .Values.hermes.mainnet.tag }}@sha256:{{ .Values.hermes.mainnet.hash}}
{{- end -}}
{{- end -}}


{{/*
chain id
*/}}
{{- define "bex-fiber.chainID" -}}
{{- if eq (include "bex-fiber.net" .) "testnet" -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}

{{/*
Fiber Port
*/}}
{{- define "bex-fiber.api" -}}
    {{ .Values.service.fiber }}
{{- end -}}

{{/*
Postgressql Docker image
*/}}
{{- define "bex-fiber-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}