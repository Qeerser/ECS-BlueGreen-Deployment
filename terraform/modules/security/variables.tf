variable "name_prefix" {
  description = "A localized prefix to name IAM roles and security groups uniformly"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID under which all security groups will be provisioned"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the security resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS Region"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the specific S3 bucket to allow read access"
  type        = string
}

variable "ssm_parameter_arn" {
  description = "The ARN of the specific SSM parameter to allow read access"
  type        = string
}

variable "app_port" {
  description = "The port exposed by the application tasks to define inbound rules"
  type        = number
  default     = 8080
}