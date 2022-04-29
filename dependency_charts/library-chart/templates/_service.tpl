{{/*
Define service.yaml file.
*/}}
{{- define "library-chart.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: service-{{ .Values.name }}
  {{- include "library-chart.getNamespace" . | indent 2 }}
spec:
  ports:
  - name: {{ default "grpc" .Values.servicePortName }}
    port: {{ .Values.serverPort }}
    protocol: TCP
  type: ClusterIP
  selector:
    app: {{ .Values.name }}
{{- end }}