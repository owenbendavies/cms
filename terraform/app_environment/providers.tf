provider "aws" {
  version = "1.57"
  region  = "eu-west-1"
}

provider "cloudflare" {
  version = "1.12"
}

provider "heroku" {
  version = "1.7.4"
}

provider "statuscake" {
  version = "0.2"
}
