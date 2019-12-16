resource "cloudflare_page_rule" "root_redirect" {
  count  = length(var.root_domains)
  target = "${cloudflare_zone.main[count.index].zone}/*"
  zone   = cloudflare_zone.main[count.index].zone

  actions {
    forwarding_url {
      status_code = "301"
      url         = "https://www.${cloudflare_zone.main[count.index].zone}/$1"
    }
  }
}

resource "cloudflare_record" "dmarc" {
  count  = length(var.root_domains)
  domain = cloudflare_zone.main[count.index].zone
  name   = "_dmarc"
  type   = "TXT"
  value  = "v=DMARC1; p=reject"
}

resource "cloudflare_record" "gsuite_domainkey" {
  count  = length(var.gsuite_domains)
  domain = var.gsuite_domains[count.index]
  name   = "google._domainkey"
  type   = "TXT"
  value  = var.gsuite_domainkeys[count.index]
}

resource "cloudflare_record" "gsuite_mx" {
  count    = length(var.gsuite_domains) * length(local.gsuite_mx_values)
  domain   = var.gsuite_domains[floor(count.index / length(local.gsuite_mx_values))]
  name     = var.gsuite_domains[floor(count.index / length(local.gsuite_mx_values))]
  priority = element(local.gsuite_mx_priorities, count.index)
  type     = "MX"
  value    = element(local.gsuite_mx_values, count.index)
}

resource "cloudflare_record" "mailchimp_domainkey" {
  count  = length(var.mailchip_domains)
  domain = var.mailchip_domains[count.index]
  name   = "k1._domainkey"
  type   = "CNAME"
  value  = "dkim.mcsv.net"
}

resource "cloudflare_record" "ses_domainkey" {
  count  = length(var.root_domains) * 3
  domain = cloudflare_zone.main[floor(count.index / 3)].zone
  name   = "${element(var.ses_dkim_tokens[floor(count.index / 3)], count.index)}._domainkey"
  type   = "CNAME"
  value  = "${element(var.ses_dkim_tokens[floor(count.index / 3)], count.index)}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_mx" {
  count    = length(var.root_domains)
  domain   = cloudflare_zone.main[count.index].zone
  name     = var.ses_mail_from_domains[count.index]
  priority = 10
  type     = "MX"
  value    = "feedback-smtp.${var.aws_region}.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_spf" {
  count  = length(var.root_domains)
  domain = cloudflare_zone.main[count.index].zone
  name   = var.ses_mail_from_domains[count.index]
  type   = "TXT"
  value  = "v=spf1 include:amazonses.com -all"
}

resource "cloudflare_record" "ses_verification_token" {
  count  = length(var.root_domains)
  domain = cloudflare_zone.main[count.index].zone
  name   = "_amazonses"
  type   = "TXT"
  value  = var.ses_verification_tokens[count.index]
}

resource "cloudflare_record" "site_root" {
  count   = length(var.root_domains)
  domain  = cloudflare_zone.main[count.index].zone
  name    = cloudflare_zone.main[count.index].zone
  proxied = true
  type    = "CNAME"
  value   = var.heroku_domain
}

resource "cloudflare_record" "site_www" {
  count   = length(var.root_domains)
  domain  = cloudflare_zone.main[count.index].zone
  name    = "www"
  proxied = true
  type    = "CNAME"
  value   = var.heroku_domain
}

resource "cloudflare_record" "spf" {
  count  = length(var.root_domains)
  domain = cloudflare_zone.main[count.index].zone
  name   = cloudflare_zone.main[count.index].zone
  type   = "TXT"
  value  = "v=spf1 ${contains(var.gsuite_domains, cloudflare_zone.main[count.index].zone) ? "include:_spf.google.com " : ""}${contains(var.mailchip_domains, cloudflare_zone.main[count.index].zone) ? "include:servers.mcsv.net " : ""}-all"
}

resource "cloudflare_zone" "main" {
  count = length(var.root_domains)
  zone  = var.root_domains[count.index]
}

resource "cloudflare_zone_settings_override" "main" {
  count = length(var.root_domains)
  name  = cloudflare_zone.main[count.index].zone

  settings {
    always_use_https    = "on"
    cache_level         = "simplified"
    server_side_exclude = "off"
    ssl                 = "full"

    security_header {
      enabled            = true
      include_subdomains = true
      max_age            = 31536000
      nosniff            = true
      preload            = true
    }
  }
}
