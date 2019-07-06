data "aws_iam_policy_document" "app" {
  count = "${length(var.domains)}"

  statement {
    actions   = ["ses:SendEmail", "ses:SendRawEmail"]
    resources = ["${aws_ses_domain_identity.app.*.arn[count.index]}"]

    principals {
      identifiers = ["${var.aws_iam_user_arn}"]
      type        = "AWS"
    }
  }
}
