locals {
  app_name    = "obduk-cms-${terraform.workspace}"
  aws_region  = "eu-west-1"
  from_email  = "noreply@obduk.com"
  workspace   = local.workspaces[terraform.workspace]
  www_domains = formatlist("www.%s", local.workspace["root_domains"])

  workspaces = {
    production = {
      gsuite_domainkeys = []
      gsuite_domains    = []
      mailchip_domains  = []
      root_domains      = []
    }

    staging = {
      gsuite_domainkeys = []
      gsuite_domains    = []
      mailchip_domains  = []
      root_domains      = []
    }
  }
}
