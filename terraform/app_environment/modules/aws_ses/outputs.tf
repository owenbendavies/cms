output "dkim_tokens" {
  sensitive = true
  value     = "${aws_ses_domain_dkim.app.*.dkim_tokens}"
}

output "mail_from_domains" {
  sensitive = true
  value     = "${aws_ses_domain_mail_from.app.*.mail_from_domain}"
}

output "verification_tokens" {
  sensitive = true
  value     = "${aws_ses_domain_identity.app.*.verification_token}"
}
