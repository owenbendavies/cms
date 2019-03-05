locals {
  all_domains = [
    "${var.app_name}.herokuapp.com",
    "${var.domains}",
  ]
}
