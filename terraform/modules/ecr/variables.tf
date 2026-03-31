variable "name_prefix" {
  description = "A prefix used for naming the ECS service and cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the ECS resources"
  type        = map(string)
  default     = {}
}
