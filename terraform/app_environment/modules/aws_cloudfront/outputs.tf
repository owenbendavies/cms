output "domain" {
  sensitive = true
  value     = "${aws_cloudfront_distribution.assets.domain_name}"
}

output "iam_arn" {
  sensitive = true
  value     = "${aws_cloudfront_origin_access_identity.assets.iam_arn}"
}
