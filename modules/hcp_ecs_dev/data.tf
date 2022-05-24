data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_security_group" "vpc_default" {
  name   = "default"
  vpc_id = var.ecs_dev_vpc_id
}

data "aws_security_group" "eks_dev_vpc_default" {
  name   = "default"
  vpc_id = var.eks_dev_aws_vpc_id
}
