

resource "aws_cognito_user_pool" "users" {
  name                     = local.prefix
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }
  password_policy {
    minimum_length                   = 6
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }
  schema {
    name                     = "email"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      min_length = 5
      max_length = 2048
    }
  }
  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
  }
}

resource "aws_cognito_user_pool_domain" "users" {
  domain       = lower(local.prefix)
  user_pool_id = aws_cognito_user_pool.users.id
}

resource "aws_cognito_user_pool_client" "users" {
  name                         = local.prefix
  user_pool_id                 = aws_cognito_user_pool.users.id
  callback_urls                = ["http://localhost:5500/website/"] # TODO what does this do
  allowed_oauth_flows          = ["implicit"]
  supported_identity_providers = ["COGNITO"]
  id_token_validity            = 24 # hours
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  generate_secret = false
}

resource "random_password" "automated_tester_password" {
  length  = 16
  special = false
}

resource "aws_cognito_user" "automated_tester" {
  user_pool_id   = aws_cognito_user_pool.users.id
  username       = local.automated_tester_username
  password       = random_password.automated_tester_password.result
  message_action = "SUPPRESS"
  attributes = {
    email          = local.automated_tester_username
    email_verified = true
  }
}

