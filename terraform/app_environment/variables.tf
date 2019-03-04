variable "aws_account_id" {}
variable "email" {}
variable "org_name" {}

variable "domains" {
  default = []
  type    = "list"
}
