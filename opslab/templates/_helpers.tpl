{{- define "opslab.labels" -}}
app.kubernetes.io/part-of: opslab
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{- define "opslab.selector" -}}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/name: {{ .name }}
{{- end }}

{{/* Fully qualified image of a component: (dict "root" $ "name" "api") */}}
{{- define "opslab.image" -}}
{{ .root.Values.image.registry }}/opslab-{{ .name }}:{{ .root.Values.image.tag | default (printf "v%s" .root.Chart.AppVersion) }}
{{- end }}

{{- define "opslab.replicas" -}}
{{ if eq .Values.profile "cluster" }}2{{ else }}1{{ end }}
{{- end }}

{{- define "opslab.podSecurityContext" -}}
runAsNonRoot: true
runAsUser: 65532
runAsGroup: 65532
seccompProfile:
  type: RuntimeDefault
{{- end }}

{{- define "opslab.containerSecurityContext" -}}
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
capabilities:
  drop: [ALL]
{{- end }}
