variable "aws_region" {}
variable "heroku_domain" {}

variable "domains_settings" {
  type = map
}

variable "ses_dkim_tokens" {
  type = map
}

variable "ses_mail_from_domains" {
  type = map
}

variable "ses_verification_tokens" {
  type = map
}
