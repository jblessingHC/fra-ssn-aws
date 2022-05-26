terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

data "aws_regions" "current" {}

output "aws_regions" {
  value = data.aws_regions.current
}