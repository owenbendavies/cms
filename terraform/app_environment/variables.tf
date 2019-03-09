variable "aws_account_id" {}
variable "email" {}
variable "org_name" {}

variable "root_domains" {
  default = []
  type    = "list"
}
