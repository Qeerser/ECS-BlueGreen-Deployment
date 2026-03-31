resource "aws_ssm_parameter" "s3_key" {
  name  = "/${var.app_name}/${var.environment}/s3_key"
  type  = "String"
  value = var.s3_key
  tags  = merge(var.tags, { Name = "${var.app_name}-${var.environment}-s3-key" })
}