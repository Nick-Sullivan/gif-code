output "gateway_url" {
  description = "URL for invoking API Gateway."
  value       = aws_api_gateway_stage.gateway.invoke_url
}

resource "aws_ssm_parameter" "api_gateway_url" {
  name  = "${local.prefix_parameter}/ApiGateway/Url"
  type  = "String"
  value = aws_api_gateway_stage.gateway.invoke_url
}
