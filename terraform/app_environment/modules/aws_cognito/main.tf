resource "aws_cognito_user_group" "admin" {
  name         = "admin"
  user_pool_id = aws_cognito_user_pool.app.id
}

resource "aws_cognito_user_group" "domains" {
  for_each = toset(local.all_domains)

  name         = each.key
  user_pool_id = aws_cognito_user_pool.app.id
}

resource "aws_cognito_user_pool" "app" {
  auto_verified_attributes = ["email"]
  name                     = var.app_name
  username_attributes      = ["email"]

  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  lifecycle {
    prevent_destroy = true
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "name"
    required            = true

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }
}

resource "aws_cognito_user_pool_client" "app" {
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["openid"]
  callback_urls                        = formatlist("https://%s/auth/cognito-idp/callback", local.all_domains)
  generate_secret                      = true
  logout_urls                          = formatlist("https://%s/", local.all_domains)
  name                                 = var.app_name
  supported_identity_providers         = ["COGNITO"]
  user_pool_id                         = aws_cognito_user_pool.app.id
}

resource "aws_cognito_user_pool_domain" "app" {
  domain       = var.app_name
  user_pool_id = aws_cognito_user_pool.app.id
}
