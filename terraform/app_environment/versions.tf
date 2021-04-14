terraform {
  required_version = "= 0.14.10"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    heroku = {
      source = "heroku/heroku"
    }
  }
}
