module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"
#  version = "18.23.0"

  cluster_name             = var.cluster_name
  cluster_version          = "1.21"
  subnets                  = var.public_subnets
#  subnet_ids                  = var.public_subnets
#  subnets                  = var.private_subnets
  vpc_id                   = var.vpc_id
  wait_for_cluster_timeout = 900
#  cluster_timeouts = {
#    create = "20m"
#    delete = "20m"
#  }

  node_groups = {
#  eks_managed_node_groups = {
    application = {
      name_prefix      = "hashicups"
      instance_types   = ["t3a.medium"]
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3
#      min_size     = 3
#      max_size     = 3
#      desired_size = 3
    }
  }
}

resource "kubernetes_secret" "consul_secrets" {
  metadata {
    name = "${var.hcp_cluster_id}-hcp"
  }

  data = {
    caCert              = base64decode(var.consul_ca_file)
    gossipEncryptionKey = jsondecode(base64decode(var.consul_config_file))["encrypt"]
    bootstrapToken      = var.boostrap_acl_token
  }

  type = "Opaque"

  depends_on = [module.eks]
}

resource "local_sensitive_file" "consul_helm_chart" {
  content = templatefile("${path.module}/templates/consul.tpl", {
    env_name           = var.env_name
    consul_datacenter  = var.consul_datacenter
    consul_hosts       = jsonencode(jsondecode(base64decode(var.consul_config_file))["retry_join"])
    cluster_id         = var.hcp_cluster_id
    k8s_api_endpoint   = module.eks.cluster_endpoint
    consul_version     = substr(var.consul_version, 1, -1)    })
  filename          = "./consul_helm_chart_${var.env_name}.yaml"
  depends_on = [kubernetes_secret.consul_secrets]
}


#module "eks_consul_client" {
#  source  = "./modules/hcp-eks-client"
#
#  env_name         = var.env_name
#  cluster_id       = var.hcp_cluster_id
#  consul_hosts     = jsondecode(base64decode(var.consul_config_file))["retry_join"]
#  k8s_api_endpoint = module.eks.cluster_endpoint
#  consul_version   = var.consul_version
#
#  boostrap_acl_token    = var.boostrap_acl_token
#  consul_ca_file        = base64decode(var.consul_ca_file)
#  consul_datacenter     = var.consul_datacenter
#  gossip_encryption_key = jsondecode(base64decode(var.consul_config_file))["encrypt"]
#
#  # The EKS node group will fail to create if the clients are
#  # created at the same time. This forces the client to wait until
#  # the node group is successfully created.
#  depends_on = [module.eks]
#}
