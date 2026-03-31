variable "name_prefix" {
  description = "A prefix used for naming the ECS service and cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the ECS resources"
  type        = map(string)
  default     = {}
}

variable "task_definition_arn" {
  description = "The ARN of the ECS task definition to execute"
  type        = string
}

variable "subnets" {
  description = "A list of private subnets where the ECS tasks will be deployed"
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs governing the ECS service network traffic"
  type        = list(string)
}

variable "load_balancer" {
  description = "Load balancer configuration consisting of target group ARN, container name, and port"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
}

variable "desired_count" {
  description = "The number of concurrent tasks that should be running as part of the service"
  type        = number
  default     = 1
}
