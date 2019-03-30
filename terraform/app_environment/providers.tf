provider "aws" {
  version = "1.57"
  region  = "eu-west-1"
}

provider "cloudflare" {
  version = "1.12"
}

provider "google" {
  version = "2.2"
}

provider "heroku" {
  version = "1.7.4"
}
