variable "name_prefix" {
  description = "A localized prefix to name IAM roles and security groups uniformly"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID under which all security groups will be provisioned"
  type        = string
}

variable "tags" {
  description = "Standard tags mapped to the security and IAM resources"
  type        = map(string)
  default     = {}
}

variable "app_port" {
  description = "The port exposed by the application tasks to define inbound rules"
  type        = number
  default     = 8080
}