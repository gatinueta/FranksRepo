{{- define "mychart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    name: {{ .Values.favorite.drink }}
{{- end }}

