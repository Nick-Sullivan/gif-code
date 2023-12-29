
data "aws_ssm_parameter" "api_gateway_url" {
  name = "${local.prefix_parameter}/ApiGateway/Url"
}

data "aws_ssm_parameter" "giphy_api_key" {
  name = "${local.prefix_parameter}/Secrets/GiphyApiKey"
}
