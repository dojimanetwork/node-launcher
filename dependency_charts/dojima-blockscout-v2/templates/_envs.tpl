{{- define "frontend_env" }}
{{- range $key, $value := .Values.frontend.environment }}
{{- $item := get $.Values.frontend.environment $key }}
{{- if or (kindIs "string" $item) (kindIs "int64" $item) (kindIs "bool" $item)}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}