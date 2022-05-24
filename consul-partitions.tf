// Create Admin Partition and Namespace for the client
resource "consul_admin_partition" "ecs-dev" {
  name        = "ecs-dev"
  description = "Partition for ecs service"
}

resource "consul_admin_partition" "eks-dev" {
  name        = "eks-dev"
  description = "Partition for ecs service"
}