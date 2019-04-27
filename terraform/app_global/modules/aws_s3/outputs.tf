output "logs_bucket_name" {
  sensitive = true
  value     = "${aws_s3_bucket.logs.id}"
}
