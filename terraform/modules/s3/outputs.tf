output "bucket_id" {
  description = "The ID (name) of the S3 bucket"
  value       = aws_s3_bucket.media.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.media.arn
}

output "bucket_name" {
  description = "The dynamically generated name of the S3 bucket (with random suffix)"
  value       = aws_s3_bucket.media.bucket
}

output "index_v1_url" {
  description = "The URL of the index.html file in the S3 bucket"
  value       = aws_s3_object.index_v1.bucket
}