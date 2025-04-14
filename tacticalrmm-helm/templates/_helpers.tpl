{{- define "tacticalrmm.fullname" -}}
{{ include "tacticalrmm.name" . }}-{{ .Chart.Name }}
{{- end }}

{{- define "tacticalrmm.name" -}}
{{ .Chart.Name }}
{{- end }}
