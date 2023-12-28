

resource "aws_api_gateway_rest_api" "gateway" {
  name = local.prefix
}

resource "aws_api_gateway_deployment" "gateway" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  description = "Terraform deployment"

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode(local.all_integrations))
  }
}

resource "aws_api_gateway_stage" "gateway" {
  deployment_id = aws_api_gateway_deployment.gateway.id
  rest_api_id   = aws_api_gateway_rest_api.gateway.id
  stage_name    = "v1"
}

resource "aws_lambda_permission" "gateway" {
  depends_on    = [aws_api_gateway_deployment.gateway]
  for_each      = local.lambda_names
  function_name = each.value
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.gateway.execution_arn}/*"
}

// LOGGING

resource "aws_api_gateway_account" "gateway" {
  cloudwatch_role_arn = aws_iam_role.write_to_cloudwatch.arn
}

resource "aws_iam_role" "write_to_cloudwatch" {
  name               = "${local.prefix}-WriteToCloudWatch"
  description        = "Allows API Gateway to write to cloudwatch logs"
  assume_role_policy = data.aws_iam_policy_document.gateway_assume_role.json
}

data "aws_iam_policy_document" "gateway_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "gateway" {
  role       = aws_iam_role.write_to_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.gateway.id
  stage_name  = aws_api_gateway_stage.gateway.stage_name
  method_path = "*/*"
  settings {
    logging_level   = "ERROR"
    metrics_enabled = true
  }
}
