locals {
  env    = lower(var.environment)
  app    = lower(var.app_name)
  prefix = "${local.app}-${local.env}"

  common_tags = {
    Environment = local.env
    Project     = local.app
    Region      = var.aws_region
    ManagedBy   = "Terraform"
  }
}