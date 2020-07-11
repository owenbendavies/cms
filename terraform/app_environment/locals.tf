locals {
  namespace  = "obduk"
  project    = "cms"
  app_name   = join("-", [local.namespace, local.project, var.environment])
  aws_region = "eu-west-1"
  domains    = local.environment_domains[var.environment]
  from_email = "noreply@obduk.com"

  tags = {
    project : local.project,
    environment : var.environment
  }

  environment_domains = {
    production : ["www.docklandssinfonia.co.uk", "www.spencerdown.com"],
    staging : [],
  }
}
