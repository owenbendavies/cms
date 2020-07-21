data "aws_iam_policy_document" "cognito" {
  statement {
    actions   = ["cognito-idp:ListUsersInGroup"]
    resources = [var.aws_cognito_arn]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [var.aws_s3_assets_bucket_arn]
  }

  statement {
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
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

data "aws_iam_policy_document" "sqs" {
  statement {
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
    ]

    resources = var.aws_sqs_arns
  }
}
