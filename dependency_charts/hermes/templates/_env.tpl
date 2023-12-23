{{- define "hermesnode_env" }}
{{- range $key, $value := .Values.hermesnode.environment }}
{{- $item := get $.Values.hermesnode.environment $key }}
{{- if or (kindIs "string" $item) (kindIs "int64" $item) (kindIs "bool" $item)}}
- name: {{ $key }}
  value: {{ $value | quote }}
 {{- else }}
- name: {{ $key }}
  value: {{ default $item._default | quote }}
{{- end }}
{{- end }}
{{- end }}