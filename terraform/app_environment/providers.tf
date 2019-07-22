provider "aws" {
  region  = "eu-west-1"
  version = "2.18.0"
}

provider "cloudflare" {
  version = "1.16.1"
}

provider "datadog" {
  version = "2.0.2"
}

provider "heroku" {
  version = "2.0.1"
}
