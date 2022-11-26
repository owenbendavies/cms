locals {
  aws_region = "eu-west-1"
  domains    = local.environment_domains[var.environment]
  name       = join("-", [var.namespace, local.project, var.environment])
  project    = "cms"

  environment_domains = {
    production : ["www.docklandssinfonia.co.uk", "www.spencerdown.com"],
  }
}
