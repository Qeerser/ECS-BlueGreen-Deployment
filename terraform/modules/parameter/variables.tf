variable "app_name" {
  description = "The application name, used as part of the SSM Parameter path"
  type        = string
}

variable "environment" {
  description = "The deployment environment, used as part of the SSM Parameter path"
  type        = string
}

variable "s3_key" {
  description = "The initial S3 URI value to store in the Systems Manager Parameter"
  type        = string
}

variable "tags" {
  description = "A map of tags applied to the SSM Parameter"
  type        = map(string)
  default     = {}
}
