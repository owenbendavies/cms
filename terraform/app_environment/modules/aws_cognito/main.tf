resource "aws_cognito_user_pool" "app" {
  auto_verified_attributes = ["email"]
  name                     = "${var.app_name}"
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
  generate_secret                      = true
  name                                 = "${var.app_name}"
  supported_identity_providers         = ["COGNITO"]
  user_pool_id                         = "${aws_cognito_user_pool.app.id}"

  callback_urls = [
    "https://${var.app_name}.herokuapp.com/auth/cognito-idp/callback",
  ]

  logout_urls = [
    "https://${var.app_name}.herokuapp.com/",
  ]
}

resource "aws_cognito_user_pool_domain" "app" {
  domain       = "${var.app_name}"
  user_pool_id = "${aws_cognito_user_pool.app.id}"
}
