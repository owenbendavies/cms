module "aws_cloudfront" {
  source = "./modules/aws_cloudfront"

  assets_domain = module.aws_s3.assets_domain
  logs_domain   = module.aws_s3.logs_domain
  name          = local.name
  tags          = local.tags
}

module "aws_cognito" {
  source = "./modules/aws_cognito"

  domains = local.domains
  name    = local.fq_name
  tags    = local.tags
}

module "aws_iam" {
  source = "./modules/aws_iam"

  aws_cognito_arn          = module.aws_cognito.arn
  aws_s3_assets_bucket_arn = module.aws_s3.assets_bucket_arn
  aws_sqs_arns             = [module.aws_sqs_default.arn, module.aws_sqs_mailers.arn]
  name                     = local.name
  tags                     = local.tags
}

module "aws_s3" {
  source = "./modules/aws_s3"

  aws_cloudfront_iam_arn = module.aws_cloudfront.iam_arn
  name                   = local.fq_name
  tags                   = local.tags
}

module "aws_sqs_default" {
  source = "./modules/aws_sqs"

  name = "${local.fq_name}-default"
  tags = local.tags
}

module "aws_sqs_mailers" {
  source = "./modules/aws_sqs"

  name = "${local.fq_name}-mailers"
  tags = local.tags
}

module "heroku" {
  source = "./modules/heroku"

  aws_access_key_id         = module.aws_iam.access_key_id
  aws_cloudfront_domain     = module.aws_cloudfront.domain
  aws_cognito_client_id     = module.aws_cognito.client_id
  aws_cognito_client_secret = module.aws_cognito.client_secret
  aws_cognito_domain        = module.aws_cognito.domain
  aws_cognito_id            = module.aws_cognito.id
  aws_region                = local.aws_region
  aws_s3_assets_bucket_name = module.aws_s3.assets_bucket_name
  aws_secret_access_key     = module.aws_iam.secret_access_key
  domains                   = local.domains
  from_email                = local.from_email
  name                      = local.fq_name
}
