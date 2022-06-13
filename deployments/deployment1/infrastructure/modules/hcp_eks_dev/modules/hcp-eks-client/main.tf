resource "kubernetes_secret" "consul_secrets" {
  metadata {
    name = "${var.cluster_id}-hcp"
#    namespace = "consul"
  }

  data = {
    caCert              = var.consul_ca_file
    gossipEncryptionKey = var.gossip_encryption_key
    bootstrapToken      = var.boostrap_acl_token
  }

  type = "Opaque"
}

resource "local_sensitive_file" "consul_helm_chart" {
  content = templatefile("${path.module}/templates/consul.tpl", {
    env_name           = var.env_name
    consul_datacenter  = var.consul_datacenter
    consul_hosts       = jsonencode(var.consul_hosts)
    cluster_id         = var.cluster_id
    k8s_api_endpoint   = var.k8s_api_endpoint
    consul_version     = substr(var.consul_version, 1, -1)    })
  filename          = "./consul_helm_chart_${var.env_name}.yaml"
}
