locals {
  app_name    = "${var.org_name}-cms-${terraform.workspace}"
  aws_region  = "eu-west-1"
  www_domains = "${formatlist("www.%s", "${var.root_domains}")}"
}
