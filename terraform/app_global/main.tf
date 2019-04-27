terraform {
  backend "s3" {
    bucket               = "obduk-cms-terraform-states"
    dynamodb_table       = "obduk-cms-terraform-locks"
    key                  = "app_global.tfstate"
    region               = "eu-west-1"
    workspace_key_prefix = "workspaces"
  }
}

module "aws_config" {
  source = "./modules/aws_config"

  app_name                = "${local.app_name}"
  aws_s3_logs_bucket_name = "${module.aws_s3.logs_bucket_name}"
}

module "aws_s3" {
  source = "./modules/aws_s3"

  app_name = "${local.app_name}"
}

module "heroku_pipeline" {
  source = "./modules/heroku_pipeline"

  app_name = "${local.app_name}"
}
