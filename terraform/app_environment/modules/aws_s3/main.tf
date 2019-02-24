resource "aws_s3_bucket" "assets" {
  bucket = "${var.app_name}"
  region = "${var.aws_region}"

  lifecycle = {
    prevent_destroy = true
  }

  lifecycle_rule = {
    abort_incomplete_multipart_upload_days = 1
    enabled                                = true
    id                                     = "delete-old-versions"

    noncurrent_version_expiration = {
      days = 30
    }
  }

  logging = {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "AWSLogs/${var.aws_account_id}/s3/${var.app_name}/"
  }

  server_side_encryption_configuration = {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "${aws_s3_bucket.assets.id}"
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "assets" {
  statement = {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.aws_cloudfront_iam_arn}"]
    }

    resources = [
      "${aws_s3_bucket.assets.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = "${aws_s3_bucket.assets.id}"
  policy = "${data.aws_iam_policy_document.assets.json}"
}

resource "aws_s3_bucket" "logs" {
  acl    = "log-delivery-write"
  bucket = "${var.app_name}-logs"
  region = "${var.aws_region}"

  lifecycle = {
    prevent_destroy = true
  }

  lifecycle_rule = {
    abort_incomplete_multipart_upload_days = 1
    enabled                                = true
    id                                     = "delete-old-files-and-versions"

    expiration = {
      days = 30
    }

    noncurrent_version_expiration = {
      days = 30
    }
  }

  server_side_encryption_configuration = {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "${aws_s3_bucket.logs.id}"
  ignore_public_acls      = true
  restrict_public_buckets = true
}
