{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dojima-blockscout-v2.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dojima-blockscout-v2.fullname" -}}
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
{{- define "dojima-blockscout-v2.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dojima-blockscout-v2.labels" -}}
helm.sh/chart: {{ include "dojima-blockscout-v2.chart" . }}
{{ include "dojima-blockscout-v2.selectorLabels" . }}
app.kubernetes.io/version: {{ include "daemon.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dojima-blockscout-v2.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dojima-blockscout-v2.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dojima-blockscout-v2.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "dojima-blockscout-v2.fullname" .) .Values.serviceAccount.name }}
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
{{- define "dojima-blockscout-v2.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}


{{/*
Postgressql Docker image
*/}}
{{- define "dojima-blockscout-v2-postgres.image" -}}
{{ .Values.image.postgres.image }}
{{- end -}}


{{/*
Blockscout Docker image
*/}}
{{- define "dojima-blockscout-v2-blockscout.image" -}}
{{ .Values.image.blockscout.repository }}:{{ .Values.image.blockscout.tag }}@{{ .Values.image.blockscout.hash}}
{{- end -}}


{{/*
Smart contract verifier Docker image
*/}}
{{- define "dojima-blockscout-v2-rs.image" -}}
{{ .Values.image.smartcontract_verifier.repository }}:{{ .Values.image.smartcontract_verifier.testnet.tag }}@sha256:{{ .Values.image.smartcontract_verifier.testnet.hash}}
{{- end -}}