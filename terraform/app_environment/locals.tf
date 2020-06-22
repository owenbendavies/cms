locals {
  app_name   = "obduk-cms-${terraform.workspace}"
  aws_region = "eu-west-1"
  domains    = local.workspace_domains[terraform.workspace]
  from_email = "noreply@obduk.com"

  workspace_domains = {
    production : ["www.docklandssinfonia.co.uk", "www.spencerdown.com"],
    staging : [],
  }
}
