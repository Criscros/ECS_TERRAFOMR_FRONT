resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
#task definition
data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  depends_on      = [aws_ecs_task_definition.this]
}
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  container_definitions    = var.container_definitions
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  memory                   = "1024"
  cpu                      = "512"
  network_mode             = "awsvpc"
}

resource "aws_ecs_service" "this" {
  name                 = var.cluster_name
  cluster              = aws_ecs_cluster.this.arn
  desired_count        = 1
  force_new_deployment = true
  network_configuration {
    assign_public_ip = true
    subnets          = var.subnets
    security_groups  = var.security_groups
  }
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.this.family}:${max(aws_ecs_task_definition.this.revision, data.aws_ecs_task_definition.this.revision)}"
}
