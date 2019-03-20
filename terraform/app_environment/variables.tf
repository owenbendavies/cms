variable "aws_account_id" {}
variable "dmarc_record" {}

variable "from_email" {}
variable "org_name" {}

variable "gsuite_domainkeys" {
  type = "list"
}

variable "gsuite_domains" {
  type = "list"
}

variable "mailchip_domains" {
  type = "list"
}

variable "root_domains" {
  default = []
  type    = "list"
}
