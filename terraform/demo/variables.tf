variable "environment" {
  description = "Environment name, e.g., 'dev', 'prod'"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy all resources"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone A for public and private subnets"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability Zone B for public and private subnets"
  type        = string
}

variable "ecs_task_cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "ecs_task_memory" {
  description = "Memory (MiB) for the ECS task"
  type        = string
  default     = "512"
}

variable "app_container_name" {
  description = "Name of the application container"
  type        = string
  default     = "webserver"
}

variable "app_port" {
  description = "Port the application container listens on"
  type        = number
  default     = 8080
}

variable "ecs_desired_count" {
  description = "Number of desired copies of the task running"
  type        = number
  default     = 2
}

variable "app_version" {
  description = "The version of the application. Bump this to trigger a new deployment."
  type        = string
}

variable "enable_autoscaling" {
  description = "Enable ECS application autoscaling"
  type        = bool
  default     = true
}
