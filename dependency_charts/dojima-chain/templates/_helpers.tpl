{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "dojima-chain.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dojima-chain.fullname" -}}
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
{{- define "dojima-chain.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "dojima-chain.labels" -}}
helm.sh/chart: {{ include "dojima-chain.chart" . }}
{{ include "dojima-chain.selectorLabels" . }}
app.kubernetes.io/version: {{ include "dojima-chain.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "dojima-chain.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dojima-chain.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "dojima-chain.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "dojima-chain.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "dojima-chain.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "dojima-chain.tag" -}}
{{- coalesce .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "dojima-chain.image" -}}
{{- if or (eq (include "dojima-chain.net" .) "testnet") -}}
{{- .Values.image.repository -}}:{{ include "dojima-chain.tag" . }}@sha256:{{ .Values.image.hash }}
{{- else -}}
{{- .Values.image.repository -}}:{{ include "dojima-chain.tag" . }}@sha256:{{ coalesce .Values.global.hash .Values.image.hash }}
{{- end -}}
{{- end -}}


{{/*
Http Rpc Port
*/}}
{{- define "dojima-chain.http" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.http }}
{{- end -}}
{{- end -}}


{{/*
WS Rpc Port
*/}}
{{- define "dojima-chain.wss" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.wss }}
{{- end -}}
{{- end -}}

{{/*
Graphql Port
*/}}
{{- define "dojima-chain.graphql" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.graphql }}
{{- end -}}
{{- end -}}


{{/*
Devp2p Port
*/}}
{{- define "dojima-chain.devp2p" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.devp2p }}
{{- end -}}
{{- end -}}


{{/*
Image
*/}}
{{- define "dojima-chain.hermesnode-image" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
{{- .Values.hermes.testnet.image -}}:{{ .Values.hermes.testnet.tag }}
{{- else -}}
{{- .Values.hermes.mainnet.image -}}:{{ .Values.hermes.mainnet.tag }}@sha256:{{ .Values.hermes.mainnet.hash}}
{{- end -}}
{{- end -}}


{{/*
chain id
*/}}
{{- define "dojima-chain.chainID" -}}
{{- if eq (include "dojima-chain.net" .) "testnet" -}}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}