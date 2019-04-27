data "aws_caller_identity" "main" {}

data "aws_iam_policy_document" "logs" {
  statement {
    actions   = ["s3:GetBucketAcl"]
    resources = ["${aws_s3_bucket.logs.arn}"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/AWSLogs/${data.aws_caller_identity.main.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}
