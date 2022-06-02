## allow - ECS frontend -> public-api

resource "consul_config_entry" "frontend_to_public_api_intention" {
  name = "public-api"
  kind = "service-intentions"
  partition = consul_admin_partition.ecs-dev.name
  namespace = "default"

  config_json = jsonencode({
    Sources = [
      {
        Action     = "allow"
        Name       = "frontend"
        Type       = "consul"
        Namespace  = "default"
        Partition  = consul_admin_partition.ecs-dev.name
      }
    ]
  })
}
