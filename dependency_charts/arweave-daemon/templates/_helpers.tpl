{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "arweave-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "arweave-daemon.fullname" -}}
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
{{- define "arweave-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "arweave-daemon.labels" -}}
helm.sh/chart: {{ include "arweave-daemon.chart" . }}
{{ include "arweave-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "arweave-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arweave-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "arweave-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "arweave-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "arweave-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Bnet
*/}}
{{- define "arweave-daemon.bnet" -}}
{{- if eq (include "arweave-daemon.net" .) "mainnet" -}}
    mainnet
{{- else if eq (include "arweave-daemon.net" .) "stagenet" -}}
    mainnet
{{- else -}}
    {{ include "arweave-daemon.net" . }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "arweave-daemon.image" -}}
{{- if eq (include "arweave-daemon.net" .) "mocknet" -}}
    "{{ .Values.image.mocknet }}:latest"
{{- else if eq (include "arweave-daemon.net" .) "testnet" -}}
    "{{ .Values.image.testnet }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "arweave-daemon.rpc" -}}
{{- if eq (include "arweave-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.rpc}}
{{- else if eq (include "arweave-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.rpc}}
{{- else -}}
    {{ .Values.service.port.testnet.rpc }}
{{- end -}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "arweave-daemon.p2p" -}}
{{- if eq (include "arweave-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.p2p}}
{{- else if eq (include "arweave-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.p2p}}
{{- else -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}

{{- define "arweave-daemon.api" -}}
{{- if eq (include "arweave-daemon.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.api }}
{{- end -}}
{{- end -}}