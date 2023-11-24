{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "blockscout-v2-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "blockscout-v2-backend.fullname" -}}
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
{{- define "blockscout-v2-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "blockscout-v2-backend.labels" -}}
helm.sh/chart: {{ include "blockscout-v2-backend.chart" . }}
{{ include "blockscout-v2-backend.selectorLabels" . }}
app.kubernetes.io/version: {{ include "daemon.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "blockscout-v2-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blockscout-v2-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "blockscout-v2-backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "blockscout-v2-backend.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "daemon.tag" -}}
    {{ .Values.image.blockscout.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Net
*/}}
{{- define "blockscout-v2-backend.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}


{{/*
Postgressql Docker image
*/}}
{{- define "blockscout-v2-backend-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}


{{/*
Blockscout Docker image
*/}}
{{- define "blockscout-v2-backend-blockscout.image" -}}
{{ .Values.image.blockscout.repository }}:{{ .Values.image.blockscout.tag }}
{{- end -}}


{{/*
Smart contract verifier Docker image
*/}}
{{- define "blockscout-v2-backend-rs.image" -}}
{{ .Values.image.smartcontract_verifier.repository }}:{{ .Values.image.smartcontract_verifier.testnet.tag }}
{{- end -}}