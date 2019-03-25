data "aws_caller_identity" "main" {}

data "aws_iam_policy_document" "assets" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.assets.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${var.aws_cloudfront_iam_arn}"]
    }
  }
}
