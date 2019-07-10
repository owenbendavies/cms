locals {
  all_domains = concat(["${var.app_name}.herokuapp.com"], var.domains)
}
