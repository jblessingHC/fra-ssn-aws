// Pin the versions

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.43.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.26.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.11.3"
    }
    consul = {
      source = "hashicorp/consul"
      version = "2.15.1"
    }
  }
  provider_meta "hcp" {
    module_name = "hcp-consul"
  }
}


provider "aws" {
  region = var.region
}

// Configure the providers

provider "consul" {
  address    = hcp_consul_cluster.hcp_consul.consul_public_endpoint_url
  datacenter = hcp_consul_cluster.hcp_consul.datacenter
  token      = hcp_consul_cluster_root_token.token.secret_id
}
