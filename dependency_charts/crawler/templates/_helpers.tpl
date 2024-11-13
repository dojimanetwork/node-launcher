{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "crawler.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "crawler.fullname" -}}
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
{{- define "crawler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "crawler.labels" -}}
helm.sh/chart: {{ include "crawler.chart" . }}
{{ include "crawler.selectorLabels" . }}
app.kubernetes.io/version: {{ include "crawler.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "crawler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "crawler.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "crawler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "crawler.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "crawler.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "crawler.tag" -}}
{{- coalesce  .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "crawler.image" -}}
{{- if eq .Values.global.crawler.global_enable true -}}
{{- .Values.global.crawler.image -}}:{{ .Values.global.crawler.tag }}
{{- else -}}
{{- .Values.image.repository -}}:{{.Values.image.tag}}
{{- end -}}
{{- end -}}

{{/*
Hermes daemon
*/}}
{{- define "crawler.hermesnodeDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.hermesDaemon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.hermesDaemon.stagenet }}
{{- else -}}
    {{ .Values.hermesDaemon.testnet }}
{{- end -}}
{{- end -}}

{{/*
Binance daemon
*/}}
{{- define "crawler.binanceDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.binanceDaemon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.binanceDaemon.stagenet }}
{{- else -}}
    {{ default .Values.binanceDaemon.mocknet .Values.global.binanceDaemon }}
{{- end -}}
{{- end -}}

{{/*
Arweave daemon
*/}}
{{- define "crawler.arweaveDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.arweaveDaemon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.arweaveDaemon.stagenet }}
{{- else -}}
    {{ default .Values.arweaveDaemon.testnet .Values.global.arweaveDaemon }}
{{- end -}}
{{- end -}}


{{/*
Polkadot daemon
*/}}
{{- define "crawler.polkaDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.polkaDaemmon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.polkaDaemmon.stagenet }}
{{- else -}}
    {{ default .Values.polkaDaemmon.testnet .Values.global.polkaDaemmon }}
{{- end -}}
{{- end -}}


{{/*
Solana daemon
*/}}
{{- define "crawler.solanaDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.solanaDaemon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.solanaDaemon.stagenet }}
{{- else -}}
    {{ default .Values.solanaDaemon.testnet .Values.global.solanaDaemon }}
{{- end -}}
{{- end -}}


{{/*
Solana ws daemon
*/}}
{{- define "crawler.solanaWsDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.solanaDaemon.wsMainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.solanaDaemon.wsStagenet }}
{{- else -}}
    {{ default .Values.solanaDaemon.wsTestnet .Values.global.solanaWsDaemon }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin
*/}}
{{- define "crawler.bitcoinDaemon" -}}
{{- if eq (include "crawler.net" .) "mainnet" -}}
    {{ .Values.bitcoinDaemon.mainnet }}
{{- else if eq (include "crawler.net" .) "stagenet" -}}
    {{ .Values.bitcoinDaemon.stagenet }}
{{- else if eq (include "crawler.net" .) "testnet" -}}
    {{ .Values.bitcoinDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinDaemon.mocknet }}
{{- end -}}
{{- end -}}





{{/*
Gaia
*/}}
{{- define "crawler.gaiaDaemon" -}}
{{- index (index .Values.gaiaDaemon (include "crawler.net" .)) "rpc" -}}
{{- end -}}
{{- define "crawler.gaiaDaemonGRPC" -}}
{{- index (index .Values.gaiaDaemon (include "crawler.net" .)) "grpc" -}}
{{- end -}}
{{- define "crawler.gaiaDaemonGRPCTLS" -}}
{{- index (index .Values.gaiaDaemon (include "crawler.net" .)) "grpcTLS" -}}
{{- end -}}

{{/*
Ethereum
*/}}
{{- define "crawler.ethereumDaemon" -}}
{{ index .Values.ethereumDaemon (include "crawler.net" .) }}
{{- end -}}

{{/*
Avalanche
*/}}
{{- define "crawler.avaxDaemon" -}}
{{ index .Values.avaxDaemon (include "crawler.net" .) }}
{{- end -}}

{{/*
ethSuggestedFeeVersion
*/}}
{{- define "crawler.ethSuggestedFeeVersion" -}}
    {{ index .Values.ethSuggestedFeeVersion (include "crawler.net" .) }}
{{- end -}}

{{/*
Nqs Port
*/}}
{{- define "crawler-nqs.port" -}}
    {{ .Values.service.port.nqs }}
{{- end -}}

{{/*
Image
*/}}
{{- define "crawler.hermesnode-image" -}}
{{- .Values.global.hermes.image -}}:{{ .Values.global.hermes.tag }}
{{- end -}}

{{/*
chain id
*/}}
{{- define "crawler.chainID" -}}
    {{ default .Values.global.hermes.chainId .Values.chainID.testnet }}
{{- end -}}