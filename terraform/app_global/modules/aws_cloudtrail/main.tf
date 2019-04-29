resource "aws_cloudtrail" "main" {
  enable_log_file_validation = true
  is_multi_region_trail      = true
  name                       = "${var.app_name}"
  s3_bucket_name             = "${var.aws_s3_logs_bucket_name}"
}
