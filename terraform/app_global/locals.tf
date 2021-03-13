locals {
  name    = join("-", [var.namespace, local.project])
  project = "cms"
}
