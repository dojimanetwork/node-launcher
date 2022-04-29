{{- define "library-chart.getNamespace" -}}
{{- if and .Values.global }}
{{- if .Values.global.namespaceName }}
namespace: {{ .Values.global.namespaceName }}
{{- else }}
namespace: default
{{- end }}
{{- else }}
namespace: default
{{- end }}
{{- end }}

{{- define "library-chart.getNamespaceQuotes" -}}
{{- if and .Values.global }}
{{- if .Values.global.namespaceName }}
namespace: {{ .Values.global.namespaceName | squote }}
{{- else }}
namespace: 'default'
{{- end }}
{{- else }}
namespace: 'default'
{{- end }}
{{- end }}

{{- define "library-chart.getGateway" -}}
{{- if and .Values.global }}
{{- if .Values.global.gatewayName }}
- {{ .Values.global.gatewayName }}
{{- else }}
- default
{{- end }}
{{- else }}
- default
{{- end }}
{{- end }}