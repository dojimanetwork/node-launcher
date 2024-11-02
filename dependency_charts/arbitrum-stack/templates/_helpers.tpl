{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "arbitrum_stack.name" -}}
{{- default .Chart.Name "" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "arbitrum_stack.fullname" -}}
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
{{- define "arbitrum_stack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "arbitrum_stack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arbitrum_stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Net
*/}}
{{- define "arbitrum_stack.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "arbitrum_stack.tag" -}}
{{- default .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "arbitrum_stack.labels" -}}
helm.sh/chart: {{ include "arbitrum_stack.chart" . }}
{{ include "arbitrum_stack.selectorLabels" . }}
app.kubernetes.io/version: {{ include "arbitrum_stack.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/net: {{ include "arbitrum_stack.net" . }}
app.kubernetes.io/type: {{ .Values.type }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "arbitrum_stack.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "arbitrum_stack.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "arbitrum_stack.image" -}}
{{- .Values.global.arbitrum.image -}}:{{ .Values.global.arbitrum.tag }}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "arbitrum_stack.rpc" -}}
    {{ .Values.service.port.http}}
{{- end -}}
