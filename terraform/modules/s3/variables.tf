variable "name_prefix" {
  description = "A prefix used for naming the underlying S3 resources"
  type        = string
}

variable "tags" {
  description = "Common tags applied to the S3 bucket"
  type        = map(string)
  default     = {}
}