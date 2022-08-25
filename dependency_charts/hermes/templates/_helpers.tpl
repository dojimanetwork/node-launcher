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
{{- "" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{
/*
    Create chart name and version as used by the chart label
*/
}}
{{- define "hermesnode.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{ /*
Selector labels
*/}}
{{- define "hermesnode.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hermesnode.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{
/* Net */
}}
{{- define "hermesnode.net" -}}
{{- default .Values.net .Values.global.net -}}
{{- end -}}

{{
/* Tag */
}}
{{- define "hermesnode.tag" -}}
{{- default .Values.global.tag .Values.image.tag .Chart.AppVersion -}}
{{- end -}}

{{
/* Common labels */
}}
{{- define "hermesnode.labels" -}}
helm.sh/chart: {{ include "hermesnode.chart" }}
{{ include "hermesnode.selectorLabels" . }}
app.kubernetes.io/version: {{ include "hermesnode.tag" . | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/net: {{ include "hermesnode.net" . }}
app.kubernetes.io/type: {{ .Values.type }}
{{- end -}}

{{ /* Create the name of the service account to use  */}}
{{- define "hermesnode.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "hermesnode.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{ /*Image */}}
{{- define "hermesnode.image" -}}
{{/* A hash is not needed for mocknet/testnet, or in the case that a node is not a validator w/ key material and autoupdate is enabled. */}}
{{- if or (eq (include "hermesnode.net" .) "testnet") (and .Values.autoupdate.enable (eq .Values.type "fullnode")) -}}
{{- .Values.image.repository -}}: {{ include "hermesnode.tag"}}
{{- else -}}
{{- .Values.image.repository -}}:{{ include "hermesnode.tag" .}}
{{- end -}}
{{- end -}}

{{ /* RPC port */}}
{{- define "hermesnode.rpc" -}}
{{- if eq (include "hermesnode.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.rpc}}
{{- end -}}
{{- end -}}

{{/* P2P port */}}
{{- define "hermesnode.p2p" -}}
{{- if eq (include "hermesnode.net" .) "testnet" -}}
    {{ .Values.service.port.testnet.p2p }}
{{- end -}}
{{- end -}}

{{/* eth Router contract */}}
{{- define "hermesnode.ethRouterContract" -}}
{{- if eq (include "hermesnode.net" .) "testnet" }}
    {{ .Values.ethRouterContract.testnet }}
{{- end -}}
{{- end -}}

{{ /* chain id */}}
{{- define "hermesnode.chainID" -}}
{{- if eq (include "hermesnode.net" .) "testnet" }}
    {{ .Values.chainID.testnet }}
{{- end -}}
{{- end -}}