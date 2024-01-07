
data "aws_ssm_parameter" "api_gateway_url" {
  name = "${local.prefix_parameter}/ApiGateway/Url"
}

data "aws_ssm_parameter" "giphy_api_key" {
  name = "${local.prefix_parameter}/Secrets/GiphyApiKey"
}

data "aws_ssm_parameter" "cognito_pool_id" {
  name = "${local.prefix_parameter}/Cognito/UserPoolId"
}

data "aws_ssm_parameter" "cognito_client_id" {
  name = "${local.prefix_parameter}/Cognito/ClientId"
}

data "aws_ssm_parameter" "cognito_domain" {
  name = "${local.prefix_parameter}/Cognito/Domain"
}

data "aws_ssm_parameter" "automated_tester_password" {
  name = "${local.prefix_parameter}/AutomatedTester/Password"
}

data "aws_ssm_parameter" "automated_tester_username" {
  name = "${local.prefix_parameter}/AutomatedTester/Username"
}
