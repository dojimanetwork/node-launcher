{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "solana-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solana-daemon.fullname" -}}
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
{{- define "solana-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "solana-daemon.labels" -}}
helm.sh/chart: {{ include "solana-daemon.chart" . }}
{{ include "solana-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "solana-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solana-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "solana-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "solana-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "solana-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Bnet
*/}}
{{- define "solana-daemon.bnet" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    mainnet
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    mainnet
{{- else -}}
    {{ include "solana-daemon.net" . }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "solana-daemon.image" -}}
{{- if eq (include "solana-daemon.net" .) "mocknet" -}}
    "{{ .Values.image.mocknet }}:latest"
{{- else if eq (include "solana-daemon.net" .) "testnet" -}}
    "{{ .Values.image.testnet }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "solana-daemon.rpc" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.rpc}}
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.rpc}}
{{- else -}}
    {{ .Values.service.port.testnet.rpc }}
{{- end -}}
{{- end -}}


{{/*
WS Port
*/}}
{{- define "solana-daemon.ws" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.ws}}
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.ws}}
{{- else -}}
    {{ .Values.service.port.testnet.ws }}
{{- end -}}
{{- end -}}

{{/*
UDP Port
*/}}
{{- define "solana-daemon.udp" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.udp}}
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.udp}}
{{- else -}}
    {{ .Values.service.port.testnet.udp }}
{{- end -}}
{{- end -}}


{{/*
TPU Port
*/}}
{{- define "solana-daemon.tpu" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.tpu}}
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.tpu}}
{{- else -}}
    {{ .Values.service.port.testnet.tpu }}
{{- end -}}
{{- end -}}

{{/*
Gossip Port
*/}}
{{- define "solana-daemon.gossip" -}}
{{- if eq (include "solana-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.gossip}}
{{- else if eq (include "solana-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.gossip}}
{{- else -}}
    {{ .Values.service.port.testnet.gossip }}
{{- end -}}
{{- end -}}