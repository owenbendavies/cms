locals {
  all_domains = concat(["${var.app_name}.herokuapp.com"], var.www_domains)
}
