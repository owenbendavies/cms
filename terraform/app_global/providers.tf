provider "aws" {
  region  = "us-east-1"
  version = "1.57"
}

provider "aws" {
  alias   = "eu-west-1"
  region  = "eu-west-1"
  version = "1.57"
}

provider "heroku" {
  version = "1.7.4"
}
