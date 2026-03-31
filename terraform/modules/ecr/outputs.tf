output "app_repository_url" {
  value       = aws_ecr_repository.app.repository_url
  description = "URL of the application ECR repository"
}

output "sidecar_repository_url" {
  value       = aws_ecr_repository.sidecar.repository_url
  description = "URL of the sidecar ECR repository"
}
