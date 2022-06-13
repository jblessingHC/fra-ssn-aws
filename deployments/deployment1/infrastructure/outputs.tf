output "hcp_consul_public_endpoint_url" {
  value = "${hcp_consul_cluster.hcp_consul.consul_public_endpoint_url}"
}

output "hcp_acl_token_secret_id" {
  value = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "eks_prod_cluster_id" {
  value = module.hcp_eks_prod.eks_prod_cluster_id
}

output "eks_dev_cluster_id" {
  value = module.hcp_eks_dev.eks_dev_cluster_id
}

#output "ecs_dev_hashicups_url" {
#  value = module.hcp_ecs_dev.client_lb_address
#}
