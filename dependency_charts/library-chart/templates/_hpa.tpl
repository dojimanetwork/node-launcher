{{/*
Define hpa.yaml file.
*/}}
{{- define "library-chart.hpa" -}}
{{- if .Values.hpa }}
{{- if eq .Values.hpa.enable true }}
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.name }}-hpa
{{- include "library-chart.getNamespace" . | indent 2 }}
spec:
  maxReplicas: {{ default 5 .Values.hpa.maxReplicas }}
  minReplicas: {{ default 3 .Values.hpa.minReplicas }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Values.name }}-deployment
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          averageUtilization: {{ default 370 .Values.hpa.hpaCpu }}
          type: Utilization
    - type: Resource
      resource:
        name: memory
        target:
          averageUtilization: {{ default 240 .Values.hpa.hpaMemory }}
          type: Utilization
{{- end }}
{{- end }}
{{- end }}