locals {
  cluster = "efrouting"
  #vpc_id  = "vpc-de9fdfa4"
  security_groups = ["sg-01b7de5d8bd36430c"]
  subnets = [
    "subnet-37826c51",
    "subnet-3d8f2f33",
    "subnet-cd50ee80"
  ]
  role = "arn:aws:iam::754234134912:role/ecsTaskExecutionRole"
}
module "ecs" {
  source                = "./modules/fargate"
  cluster_name          = local.cluster
  task_family           = local.cluster
  container_definitions = file("./container_definitions.json")
  task_role_arn         = local.role
  execution_role_arn    = local.role
  subnets               = local.subnets
  security_groups       = local.security_groups

}
