# Required for Mesh Gateway Security Group Rule
output "cluster_primary_security_group_id" {
  value = module.eks.cluster_primary_security_group_id
}

output "eks_dev_cluster_id" {
  value = module.eks.cluster_id
}