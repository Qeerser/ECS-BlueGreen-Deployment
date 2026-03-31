output "s3_key_arn" {
  description = "The ARN of the SSM Parameter holding the S3 key"
  value       = aws_ssm_parameter.s3_key.arn
}

output "s3_key_name" {
  description = "The name of the SSM Parameter holding the S3 key"
  value       = aws_ssm_parameter.s3_key.name
}

output "s3_key_version" {
  description = "The version of the SSM Parameter holding the S3 key"
  value       = aws_ssm_parameter.s3_key.version
}
