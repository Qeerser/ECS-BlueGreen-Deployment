output "codedeploy_app_name" {
  description = "The name of the CodeDeploy application"
  value       = aws_codedeploy_app.main.name
}

output "codedeploy_deployment_group_name" {
  description = "The name of the CodeDeploy deployment group managing ECS Blue/Green deployment"
  value       = aws_codedeploy_deployment_group.main.deployment_group_name
}
