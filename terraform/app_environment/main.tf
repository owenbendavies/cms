terraform {
  backend "s3" {
    bucket               = "obduk-cms-terraform-states"
    dynamodb_table       = "obduk-cms-terraform-locks"
    key                  = "app_environment.tfstate"
    region               = "eu-west-1"
    workspace_key_prefix = "workspaces"
  }
}

provider "aws" {
  version = "1.57"
  region  = "${local.aws_region}"
}

provider "heroku" {
  version = "1.7.4"
}

module "aws_cloudfront" {
  source = "./modules/aws_cloudfront"

  app_name                    = "${local.app_name}"
  aws_account_id              = "${var.aws_account_id}"
  aws_s3_assets_bucket_domain = "${module.aws_s3.assets_bucket_domain}"
  aws_s3_logs_bucket_domain   = "${module.aws_s3.logs_bucket_domain}"
}

module "aws_cognito" {
  source = "./modules/aws_cognito"

  app_name = "${local.app_name}"
}

module "aws_iam" {
  source = "./modules/aws_iam"

  app_name                 = "${local.app_name}"
  aws_cognito_arn          = "${module.aws_cognito.arn}"
  aws_s3_assets_bucket_arn = "${module.aws_s3.assets_bucket_arn}"
}

module "aws_s3" {
  source = "./modules/aws_s3"

  app_name               = "${local.app_name}"
  aws_account_id         = "${var.aws_account_id}"
  aws_cloudfront_iam_arn = "${module.aws_cloudfront.iam_arn}"
}

module "heroku" {
  source = "./modules/heroku"

  app_name                   = "${local.app_name}"
  aws_access_key_id          = "${module.aws_iam.access_key_id}"
  aws_cloudfront_domain_name = "${module.aws_cloudfront.domain_name}"
  aws_cognito_client_id      = "${module.aws_cognito.client_id}"
  aws_cognito_client_secret  = "${module.aws_cognito.client_secret}"
  aws_cognito_domain         = "${module.aws_cognito.domain}"
  aws_cognito_id             = "${module.aws_cognito.id}"
  aws_region                 = "${local.aws_region}"
  aws_s3_assets_bucket_name  = "${module.aws_s3.assets_bucket_name}"
  aws_secret_access_key      = "${module.aws_iam.secret_access_key}"
  email                      = "${var.email}"
}
