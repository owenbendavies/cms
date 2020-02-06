locals {
  app_name         = "obduk-cms-${terraform.workspace}"
  aws_region       = "eu-west-1"
  domains_settings = local.workspace_domains_settings[terraform.workspace]
  from_email       = "noreply@obduk.com"
  www_domains      = formatlist("www.%s", keys(local.domains_settings))

  workspace_domains_settings = {
    production : {
      "docklandssinfonia.co.uk" : {
        gsuite_domain_key : "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyV3nvb2VsVawzCX/CEHLzm5ehMv37oKJa9OxSD+/Gii1MnzHkiNeRhXSAGviLmX3XndSDoAYoMTuAYCEhOm15ibO4ZW+iGcevuHAaSvEmlYAGUQwqvuUe78V5q8DzpGJ7oCscMSyTs5z73YVMUH33R+uK5d1Vv+lM0OkTGOLGlQIDAQAB",
      },
      "spencerdown.com" : {
        gsuite_domain_key : "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6f+YQCiuUPGgLcr0wAt91SLfZTPmqz7lBkr1aLEAQQ/5IAbq8LfauU+brIhmSVvdnvV581GkDFFUddnkMaEAhIFhDU553gCc0b+agjofv73I/liG9VpxIscsXc2PtlsH14e2byzJLREr8lE9YfyzuSjlrOqoIptzWQ+bokf1wLQIDAQAB",
      },
    },

    staging : {},
  }
}
