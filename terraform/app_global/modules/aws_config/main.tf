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
  depends_on = ["aws_config_delivery_channel.region"]
  is_enabled = true
  name       = "${aws_config_configuration_recorder.region.name}"
  provider   = "aws.eu-west-1"
}

resource "aws_config_delivery_channel" "global" {
  depends_on     = ["aws_config_configuration_recorder.global"]
  s3_bucket_name = "${var.aws_s3_logs_bucket_name}"
}

resource "aws_config_delivery_channel" "region" {
  depends_on     = ["aws_config_configuration_recorder.region"]
  provider       = "aws.eu-west-1"
  s3_bucket_name = "${var.aws_s3_logs_bucket_name}"
}

resource "aws_iam_role" "main" {
  assume_role_policy = "${data.aws_iam_policy_document.iam_role.json}"
  name               = "${var.app_name}-aws-config"
}

resource "aws_iam_role_policy_attachment" "main" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
  role       = "${aws_iam_role.main.name}"
}
