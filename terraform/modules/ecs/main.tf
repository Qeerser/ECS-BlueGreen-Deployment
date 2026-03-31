resource "aws_ecs_cluster" "main" {
  name = "${var.name_prefix}-cluster"
  tags = merge(var.tags, { Name = "${var.name_prefix}-cluster" })
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]


}

resource "aws_ecs_service" "main" {
  name             = "${var.name_prefix}-service"
  cluster          = aws_ecs_cluster.main.id
  task_definition  = var.task_definition_arn
  desired_count    = var.desired_count
  launch_type      = "FARGATE"
  platform_version = "1.4.0"


  load_balancer {
    target_group_arn = var.load_balancer.target_group_arn
    container_name   = var.load_balancer.container_name
    container_port   = var.load_balancer.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = "false"
  }
  tags = merge(var.tags, { Name = "${var.name_prefix}-service" })

  lifecycle {
    ignore_changes = [
      task_definition,
      load_balancer
    ]
  }
}
