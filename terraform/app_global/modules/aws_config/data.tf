data "aws_caller_identity" "main" {}

data "aws_iam_policy_document" "iam_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["config.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_bucket" {
  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.main.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.main.arn}/AWSLogs/${data.aws_caller_identity.main.account_id}/*"]

    principals {
      type        = "AWS"
      identifiers = ["config.amazonaws.com"]
    }
  }
}
