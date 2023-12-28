
resource "aws_ssm_parameter" "giphy_api_key" {
  name  = "${local.prefix_parameter}/Secrets/GiphyApiKey"
  type  = "SecureString"
  value = var.giphy_api_key
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "${local.prefix_parameter}/S3/Name"
  type  = "String"
  value = aws_s3_bucket.bucket.bucket
}

resource "aws_ssm_parameter" "s3_bucket_arn" {
  name  = "${local.prefix_parameter}/S3/Arn"
  type  = "String"
  value = aws_s3_bucket.bucket.arn
}
