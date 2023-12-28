
resource "aws_s3_bucket" "bucket" {
  bucket = local.prefix_lower
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  # the CORS configuration for Presigned URLs uploading to the bucket
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    id     = "delete_gifs"
    status = "Enabled"
    expiration {
      days = 10
    }
    filter {
      prefix = "temp"
    }
  }
}