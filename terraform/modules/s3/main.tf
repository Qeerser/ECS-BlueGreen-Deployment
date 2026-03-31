resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "media" {
  bucket        = "${var.name_prefix}-s3-bucket-${random_id.bucket_suffix.hex}"
  tags          = merge(var.tags, { Name = "${var.name_prefix}-s3-bucket" })
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "media" {
  bucket = aws_s3_bucket.media.id
  rule {
    object_ownership = "BucketOwnerEnforced" # Modern AWS best practice: disables ACLs entirely
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "media" {
  bucket                  = aws_s3_bucket.media.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index_v1" {
  bucket = aws_s3_bucket.media.id
  key    = "v1/index.html"
  source = "${path.module}/../../../web/v1/index.html"
}