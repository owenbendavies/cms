resource "aws_config_configuration_recorder" "global" {
  role_arn = "${aws_iam_role.main.arn}"

  recording_group {
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder" "region" {
  provider = "aws.eu-west-1"
  role_arn = "${aws_iam_role.main.arn}"
}

resource "aws_config_configuration_recorder_status" "gloabl" {
  name       = "${aws_config_configuration_recorder.global.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.global"]
}

resource "aws_config_configuration_recorder_status" "region" {
  name       = "${aws_config_configuration_recorder.region.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.region"]
}

resource "aws_config_delivery_channel" "global" {
  depends_on     = ["aws_config_configuration_recorder.global"]
  s3_bucket_name = "${aws_s3_bucket.main.id}"
}

resource "aws_config_delivery_channel" "region" {
  depends_on     = ["aws_config_configuration_recorder.region"]
  provider       = "aws.eu-west-1"
  s3_bucket_name = "${aws_s3_bucket.main.id}"
}

resource "aws_iam_role" "main" {
  assume_role_policy = "${data.aws_iam_policy_document.iam_role.json}"
  name               = "${var.app_name}-aws-config"
}

resource "aws_iam_role_policy_attachment" "main" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  role       = "${aws_iam_role.main.name}"
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.app_name}-aws-config"

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

resource "aws_s3_bucket_policy" "main" {
  bucket = "${aws_s3_bucket.main.id}"
  policy = "${data.aws_iam_policy_document.s3_bucket.json}"
}

resource "aws_s3_bucket_public_access_block" "main" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = "${aws_s3_bucket.main.id}"
  ignore_public_acls      = true
  restrict_public_buckets = true
}
