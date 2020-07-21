locals {
  all_domains = concat(["${var.name}.herokuapp.com"], var.domains)
}
