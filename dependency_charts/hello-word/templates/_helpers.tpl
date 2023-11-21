{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hello-word.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hello-word.fullname" -}}
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
{{- define "hello-word.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hello-word.labels" -}}
helm.sh/chart: {{ include "hello-word.chart" . }}
{{ include "hello-word.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hello-word.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-word.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "hello-word.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "hello-word.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "hello-word.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Bnet
*/}}
{{- define "hello-word.bnet" -}}
{{- if eq (include "hello-word.net" .) "mainnet" -}}
    mainnet
{{- else if eq (include "hello-word.net" .) "stagenet" -}}
    mainnet
{{- else -}}
    {{ include "hello-word.net" . }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "hello-word.image" -}}
  "{{ .Values.image.name }}:{{.Values.image.tag}}"
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "hello-word.rpc" -}}
{{- if eq (include "hello-word.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.rpc}}
{{- else if eq (include "hello-word.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.rpc}}
{{- else -}}
    {{ .Values.service.port.testnet.rpc }}
{{- end -}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "hello-word.p2p" -}}
{{- if eq (include "hello-word.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.p2p}}
{{- else if eq (include "hello-word.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.p2p}}
{{- else -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}

{{- define "hello-word.api" -}}
{{- if eq (include "hello-word.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.api }}
{{- end -}}
{{- end -}}