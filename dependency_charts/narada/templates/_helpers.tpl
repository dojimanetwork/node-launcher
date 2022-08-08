{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "narada.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "narada.fullname" -}}
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
{{- define "narada.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "narada.labels" -}}
helm.sh/chart: {{ include "narada.chart" . }}
{{ include "narada.selectorLabels" . }}
app.kubernetes.io/version: {{ include "narada.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "narada.selectorLabels" -}}
app.kubernetes.io/name: {{ include "narada.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "narada.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "narada.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "narada.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "narada.tag" -}}
{{- coalesce  .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "narada.image" -}}
{{- if or (eq (include "narada.net" .) "mocknet") (eq (include "narada.net" .) "testnet") -}}
{{- .Values.image.repository -}}:{{ include "narada.tag" . }}
{{- else -}}
{{- .Values.image.repository -}}:{{ include "narada.tag" . }}@sha256:{{ coalesce .Values.global.hash .Values.image.hash }}
{{- end -}}
{{- end -}}

{{/*
Hermes daemon
*/}}
{{- define "narada.hermesnodeDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.hermesDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.hermesDaemon.stagenet }}
{{- else -}}
    {{ .Values.hermesDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Binance daemon
*/}}
{{- define "narada.binanceDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.binanceDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.binanceDaemon.stagenet }}
{{- else -}}
    {{ default .Values.binanceDaemon.testnet .Values.global.binanceDaemon }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin
*/}}
{{- define "narada.bitcoinDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.bitcoinDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.bitcoinDaemon.stagenet }}
{{- else if eq (include "narada.net" .) "testnet" -}}
    {{ .Values.bitcoinDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin Cash
*/}}
{{- define "narada.bitcoinCashDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.bitcoinCashDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.bitcoinCashDaemon.stagenet }}
{{- else if eq (include "narada.net" .) "testnet" -}}
    {{ .Values.bitcoinCashDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinCashDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Litecoin
*/}}
{{- define "narada.litecoinDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.litecoinDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.litecoinDaemon.stagenet }}
{{- else if eq (include "narada.net" .) "testnet" -}}
    {{ .Values.litecoinDaemon.testnet }}
{{- else -}}
    {{ .Values.litecoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Dogecoin
*/}}
{{- define "narada.dogecoinDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.dogecoinDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.dogecoinDaemon.stagenet }}
{{- else if eq (include "narada.net" .) "testnet" -}}
    {{ .Values.dogecoinDaemon.testnet }}
{{- else -}}
    {{ .Values.dogecoinDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Terra
*/}}
{{- define "narada.terraDaemon" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.terraDaemon.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.terraDaemon.stagenet }}
{{- else if eq (include "narada.net" .) "testnet" -}}
    {{ .Values.terraDaemon.testnet }}
{{- else -}}
    {{ .Values.terraDaemon.mocknet }}
{{- end -}}
{{- end -}}

{{/*
Gaia
*/}}
{{- define "narada.gaiaDaemon" -}}
{{- index (index .Values.gaiaDaemon (include "narada.net" .)) "rpc" -}}
{{- end -}}
{{- define "narada.gaiaDaemonGRPC" -}}
{{- index (index .Values.gaiaDaemon (include "narada.net" .)) "grpc" -}}
{{- end -}}
{{- define "narada.gaiaDaemonGRPCTLS" -}}
{{- index (index .Values.gaiaDaemon (include "narada.net" .)) "grpcTLS" -}}
{{- end -}}

{{/*
Ethereum
*/}}
{{- define "narada.ethereumDaemon" -}}
{{ index .Values.ethereumDaemon (include "narada.net" .) }}
{{- end -}}

{{/*
Avalanche
*/}}
{{- define "narada.avaxDaemon" -}}
{{ index .Values.avaxDaemon (include "narada.net" .) }}
{{- end -}}

{{/*
chainID
*/}}
{{- define "narada.chainID" -}}
{{- if eq (include "narada.net" .) "mainnet" -}}
    {{ .Values.chainID.mainnet }}
{{- else if eq (include "narada.net" .) "stagenet" -}}
    {{ .Values.chainID.stagenet }}
{{- else -}}
    {{ .Values.chainID.mocknet }}
{{- end -}}
{{- end -}}

{{/*
ethSuggestedFeeVersion
*/}}
{{- define "narada.ethSuggestedFeeVersion" -}}
    {{ index .Values.ethSuggestedFeeVersion (include "narada.net" .) }}
{{- end -}}
