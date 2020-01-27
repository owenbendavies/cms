variable "aws_region" {}
variable "heroku_domain" {}

variable "gsuite_domainkeys" {
  type = list
}

variable "gsuite_domains" {
  type = list
}

variable "mailchip_domains" {
  type = list
}

variable "root_domains" {
  type = list
}

variable "ses_dkim_tokens" {
  type = list
}

variable "ses_mail_from_domains" {
  type = list
}

variable "ses_verification_tokens" {
  type = list
}
