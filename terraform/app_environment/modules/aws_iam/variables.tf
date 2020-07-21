variable "app_name" { type = string }
variable "aws_cognito_arn" { type = string }
variable "aws_s3_assets_bucket_arn" { type = string }
variable "aws_sqs_arns" { type = list(string) }
variable "tags" { type = map(string) }
