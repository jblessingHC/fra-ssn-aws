terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.26.0"
    }
  }
}

// Configure the provider
provider "hcp" {}

data "hcp_consul_versions" "default" {}

output "hcp_consul_supported_versions" {
  value = data.hcp_consul_versions.default
}
