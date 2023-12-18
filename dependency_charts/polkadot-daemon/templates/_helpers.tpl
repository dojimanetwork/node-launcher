{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "polkadot-daemon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "polkadot-daemon.fullname" -}}
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
{{- define "polkadot-daemon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "polkadot-daemon.labels" -}}
helm.sh/chart: {{ include "polkadot-daemon.chart" . }}
{{ include "polkadot-daemon.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "polkadot-daemon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "polkadot-daemon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "polkadot-daemon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "polkadot-daemon.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "polkadot-daemon.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Bnet
*/}}
{{- define "polkadot-daemon.bnet" -}}
{{- if eq (include "polkadot-daemon.net" .) "mainnet" -}}
    mainnet
{{- else if eq (include "polkadot-daemon.net" .) "stagenet" -}}
    mainnet
{{- else -}}
    {{ include "polkadot-daemon.net" . }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "polkadot-daemon.image" -}}
{{- if eq (include "polkadot-daemon.net" .) "mocknet" -}}
    "{{ .Values.image.mocknet }}:latest"
{{- else if eq (include "polkadot-daemon.net" .) "testnet" -}}
    "{{ .Values.image.testnet }}"
{{- else -}}
    "{{ .Values.image.name }}:{{ .Values.image.tag }}@sha256:{{ .Values.image.hash }}"
{{- end -}}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "polkadot-daemon.http" -}}
{{- if eq (include "polkadot-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.http}}
{{- else if eq (include "polkadot-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.http}}
{{- else -}}
    {{ .Values.service.port.testnet.http }}
{{- end -}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "polkadot-daemon.p2p" -}}
{{- if eq (include "polkadot-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.p2p}}
{{- else if eq (include "polkadot-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.p2p}}
{{- else -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}

{{- define "polkadot-daemon.ws" -}}
{{- if eq (include "polkadot-daemon.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.ws}}
{{- else if eq (include "polkadot-daemon.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.ws}}
{{- else -}}
    {{ .Values.service.port.testnet.ws }}
{{- end -}}
{{- end -}}