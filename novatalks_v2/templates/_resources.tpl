{{ define "get.resources.dict" }}
{{- $uimem := dict "" "" -}}
{{- $uicpu := dict "" "" -}}
{{- range $k, $v := .Values.ui.memsizing -}}{{- $_ := set $uimem $k $v -}}{{- end }}
{{- range $k, $v := .Values.ui.cpusizing -}}{{- $_ := set $uicpu $k $v -}}{{- end }}
        resources:
          limits:
            memory: {{ get $uimem .Values.ui.resources | default "256Mi" | quote }}
            cpu: {{ get $uicpu .Values.ui.resources | default "300m" | quote }}
          requests:
            memory: "128Mi"
{{ end }}



{{ define "getSizingResources" }}
  {{- $argRes := index . 0}}
  {{- $argSize := index . 1}}
  {{- range $k, $v := $argRes }}
    {{- if eq $argSize $k }}
      {{- range $k1, $v1 := $v }}
            {{ $k1 }}: {{ $v1 | quote}}
      {{- end }}
    {{- end }}
  {{- end }}
{{ end }}


{{ define "resources.ui.test" }}
        resources:
          limits:
          {{- include "getSizingResources" ( list $.Values.ui.resources $.Values.ui.sizing ) }}
          requests:
            memory: "128Mi"
{{ end }}

{{ define "getNodes" }}
  {{- $argRes := index . 0}}
  {{- range $k, $v := $argRes }}
                    - {{ $v }}
  {{- end }}
{{ end }}
