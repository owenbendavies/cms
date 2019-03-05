data "aws_iam_policy_document" "cognito" {
  statement {
    actions   = ["cognito-idp:ListUsersInGroup"]
    resources = ["${var.aws_cognito_arn}"]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${var.aws_s3_assets_bucket_arn}"]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
    ]

    resources = ["${var.aws_s3_assets_bucket_arn}/*"]
  }
}

data "aws_iam_policy_document" "ses" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}
