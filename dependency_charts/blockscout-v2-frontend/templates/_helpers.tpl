{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "blockscout-v2-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "blockscout-v2-frontend.fullname" -}}
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
{{- define "blockscout-v2-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "blockscout-v2-frontend.labels" -}}
helm.sh/chart: {{ include "blockscout-v2-frontend.chart" . }}
{{ include "blockscout-v2-frontend.selectorLabels" . }}
app.kubernetes.io/version: {{ include "daemon.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "blockscout-v2-frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "blockscout-v2-frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "blockscout-v2-frontend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "blockscout-v2-frontend.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "daemon.tag" -}}
    {{  default .Chart.AppVersion }}
{{- end -}}

{{/*
Net
*/}}
{{- define "blockscout-v2-frontend.net" -}}
{{- default .Values.net -}}
{{- end -}}


{{/*
Postgressql Docker image
*/}}
{{- define "blockscout-v2-frontend-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}



{{/*
Smart contract verifier Docker image
*/}}
{{- define "blockscout-v2-frontend-rs.image" -}}
{{ .Values.image.smartcontract_verifier.repository }}:{{ .Values.image.smartcontract_verifier.testnet.tag }}
{{- end -}}