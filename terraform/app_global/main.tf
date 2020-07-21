module "heroku_pipeline" {
  source = "./modules/heroku_pipeline"

  name = local.name
}
