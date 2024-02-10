
data "archive_file" "layer" {
  type        = "zip"
  source_dir  = "${local.lambda_dir}/layer"
  excludes    = ["__pycache__.py"]
  output_path = "${local.lambda_dir}/zip/layer.zip"
}

data "archive_file" "handler" {
  type        = "zip"
  source_dir  = "${local.lambda_dir}/handler"
  excludes    = ["__pycache__.py"]
  output_path = "${local.lambda_dir}/zip/handler.zip"
}

data "archive_file" "libs" {
  type        = "zip"
  source_dir  = "${local.lambda_dir}/libs"
  excludes    = ["__pycache__.py"]
  output_path = "${local.lambda_dir}/zip/libs.zip"
}

resource "aws_lambda_layer_version" "libs" {
  filename            = data.archive_file.libs.output_path
  layer_name          = "${local.prefix}-Libs"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = data.archive_file.libs.output_base64sha256
}

resource "aws_lambda_layer_version" "layer" {
  filename            = "${local.lambda_dir}/zip/layer.zip"
  layer_name          = "${local.prefix}-Layer"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = data.archive_file.layer.output_base64sha256
}

resource "aws_cloudwatch_log_group" "all" {
  for_each          = local.lambda_names
  name              = "/aws/lambda/${each.value}"
  retention_in_days = 90
}

resource "aws_lambda_function" "create_qr_gif" {
  filename      = data.archive_file.handler.output_path
  function_name = local.lambda_names["create_qr_gif"]
  handler       = "create_qr_gif.create_qr_gif"
  layers = [
    aws_lambda_layer_version.layer.arn,
    aws_lambda_layer_version.libs.arn,
    "arn:aws:lambda:ap-southeast-2:770693421928:layer:Klayers-p311-Pillow:3",
  ]
  role             = aws_iam_role.create_qr_gif.arn
  runtime          = "python3.11"
  timeout          = 30
  source_code_hash = data.archive_file.handler.output_base64sha256
  depends_on       = [aws_cloudwatch_log_group.all]
  # 512MB: timeout at 30s
  # 1024MB: 15s
  # 2048MB: 9.3s
  # 4096MB: 9.2s
  memory_size = 2048
  environment {
    variables = {
      "ENVIRONMENT" : var.environment,
      "GIPHY_API_KEY": data.aws_ssm_parameter.giphy_api_key.value,
      "S3_BUCKET_NAME": data.aws_ssm_parameter.s3_bucket_name.value
    }
  }
}

resource "aws_iam_role" "create_qr_gif" {
  name                = local.lambda_names["create_qr_gif"]
  description         = "Allows Lambda to create QR GIF"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
  inline_policy {
    name   = "S3WriteAccess"
    policy = data.aws_iam_policy_document.upload_to_s3.json
  }
  inline_policy {
    name   = "S3ReadAccess"
    policy = data.aws_iam_policy_document.read_s3.json
  }
}

resource "aws_lambda_function_event_invoke_config" "create_qr_gif" {
  function_name                = aws_lambda_function.create_qr_gif.function_name
  maximum_retry_attempts       = 0
}
