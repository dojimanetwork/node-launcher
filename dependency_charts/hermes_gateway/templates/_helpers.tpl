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
    {{ .Values.domain.h4s.testnet.rpc }}
{{- end -}}


{{/*
Api port domain name
*/}}
{{- define "gateway-hermes-api.domain" -}}
    {{ .Values.domain.h4s.testnet.api }}
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
ethereum wss port domain name
*/}}
{{- define "gateway-hermes-eth-ws.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.eth_ws }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.eth_ws }}
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
ethereum port domain name
*/}}
{{- define "gateway-hermes-eth-api.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.eth }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.eth }}
{{- end -}}
{{- end -}}

{{/*
Dojima chain api port domain name
*/}}
{{- define "gateway-dc-api.domain" -}}
    {{ .Values.domain.d11k.testnet.api }}
{{- end -}}

{{/*
Dojima chain rpc port domain name
*/}}
{{- define "gateway-dc-rpc.domain" -}}
    {{ .Values.domain.d11k.testnet.wss }}
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
Binance rpc domain name
*/}}
{{- define "gateway-bnb-rpc.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.h4s.testnet.bnb }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.h4s.mainnet.bnb }}
{{- end -}}
{{- end -}}

{{/*
Fiber api domain name
*/}}
{{- define "gateway-bex-fiber.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.fiber.testnet.api }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.fiber.mainnet.api }}
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
    {{ .Values.service.port.arweave.testnet.api }}
{{- end -}}

{{/*
Solana rpc Port
*/}}
{{- define "gateway-solana-daemon.rpc" -}}
    {{ .Values.service.port.solana.testnet.rpc }}
{{- end -}}


{{/*
Solana ws Port
*/}}
{{- define "gateway-solana-daemon.wss" -}}
    {{ .Values.service.port.solana.testnet.wss }}
{{- end -}}


{{/*
Solana udp Port
*/}}
{{- define "gateway-solana-daemon.udp" -}}
    {{ .Values.service.port.solana.testnet.udp }}
{{- end -}}

{{/*
Solana gossip Port
*/}}
{{- define "gateway-solana-daemon.gossip" -}}
    {{ .Values.service.port.solana.testnet.gossip }}
{{- end -}}


{{/*
Solana tpu Port
*/}}
{{- define "gateway-solana-daemon.tpu" -}}
    {{ .Values.service.port.solana.testnet.tpu }}
{{- end -}}

{{/*
Polkadot wss Port
*/}}
{{- define "gateway-polkadot-daemon.wss" -}}
    {{ .Values.service.port.polkadot.testnet.wss }}
{{- end -}}


{{/*
Polkadot http Port
*/}}
{{- define "gateway-polkadot-daemon.http" -}}
    {{ .Values.service.port.polkadot.testnet.http }}
{{- end -}}


{{/*
DC http Port
*/}}
{{- define "gateway-dojima-chain.http" -}}
   {{ .Values.service.port.dc.testnet.http }}
{{- end -}}


{{/*
DC wss/rpc Port
*/}}
{{- define "gateway-dojima-chain.rpc" -}}
    {{ .Values.service.port.dc.testnet.wss }}
{{- end -}}

{{/*
DC p2p Port
*/}}
{{- define "gateway-dojima-chain.p2p" -}}
    {{ .Values.service.port.dc.testnet.p2p }}
{{- end -}}

{{/*
faucet Port
*/}}
{{- define "gateway-dojima-chain.faucet" -}}
    {{ .Values.service.port.faucet.testnet.api }}
{{- end -}}


{{/*
ETH wss/rpc Port
*/}}
{{- define "gateway-eth-chain.wss" -}}
    {{ .Values.service.port.ethereum.testnet.wss }}
{{- end -}}


{{/*
ETH wss Port
*/}}
{{- define "gateway-eth-chain.api" -}}
    {{ .Values.service.port.ethereum.testnet.api }}
{{- end -}}

{{/*
Binance rpc Port
*/}}
{{- define "gateway-bnb-chain.rpc" -}}
    {{ .Values.service.port.binance.testnet.rpc }}
{{- end -}}

{{/*
Fiber api Port
*/}}
{{- define "gateway-bex-fiber.api" -}}
    {{ .Values.service.port.fiber.testnet.api }}
{{- end -}}

{{/*
Hermes GRPC Port
*/}}
{{- define "gateway-hermes.grpc" -}}
    {{ .Values.service.port.grpc }}
{{- end -}}