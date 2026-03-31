variable "name_prefix" {
  description = "A prefix used for naming resources (e.g., app_name-env)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources in this module"
  type        = map(string)
  default     = {}
}

variable "code_deploy_role_arn" {
  description = "The ARN of the IAM role that CodeDeploy will assume to perform deployments"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster where the service to deploy runs"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service to deploy"
  type        = string
}

variable "load_balancer" {
  description = "Configuration block defining the listener and target groups for Blue/Green deployment"
  type = object({
    listener_arn            = string
    target_group_name_blue  = string
    target_group_name_green = string
  })
}

variable "deployment_config_name" {
  description = "The name of the CodeDeploy deployment configuration (e.g., CodeDeployDefault.ECSAllAtOnce)"
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "termination_wait_time_in_minutes" {
  description = "The number of minutes to wait before terminating the original (blue) instances after successful green deployment"
  type        = number
  default     = 5
}
