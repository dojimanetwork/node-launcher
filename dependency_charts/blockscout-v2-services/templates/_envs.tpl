{{- define "postgres_env" }}
{{- range $key, $value := .Values.postgres.environment }}
{{- $item := get $.Values.postgres.environment $key }}
{{- if or (kindIs "string" $item) (kindIs "int64" $item) (kindIs "bool" $item)}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- else }}
- name: {{ $key }}
  value: {{ default $item._default | quote }}
{{- end }}
{{- end }}
{{- end }}


{{- define "scVerifier_env" }}
{{- range $key, $value := .Values.scVerifier.environment }}
{{- $item := get $.Values.scVerifier.environment $key }}
{{- if or (kindIs "string" $item) (kindIs "int64" $item) (kindIs "bool" $item)}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- else }}
- name: {{ $key }}
  value: {{ default $item._default | quote }}
{{- end }}
{{- end }}
{{- end }}


{{- define "stats_env" }}
{{- range $key, $value := .Values.stats.environment }}
{{- $item := get $.Values.stats.environment $key }}
{{- if or (kindIs "string" $item) (kindIs "int64" $item) (kindIs "bool" $item)}}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- else }}
- name: {{ $key }}
  value: {{ default $item._default | quote }}
{{- end }}
{{- end }}
{{- end }}