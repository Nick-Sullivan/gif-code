
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

resource "aws_ssm_parameter" "cognito_pool_id" {
  name  = "${local.prefix_parameter}/Cognito/UserPoolId"
  type  = "String"
  value = aws_cognito_user_pool.users.id
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name  = "${local.prefix_parameter}/Cognito/ClientId"
  type  = "String"
  value = aws_cognito_user_pool_client.users.id
}

resource "aws_ssm_parameter" "cognito_domain" {
  name  = "${local.prefix_parameter}/Cognito/Domain"
  type  = "String"
  value = "https://${aws_cognito_user_pool_domain.users.domain}.auth.ap-southeast-2.amazoncognito.com"
}

resource "aws_ssm_parameter" "automated_tester_password" {
  name  = "${local.prefix_parameter}/AutomatedTester/Password"
  type  = "SecureString"
  value = random_password.automated_tester_password.result
}

resource "aws_ssm_parameter" "automated_tester_username" {
  name  = "${local.prefix_parameter}/AutomatedTester/Username"
  type  = "String"
  value = local.automated_tester_username
}
