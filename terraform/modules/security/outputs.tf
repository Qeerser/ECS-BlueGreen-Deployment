output "lb_sg_id" {
  description = "The ID of the security group for the load balancer"
  value       = aws_security_group.lb_sg.id
}

output "ecs_sg_id" {
  description = "The ID of the security group for the ECS tasks"
  value       = aws_security_group.ecs_sg.id
}

output "task_execution_role_arn" {
  description = "The ARN of the ECS task execution IAM role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "The ARN of the ECS task IAM role (for S3 and other AWS service access)"
  value       = aws_iam_role.ecs_task_role.arn
}

output "code_deploy_role_arn" {
  description = "The ARN of the CodeDeploy IAM role"
  value       = aws_iam_role.code_deploy_role.arn
}
