locals {
  aws_region = "eu-west-1"
  domains    = local.environment_domains[var.environment]
  fq_name    = join("-", [local.namespace, local.name])
  from_email = "noreply@obduk.com"
  name       = join("-", [local.project, var.environment])
  namespace  = "obduk"
  project    = "cms"

  tags = {
    project : local.project,
    environment : var.environment
  }

  environment_domains = {
    production : ["www.docklandssinfonia.co.uk", "www.spencerdown.com"],
    staging : [],
  }
}
