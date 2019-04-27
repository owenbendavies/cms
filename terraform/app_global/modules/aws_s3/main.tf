resource "aws_s3_bucket" "logs" {
  bucket = "${var.app_name}-logs"

  lifecycle {
    prevent_destroy = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = "${aws_s3_bucket.logs.id}"
  policy = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_s3_bucket_public_access_block" "logs" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "${aws_s3_bucket.logs.id}"
  ignore_public_acls      = true
  restrict_public_buckets = true
}
