variable "app_name" {}
variable "aws_access_key_id" {}
variable "aws_cloudfront_domain" {}
variable "aws_cognito_client_id" {}
variable "aws_cognito_client_secret" {}
variable "aws_cognito_domain" {}
variable "aws_cognito_id" {}
variable "aws_region" {}
variable "aws_s3_assets_bucket_name" {}
variable "aws_secret_access_key" {}
variable "from_email" {}

variable "domains" {
  type = list
}
