{{/*
Define deployment.yaml file.
*/}}
{{- define "library-chart.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ required "chart name is required" .Values.name }}-deployment
{{- include "library-chart.getNamespace" . | indent 2 }}
spec:
  selector:
    matchLabels:
      app: {{ .Values.name }}
  replicas: {{ default 1 .Values.replicaCount }}
  {{- if .Values.strategy }}
  {{- if eq .Values.strategy.enable true }}
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: {{ default 2 .Values.strategy.maxSurge }}
      maxUnavailable: {{ default 1 .Values.strategy.maxUnavailable }}
  {{- end }}
  {{- end }}
  template:
    metadata:
      labels:
        app: {{ .Values.name }}
      annotations:
        prometheus.io/scrape: 'true'
        prometheus.io/port: '{{ .Values.prometheusPort }}'
        prometheus.io/path: '/metrics'
    spec:
      containers:
        - image: {{ .Values.image.name }}:{{ .Values.image.tag  }}
          imagePullPolicy: {{ default "Always" .Values.imagePullPolicy }}
          name: {{ .Values.name }}
          ports:
            - containerPort: {{ .Values.serverPort }}
            - containerPort: {{ .Values.prometheusPort }}
          {{- if .Values.resources }}
          {{- if eq .Values.resources.enable true }}
          resources:
            requests:
              memory: {{ default "30Mi" .Values.resources.requestsMemory | quote }}
              cpu: {{ default "10m" .Values.resources.requestsCpu | quote  }}
            limits:
              memory:  {{ default "90Mi" .Values.resources.limitsMemory | quote }}
              cpu: {{ default "50m" .Values.resources.limitsCpu | quote }}
          {{- end }}
          {{- end }}
          {{- if .Values.env }}
          env:
            {{- range $key, $value := .Values.env }}
            - name: {{ $key }}
              value: {{ $value | quote }}
            {{- end }}
          {{- end }}
{{- end }}
