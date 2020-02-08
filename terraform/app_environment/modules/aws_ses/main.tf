resource "aws_ses_domain_dkim" "app" {
  for_each = var.domains_settings

  domain = aws_ses_domain_identity.app[each.key].domain
}

resource "aws_ses_domain_identity" "app" {
  for_each = var.domains_settings

  domain = each.key
}

resource "aws_ses_domain_mail_from" "app" {
  for_each = var.domains_settings

  behavior_on_mx_failure = "RejectMessage"
  domain                 = aws_ses_domain_identity.app[each.key].domain
  mail_from_domain       = "email.${each.key}"
}
