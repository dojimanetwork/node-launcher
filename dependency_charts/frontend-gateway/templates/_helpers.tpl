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
Landing page http Port
*/}}
{{- define "gateway-landing-page.http" -}}
    {{ .Values.service.port.landing_page.http }}
{{- end -}}

{{/*
Landing page domain name
*/}}
{{- define "gateway-landing-page.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.landing_page.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.landing_page.mainnet }}
{{- end -}}
{{- end -}}

{{/*
Dojima wallet page domain name
*/}}
{{- define "gateway-dojima-wallet.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.dojima_wallet.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.dojima_wallet.mainnet }}
{{- end -}}
{{- end -}}


{{/*
Dojima wallet http Port
*/}}
{{- define "gateway-dojima-wallet.http" -}}
    {{ .Values.service.port.dojima_wallet.http }}
{{- end -}}


{{/*
Dojima explorer http Port
*/}}
{{- define "gateway-dojima-explorer.http" -}}
    {{ .Values.service.port.dojima_explorer.http }}
{{- end -}}


{{/*
Dojima explorer page domain name
*/}}
{{- define "gateway-dojima-explorer.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.block_explorer.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.block_explorer.mainnet }}
{{- end -}}
{{- end -}}


{{/*
Developer docs page domain name
*/}}
{{- define "gateway-developer-docs.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.developer_doc.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.developer_doc.mainnet }}
{{- end -}}
{{- end -}}


{{/*
faas  domain name
*/}}
{{- define "gateway-faas.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.faas.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.faas.mainnet }}
{{- end -}}
{{- end -}}



{{/*
dojima blockscout  domain name
*/}}
{{- define "gateway-dojima-blockscout.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.blockscout.testnet }}
{{- else if eq (include "gateway.net" .) "mainnet" -}}
    {{ .Values.domain.blockscout.mainnet }}
{{- end -}}
{{- end -}}


{{/*
kubecost domain name
*/}}
{{- define "gateway-dojima-kubecost.domain" -}}
{{- if eq (include "gateway.net" .) "testnet" -}}
    {{ .Values.domain.kubecost.testnet }}
{{- end -}}
{{- end -}}

{{/*
Developer docs http Port
*/}}
{{- define "gateway-developer-docs.http" -}}
    {{ .Values.service.port.developer_docs.http }}
{{- end -}}

{{/*
faas http Port
*/}}
{{- define "gateway-faas.http" -}}
    {{ .Values.service.port.faas.http }}
{{- end -}}


{{/*
blockscout http Port
*/}}
{{- define "gateway-dojima-blockscout.http" -}}
    {{ .Values.service.port.bs.http }}
{{- end -}}


{{/*
kubecost http Port
*/}}
{{- define "gateway-dojima-kubecost.http" -}}
    {{ .Values.service.port.kubecost.http }}
{{- end -}}