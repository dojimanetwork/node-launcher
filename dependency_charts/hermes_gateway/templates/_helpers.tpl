{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "gateway.fullname" -}}
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
{{- define "gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "gateway.labels" -}}
helm.sh/chart: {{ include "gateway.chart" . }}
{{ include "gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "gateway.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Net
*/}}
{{- define "gateway.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "gateway.rpc" -}}
{{- if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.rpc}}
{{- else if eq (include "gateway.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.rpc}}
{{- else -}}
    {{ .Values.service.port.testnet.rpc }}
{{- end -}}
{{- end -}}

{{/*
Rpc port domain name
*/}}
{{- define "gateway-hermes-rpc.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.rpc }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.rpc }}
{{- end -}}
{{- end -}}


{{/*
Api port domain name
*/}}
{{- define "gateway-hermes-api.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.api }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.api }}
{{- end -}}
{{- end -}}


{{/*
Ar port domain name
*/}}
{{- define "gateway-hermes-ar.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.ar }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.ar }}
{{- end -}}
{{- end -}}


{{/*
dot port domain name
*/}}
{{- define "gateway-hermes-dot.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.dot }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.dot }}
{{- end -}}
{{- end -}}


{{/*
dot ws port domain name
*/}}
{{- define "gateway-hermes-dot-ws.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.dot_ws }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.dot_ws }}
{{- end -}}
{{- end -}}


{{/*
sol ws port domain name
*/}}
{{- define "gateway-hermes-sol-ws.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.sol_ws }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.sol_ws }}
{{- end -}}
{{- end -}}


{{/*
sol port domain name
*/}}
{{- define "gateway-hermes-sol-api.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.sol }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.sol }}
{{- end -}}
{{- end -}}

{{/*
Dojima chain api port domain name
*/}}
{{- define "gateway-dc-api.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.d11k.testnet.api }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.d11k.mainnet.api }}
{{- end -}}
{{- end -}}

{{/*
Dojima chain rpc port domain name
*/}}
{{- define "gateway-dc-rpc.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.d11k.testnet.wss }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.d11k.mainnet.wss }}
{{- end -}}
{{- end -}}


{{/*
Dojima faucet api domain name
*/}}
{{- define "gateway-dc-faucet.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.faucet.api }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.faucet.api }}
{{- end -}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "gateway.p2p" -}}
{{- if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.service.port.mainnet.p2p}}
{{- else if eq (include "gateway.net" .) "stagenet" -}}
    {{ .Values.service.port.stagenet.p2p}}
{{- else -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}


{{/*
Arweave api Port
*/}}
{{- define "gateway-arweave-daemon.api" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.arweave.testnet.api }}
{{- end -}}
{{- end -}}

{{/*
Solana rpc Port
*/}}
{{- define "gateway-solana-daemon.rpc" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.solana.testnet.rpc }}
{{- end -}}
{{- end -}}


{{/*
Solana ws Port
*/}}
{{- define "gateway-solana-daemon.wss" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.solana.testnet.wss }}
{{- end -}}
{{- end -}}


{{/*
Solana udp Port
*/}}
{{- define "gateway-solana-daemon.udp" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.solana.testnet.udp }}
{{- end -}}
{{- end -}}

{{/*
Solana gossip Port
*/}}
{{- define "gateway-solana-daemon.gossip" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.solana.testnet.gossip }}
{{- end -}}
{{- end -}}


{{/*
Solana tpu Port
*/}}
{{- define "gateway-solana-daemon.tpu" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.solana.testnet.tpu }}
{{- end -}}
{{- end -}}

{{/*
Polkadot wss Port
*/}}
{{- define "gateway-polkadot-daemon.wss" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.polkadot.testnet.wss }}
{{- end -}}
{{- end -}}


{{/*
Polkadot http Port
*/}}
{{- define "gateway-polkadot-daemon.http" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.polkadot.testnet.http }}
{{- end -}}
{{- end -}}


{{/*
DC http Port
*/}}
{{- define "gateway-dojima-chain.http" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.dc.testnet.http }}
{{- end -}}
{{- end -}}


{{/*
DC wss/rpc Port
*/}}
{{- define "gateway-dojima-chain.rpc" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.dc.testnet.wss }}
{{- end -}}
{{- end -}}

{{/*
DC wss/rpc Port
*/}}
{{- define "gateway-dojima-chain.faucet" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.service.port.faucet.testnet.api }}
{{- end -}}
{{- end -}}
