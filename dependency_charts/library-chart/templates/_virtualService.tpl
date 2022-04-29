{{/*
Define virtualService.yaml file.
*/}}
{{- define "library-chart.virtualService" -}}
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ .Values.name }}
  {{- include "library-chart.getNamespace" . | indent 2 }}
spec:
  hosts:
    - "*"
  gateways:
    {{- include "library-chart.getGateway" . | indent 4 }}
  http:
    - match:
        - uri:
            prefix: {{ .Values.uriPrefix }}
      route:
        - destination:
            host: service-{{ .Values.name }}
            port:
              number: {{ .Values.serverPort }}
{{- end }}