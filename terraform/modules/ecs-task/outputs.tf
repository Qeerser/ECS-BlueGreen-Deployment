output "ecs_task_definition_arn" {
  description = "The ARN of the registered ECS task definition"
  value       = aws_ecs_task_definition.main-task.arn
}

output "ecs_task_definition_family" {
  description = "The family of the registered ECS task definition"
  value       = aws_ecs_task_definition.main-task.family
}
