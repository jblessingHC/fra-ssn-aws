output "hcp_consul_public_endpoint_url" {
  value = "${hcp_consul_cluster.hcp_consul.consul_public_endpoint_url}"
}

output "hcp_acl_token_secret_id" {
  value = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "eks_prod_kubeconfig_filename" {
  value = abspath(module.hcp_eks_prod.kubeconfig_filename)
}

output "eks_prod_hashicups_url" {
  value = module.hcp_eks_prod.hashicups_url
}

output "eks_dev_kubeconfig_filename" {
  value = abspath(module.hcp_eks_dev.kubeconfig_filename)
}

output "eks_dev_hashicups_url" {
  value = module.hcp_eks_dev.hashicups_url
}

output "ecs_dev_hashicups_url" {
  value = module.hcp_ecs_dev.client_lb_address
}

output "ecs_dev_tls_private_key" {
  value     = module.hcp_ecs_dev.tls_private_key
  sensitive = true
}
