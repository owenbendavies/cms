output "dkim_tokens" {
  sensitive = true

  value = {
    for i in aws_ses_domain_dkim.app : i.domain => i.dkim_tokens
  }
}

output "mail_from_domains" {
  sensitive = true

  value = {
    for i in aws_ses_domain_mail_from.app : i.domain => i.mail_from_domain
  }
}

output "verification_tokens" {
  sensitive = true

  value = {
    for i in aws_ses_domain_identity.app : i.domain => i.verification_token
  }
}
