variable "name_prefix" {
  description = "A prefix used for naming the ALB and Target Groups"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the Application Load Balancer will reside"
  type        = string
}

variable "tags" {
  description = "A map of tags applied to the ALB and Target Group resources"
  type        = map(string)
  default     = {}
}

variable "lb_sg_id" {
  description = "The ID of the Security Group allowing access to the Load Balancer"
  type        = string
}

variable "public_subnet_a_id" {
  description = "The ID of the first public subnet required for the external Load Balancer"
  type        = string
}

variable "public_subnet_b_id" {
  description = "The ID of the second public subnet required for Load Balancer high availability"
  type        = string
}