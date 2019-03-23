resource "aws_ses_domain_dkim" "app" {
  count  = "${length(var.domains)}"
  domain = "${aws_ses_domain_identity.app.*.domain[count.index]}"

  lifecycle = {
    prevent_destroy = true
  }
}

resource "aws_ses_domain_identity" "app" {
  count  = "${length(var.domains)}"
  domain = "${var.domains[count.index]}"

  lifecycle = {
    prevent_destroy = true
  }
}

resource "aws_ses_domain_mail_from" "app" {
  behavior_on_mx_failure = "RejectMessage"
  count                  = "${length(var.domains)}"
  domain                 = "${aws_ses_domain_identity.app.*.domain[count.index]}"
  mail_from_domain       = "email.${aws_ses_domain_identity.app.*.domain[count.index]}"

  lifecycle = {
    prevent_destroy = true
  }
}
