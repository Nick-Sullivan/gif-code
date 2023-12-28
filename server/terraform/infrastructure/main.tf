terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
  # Key is dynamic, provided by the makefile
  backend "s3" {
    bucket = "nicks-terraform-states"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
  default_tags {
    tags = local.tags
  }
}

locals {

  prefix           = "GifCode-${title(var.environment)}"
  prefix_lower     = "gif-code-${lower(var.environment)}"
  prefix_parameter = "/GifCode/${title(var.environment)}"
  aws_account_id   = data.aws_caller_identity.identity.account_id
  root_dir         = "${path.root}/../.."
  bruno_dir        = "${local.root_dir}/bruno"
  lambda_dir       = "${local.root_dir}/lambda"

  lambda_names = {
    "create_qr_gif" = "${local.prefix}-CreateQrGif"
  }

  tags = {
    Project     = "Gif Code"
    Environment = var.environment
  }
}
