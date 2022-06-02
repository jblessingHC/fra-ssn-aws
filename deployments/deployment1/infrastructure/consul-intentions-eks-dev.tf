## allow - ingress-gateway -> nginx
resource "consul_config_entry" "ingress_gateway_to_nginx_intention" {
  name = "nginx"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "ingress-gateway"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      }
    ]
  })
}

## allow - nginx -> frontend
resource "consul_config_entry" "nginx_to_frontend_intention" {
  name = "frontend"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "nginx"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      }
    ]
  })
}

## allow - nginx -> public-api
resource "consul_config_entry" "nginx_to_public_api_intention" {
  name = "public-api"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "nginx"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      }
    ]
  })
}

## allow - public-api -> product-api
resource "consul_config_entry" "public_api_to_product_api_intention" {
  name = "product-api"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "public-api"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      },
      {
        Action     = "allow"
        Name       = "public-api"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.ecs-dev.name
      }
    ]
  })
}

## allow - public-api -> payments
resource "consul_config_entry" "public_api_to_payments_intention" {
  name = "payments"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "public-api"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      },
      {
        Action     = "allow"
        Name       = "public-api"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.ecs-dev.name
      }

    ]
  })
}

## allow - product-api -> product-api-db
resource "consul_config_entry" "product_api_to_product_api_db_intention" {
  name = "product-api-db"
  kind = "service-intentions"
  partition = consul_admin_partition.eks-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "product-api"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.eks-dev.name
      }
    ]
  })
}

