resource "consul_config_entry" "proxy_defaults" {

  kind = "proxy-defaults"
  name = "global"

  config_json = jsonencode({
    MeshGateway = {
      Mode = "local"
    }
    Protocol    = "http"
    Config = {
      envoy_tracing_json = {"http":{"name":"envoy.tracers.zipkin","typed_config":{"@type":"type.googleapis.com/envoy.config.trace.v3.ZipkinConfig","collector_cluster": "jaeger_9411","collector_endpoint": "/api/v2/spans", "collector_endpoint_version": "HTTP_JSON"}}}
      envoy_extra_static_clusters_json = {"connect_timeout":"3.000s","dns_lookup_family":"V4_ONLY","lb_policy":"ROUND_ROBIN","load_assignment":{"cluster_name":"jaeger_9411","endpoints":[{"lb_endpoints":[{"endpoint":{"address":{"socket_address":{"address":"jaeger-collector","port_value":9411,"protocol":"TCP"}}}}]}]},"name":"jaeger_9411","type":"STRICT_DNS"}
    }
  })
}

