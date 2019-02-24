resource "aws_cognito_user_pool" "app" {
  auto_verified_attributes = ["email"]
  name                     = "${var.app_name}"
  username_attributes      = ["email"]

  admin_create_user_config = {
    allow_admin_create_user_only = true
  }

  lifecycle = {
    prevent_destroy = true
  }

  schema = {
    attribute_data_type = "String"
    mutable             = true
    name                = "name"
    required            = true

    string_attribute_constraints = {
      min_length = 0
      max_length = 2048
    }
  }
}

resource "aws_cognito_user_pool_client" "app" {
  generate_secret = true
  name            = "${var.app_name}"
  user_pool_id    = "${aws_cognito_user_pool.app.id}"
}

resource "aws_cognito_user_pool_domain" "app" {
  domain       = "${var.app_name}"
  user_pool_id = "${aws_cognito_user_pool.app.id}"
}
