resource "heroku_pipeline" "app" {
  name = var.name
}

resource "heroku_pipeline_coupling" "staging" {
  app      = "${var.name}-staging"
  pipeline = heroku_pipeline.app.id
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${var.name}-production"
  pipeline = heroku_pipeline.app.id
  stage    = "production"
}
