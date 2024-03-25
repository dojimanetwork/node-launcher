{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "narada-eddsa.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "narada-eddsa.fullname" -}}
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
{{- define "narada-eddsa.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "narada-eddsa.labels" -}}
helm.sh/chart: {{ include "narada-eddsa.chart" . }}
{{ include "narada-eddsa.selectorLabels" . }}
app.kubernetes.io/version: {{ include "narada-eddsa.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "narada-eddsa.selectorLabels" -}}
app.kubernetes.io/name: {{ include "narada-eddsa.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "narada-eddsa.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "narada-eddsa.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "narada-eddsa.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "narada-eddsa.tag" -}}
{{- coalesce  .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "narada-eddsa.image" -}}
{{- .Values.global.hermes.image -}}:{{ .Values.global.hermes.tag }}
{{- end -}}

{{/*
Hermes daemon
*/}}
{{- define "narada-eddsa.hermesnodeDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.hermesDaemon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.hermesDaemon.stagenet }}
{{- else -}}
    {{ .Values.hermesDaemon.testnet }}
{{- end -}}
{{- end -}}

{{/*
chainID
*/}}
{{- define "narada-eddsa.chainID" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.chainID.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.chainID.stagenet }}
{{- else -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}

{{/*
ethSuggestedFeeVersion
*/}}
{{- define "narada-eddsa.ethSuggestedFeeVersion" -}}
    {{ index .Values.ethSuggestedFeeVersion (include "narada-eddsa.net" .) }}
{{- end -}}

{{/*
eddsa http Port
*/}}
{{- define "narada-eddsa-nqs.port" -}}
    {{ .Values.service.port.eddsa_http }}
{{- end -}}