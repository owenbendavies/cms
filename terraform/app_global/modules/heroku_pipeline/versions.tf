terraform {
  required_version = "= 0.13.6"
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "= 4.1.0"
    }
  }
}
