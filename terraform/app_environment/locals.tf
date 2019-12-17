locals {
  app_name    = "obduk-cms-${terraform.workspace}"
  aws_region  = "eu-west-1"
  from_email  = "noreply@obduk.com"
  workspace   = local.workspaces[terraform.workspace]
  www_domains = formatlist("www.%s", local.workspace["root_domains"])

  workspaces = {
    production = {
      gsuite_domainkeys = [
        "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyV3nvb2VsVawzCX/CEHLzm5ehMv37oKJa9OxSD+/Gii1MnzHkiNeRhXSAGviLmX3XndSDoAYoMTuAYCEhOm15ibO4ZW+iGcevuHAaSvEmlYAGUQwqvuUe78V5q8DzpGJ7oCscMSyTs5z73YVMUH33R+uK5d1Vv+lM0OkTGOLGlQIDAQAB",
        "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6f+YQCiuUPGgLcr0wAt91SLfZTPmqz7lBkr1aLEAQQ/5IAbq8LfauU+brIhmSVvdnvV581GkDFFUddnkMaEAhIFhDU553gCc0b+agjofv73I/liG9VpxIscsXc2PtlsH14e2byzJLREr8lE9YfyzuSjlrOqoIptzWQ+bokf1wLQIDAQAB",
      ]

      gsuite_domains = [
        "docklandssinfonia.co.uk",
        "spencerdown.com",
      ]

      mailchip_domains = [
        "docklandssinfonia.co.uk",
      ]

      root_domains = [
        "docklandssinfonia.co.uk",
        "spencerdown.com",
      ]
    }

    staging = {
      gsuite_domainkeys = []
      gsuite_domains    = []
      mailchip_domains  = []
      root_domains      = []
    }
  }
}
