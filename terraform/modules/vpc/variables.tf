variable "name_prefix" {
  description = "Prefix applied to all VPC resources for easy project tracking"
  type        = string
}

variable "availability_zone_a" {
  description = "Primary availability zone mapped to public and private 'a' subnets"
  type        = string
}

variable "availability_zone_b" {
  description = "Secondary availability zone mapped to public and private 'b' subnets"
  type        = string
}

variable "tags" {
  description = "Standard tags appended to all networking resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "The primary IPv4 CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}