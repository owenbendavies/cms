resource "heroku_pipeline" "app" {
  name = "${var.app_name}"
}

resource "heroku_pipeline_coupling" "staging" {
  app      = "${var.app_name}-staging"
  pipeline = "${heroku_pipeline.app.id}"
  stage    = "staging"
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${var.app_name}-production"
  pipeline = "${heroku_pipeline.app.id}"
  stage    = "production"
}
