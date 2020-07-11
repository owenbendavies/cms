module "heroku_pipeline" {
  source = "./modules/heroku_pipeline"

  app_name = local.app_name
}
