{{- define "tactical.fullname" -}}
{{ include "tactical.name" . }}-{{ .Chart.Name }}
{{- end }}

{{- define "tactical.name" -}}
{{ .Chart.Name }}
{{- end }}
