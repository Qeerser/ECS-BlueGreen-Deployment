variable "aws_account_id" {
  description = "The AWS account ID used for ARN construction in the secrets configuration"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where CloudWatch Logs and SSM parameters are located"
  type        = string
}

variable "tags" {
  description = "A map of tags mapping to the ECS task and logs"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "The application name, used to form resource names and log groups"
  type        = string
}

variable "environment" {
  description = "The deployment environment, used to form resource names and log groups"
  type        = string
}

variable "task_execution_role_arn" {
  description = "The ARN of the IAM role responsible for executing the ECS task (pulling images, writing logs)"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the IAM role granted to the running ECS containers (e.g., S3 access)"
  type        = string
}

variable "cpu" {
  description = "The number of CPU units allocated to the task definition"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The amount of memory (MiB) allocated to the task definition"
  type        = string
  default     = "512"
}

variable "volume_name" {
  description = "The logical name for the ephemeral volume shared between containers"
  type        = string
  default     = "shared-storage"
}

variable "app_container_name" {
  description = "The name for the primary application container"
  type        = string
}

variable "app_container_image" {
  description = "The image URI for the primary application container"
  type        = string
}

variable "app_port" {
  description = "The exposed listening port of the application container"
  type        = string
}

variable "app_secrets_map" {
  description = "A map mapping environment variable names to SSM parameter names"
  type        = map(string)
  default     = {}
}

variable "sidecar_container_name" {
  description = "The name for the sidecar container responsible for retrieving content"
  type        = string
}

variable "sidecar_container_image" {
  description = "The image URI for the sidecar container"
  type        = string
}

variable "s3_key_version" {
  description = "Explicit version for SSM Parameter if required. Currently unused or acts as a cache-buster."
  type        = string
  default     = ""
}