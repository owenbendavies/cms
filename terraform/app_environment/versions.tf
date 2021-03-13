terraform {
  required_version = "= 0.13.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.32.0"
    }
    heroku = {
      source  = "heroku/heroku"
      version = "= 4.1.0"
    }
  }
}
