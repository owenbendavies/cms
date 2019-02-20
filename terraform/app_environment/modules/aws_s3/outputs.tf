output "assets_bucket_arn" {
  sensitive = true
  value     = "${aws_s3_bucket.assets.arn}"
}

output "assets_bucket_domain" {
  sensitive = true
  value     = "${aws_s3_bucket.assets.bucket_domain_name}"
}

output "assets_bucket_name" {
  sensitive = true
  value     = "${aws_s3_bucket.assets.id}"
}

output "logs_bucket_domain" {
  sensitive = true
  value     = "${aws_s3_bucket.logs.bucket_domain_name}"
}
