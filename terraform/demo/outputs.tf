output "alb_dns_name" {
  value       = module.loadbalancer.alb_dns_name
  description = "The DNS name of the load balancer"
}

output "app_repository_url" {
  value       = module.ecr.app_repository_url
  description = "The URL of the application ECR repository"
}

output "sidecar_repository_url" {
  value       = module.ecr.sidecar_repository_url
  description = "The URL of the sidecar ECR repository"
}

output "aws_region" {
  value       = var.aws_region
  description = "The AWS region"
}

output "codedeploy_app_name" {
  value       = module.codedeploy.codedeploy_app_name
  description = "The CodeDeploy Application name"
}

output "codedeploy_deployment_group_name" {
  value       = module.codedeploy.codedeploy_deployment_group_name
  description = "The CodeDeploy Deployment Group name"
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
  description = "The ECS Cluster name"
}

output "ecs_service_name" {
  value       = module.ecs.service_name
  description = "The ECS Service name"
}

output "ecs_task_definition_family" {
  value       = module.ecs_task.ecs_task_definition_family
  description = "The ECS Task Definition family"
}