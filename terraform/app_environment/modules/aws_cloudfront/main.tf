resource "aws_cloudfront_distribution" "assets" {
  comment         = var.name
  enabled         = true
  is_ipv6_enabled = true
  tags            = var.tags

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "S3"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  logging_config {
    bucket = var.logs_domain
    prefix = "AWSLogs/${data.aws_caller_identity.main.account_id}/cloudfront/${var.name}/"
  }

  origin {
    domain_name = var.assets_domain
    origin_id   = "S3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.assets.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "assets" {
  comment = var.name
}
