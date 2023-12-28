

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "upload_to_s3" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]
    effect    = "Allow"
    resources = ["${data.aws_ssm_parameter.s3_bucket_arn.value}/*"]
  }
}

data "aws_iam_policy_document" "read_s3" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    effect    = "Allow"
    resources = ["${data.aws_ssm_parameter.s3_bucket_arn.value}/*"]
  }
}