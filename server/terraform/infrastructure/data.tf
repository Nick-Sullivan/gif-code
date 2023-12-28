data "aws_caller_identity" "identity" {}

data "aws_ssm_parameter" "giphy_api_key" {
  name = "${local.prefix_parameter}/Secrets/GiphyApiKey"
}

data "aws_ssm_parameter" "s3_bucket_name" {
  name = "${local.prefix_parameter}/S3/Name"
}

data "aws_ssm_parameter" "s3_bucket_arn" {
  name = "${local.prefix_parameter}/S3/Arn"
}
