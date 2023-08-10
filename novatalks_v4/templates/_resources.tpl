{{ define "getAdditionalRoutes" }}
  {{- $arg1 := index . 0 }}
  {{- $arg2 := index . 1 }}
  {{- range $k, $v := $arg2 }}
  - match: Host(`{{ $v.baseUrl }}`) && PathPrefix(`{{ $v.pathPrefix }}`)
    kind: Rule
    priority: {{ $v.priority }}
    services:
      - name:  {{ $arg1.Values.global.project_name }}-botflow
        namespace:  {{ $arg1.Values.global.customer_name }}  
        port: {{ $arg1.Values.botflow.servicePort }}
  {{- end }}
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

{{ define "getNodes" }}
  {{- $argRes := index . 0}}
  {{- range $k, $v := $argRes }}
                    - {{ $v }}
  {{- end }}
{{ end }}

{{ define "getNodesPGCluster" }}
  {{- $argRes := index . 0}}
  {{- range $k, $v := $argRes }}
                - {{ $v }}
  {{- end }}
{{ end }}