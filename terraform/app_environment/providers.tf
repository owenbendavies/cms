provider "aws" {
  region  = "eu-west-1"
  version = "2.17.0"
}

provider "cloudflare" {
  version = "1.14.0"
}

provider "heroku" {
  version = "1.9.0"
}

provider "statuscake" {
  version = "0.2"
}
