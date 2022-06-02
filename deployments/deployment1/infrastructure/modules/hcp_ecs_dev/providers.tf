terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.15.1"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.26.0"
    }
    consul = {
      source = "hashicorp/consul"
      version = "2.15.1"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}

provider "consul" {
  address    = var.hcp_consul_public_endpoint_url
  datacenter = var.consul_datacenter
  token      = var.boostrap_acl_token
}