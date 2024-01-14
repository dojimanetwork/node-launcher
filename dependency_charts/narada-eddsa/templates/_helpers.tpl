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
Binance daemon
*/}}
{{- define "narada-eddsa.binanceDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.binanceDaemon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.binanceDaemon.stagenet }}
{{- else -}}
    {{ default .Values.binanceDaemon.mocknet .Values.global.binanceDaemon }}
{{- end -}}
{{- end -}}

{{/*
Arweave daemon
*/}}
{{- define "narada-eddsa.arweaveDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.arweaveDaemon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.arweaveDaemon.stagenet }}
{{- else -}}
    {{ default .Values.arweaveDaemon.testnet .Values.global.arweaveDaemon }}
{{- end -}}
{{- end -}}


{{/*
Polkadot daemon
*/}}
{{- define "narada-eddsa.polkaDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.polkaDaemmon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.polkaDaemmon.stagenet }}
{{- else -}}
    {{ default .Values.polkaDaemmon.testnet .Values.global.polkaDaemmon }}
{{- end -}}
{{- end -}}


{{/*
Solana daemon
*/}}
{{- define "narada-eddsa.solanaDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.solanaDaemon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.solanaDaemon.stagenet }}
{{- else -}}
    {{ default .Values.solanaDaemon.testnet .Values.global.solanaDaemon }}
{{- end -}}
{{- end -}}


{{/*
Solana ws daemon
*/}}
{{- define "narada-eddsa.solanaWsDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.solanaDaemon.wsMainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.solanaDaemon.wsStagenet }}
{{- else -}}
    {{ default .Values.solanaDaemon.wsTestnet .Values.global.solanaWsDaemon }}
{{- end -}}
{{- end -}}

{{/*
Bitcoin
*/}}
{{- define "narada-eddsa.bitcoinDaemon" -}}
{{- if eq (include "narada-eddsa.net" .) "mainnet" -}}
    {{ .Values.bitcoinDaemon.mainnet }}
{{- else if eq (include "narada-eddsa.net" .) "stagenet" -}}
    {{ .Values.bitcoinDaemon.stagenet }}
{{- else if eq (include "narada-eddsa.net" .) "testnet" -}}
    {{ .Values.bitcoinDaemon.testnet }}
{{- else -}}
    {{ .Values.bitcoinDaemon.mocknet }}
{{- end -}}
{{- end -}}





{{/*
Gaia
*/}}
{{- define "narada-eddsa.gaiaDaemon" -}}
{{- index (index .Values.gaiaDaemon (include "narada-eddsa.net" .)) "rpc" -}}
{{- end -}}
{{- define "narada-eddsa.gaiaDaemonGRPC" -}}
{{- index (index .Values.gaiaDaemon (include "narada-eddsa.net" .)) "grpc" -}}
{{- end -}}
{{- define "narada-eddsa.gaiaDaemonGRPCTLS" -}}
{{- index (index .Values.gaiaDaemon (include "narada-eddsa.net" .)) "grpcTLS" -}}
{{- end -}}

{{/*
Ethereum
*/}}
{{- define "narada-eddsa.ethereumDaemon" -}}
{{ index .Values.ethereumDaemon (include "narada-eddsa.net" .) }}
{{- end -}}

{{/*
Avalanche
*/}}
{{- define "narada-eddsa.avaxDaemon" -}}
{{ index .Values.avaxDaemon (include "narada-eddsa.net" .) }}
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