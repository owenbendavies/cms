locals {
  namespace   = "obduk"
  project     = "cms"
  environment = terraform.workspace
  app_name    = join("-", [local.namespace, local.project, local.environment])
  aws_region  = "eu-west-1"
  domains     = local.workspace_domains[terraform.workspace]
  from_email  = "noreply@obduk.com"

  tags = {
    project : local.project,
    environment : local.environment
  }

  workspace_domains = {
    production : ["www.docklandssinfonia.co.uk", "www.spencerdown.com"],
    staging : [],
  }
}
