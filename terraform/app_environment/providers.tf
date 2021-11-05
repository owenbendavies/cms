provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      project : local.project,
      environment : var.environment
    }
  }
}
