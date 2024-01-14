{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hermesnode.name" -}}
{{- default .Chart.Name "" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hermesnode.fullname" -}}
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
{{- define "hermesnode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hermesnode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hermesnode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Net
*/}}
{{- define "hermesnode.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{/*
Tag
*/}}
{{- define "hermesnode.tag" -}}
{{- default .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hermesnode.labels" -}}
helm.sh/chart: {{ include "hermesnode.chart" . }}
{{ include "hermesnode.selectorLabels" . }}
app.kubernetes.io/version: {{ include "hermesnode.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/net: {{ include "hermesnode.net" . }}
app.kubernetes.io/type: {{ .Values.type }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "hermesnode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "hermesnode.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Image
*/}}
{{- define "hermesnode.image" -}}
{{- .Values.global.hermes.image -}}:{{ .Values.global.hermes.tag }}
{{- end -}}

{{/*
RPC Port
*/}}
{{- define "hermesnode.rpc" -}}
    {{ .Values.service.port.testnet.rpc}}
{{- end -}}

{{/*
P2P Port
*/}}
{{- define "hermesnode.p2p" -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}


{{/*
ABCI Port
*/}}
{{- define "hermesnode.abci" -}}
    {{ .Values.service.port.testnet.abci }}
{{- end -}}

{{/*
Prometheus collectior Port
*/}}
{{- define "hermesnode.prometheus_collector" -}}
    {{ .Values.service.port.testnet.prometheus_collector }}
{{- end -}}

{{/*
GRPC Port
*/}}
{{- define "hermesnode.grpc" -}}
    {{ .Values.service.port.testnet.grpc }}
{{- end -}}


{{/*
GRPC Web Port
*/}}
{{- define "hermesnode.grpc-web" -}}
    {{ .Values.service.port.testnet.grpc_web }}
{{- end -}}

{{/*
PProf Port
*/}}
{{- define "hermesnode.pprof" -}}
    {{ .Values.service.port.testnet.pprof }}
{{- end -}}

{{/*
Rosetta Port
*/}}
{{- define "hermesnode.rosetta" -}}
    {{ .Values.service.port.testnet.rosetta }}
{{- end -}}

{{/*
ETH Router contract
*/}}
{{- define "hermesnode.ethRouterContract" -}}
    {{ .Values.ethRouterContract.testnet }}
{{- end -}}

{{/*
chain id
*/}}
{{- define "hermesnode.chainID" -}}
    {{ .Values.chainID.testnet }}
{{- end -}}