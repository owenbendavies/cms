resource "cloudflare_page_rule" "root_redirect" {
  for_each = var.domains_settings

  target = "${each.key}/*"
  zone   = cloudflare_zone.main[each.key].zone

  actions {
    forwarding_url {
      status_code = "301"
      url         = "https://www.${each.key}/$1"
    }
  }
}

resource "cloudflare_record" "dmarc" {
  for_each = var.domains_settings

  domain = cloudflare_zone.main[each.key].zone
  name   = "_dmarc"
  type   = "TXT"
  value  = "v=DMARC1; p=reject"
}

resource "cloudflare_record" "gsuite_domainkey" {
  for_each = var.domains_settings

  domain = cloudflare_zone.main[each.key].zone
  name   = "google._domainkey"
  type   = "TXT"
  value  = each.value["gsuite_domain_key"]
}

resource "cloudflare_record" "gsuite_mx_0" {
  for_each = var.domains_settings

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.key
  priority = 1
  type     = "MX"
  value    = "aspmx.l.google.com"
}

resource "cloudflare_record" "gsuite_mx_1" {
  for_each = var.domains_settings

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.key
  priority = 2
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
}

resource "cloudflare_record" "gsuite_mx_2" {
  for_each = var.domains_settings

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.key
  priority = 2
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
}

resource "cloudflare_record" "gsuite_mx_3" {
  for_each = var.domains_settings

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.key
  priority = 3
  type     = "MX"
  value    = "alt3.aspmx.l.google.com"
}

resource "cloudflare_record" "gsuite_mx_4" {
  for_each = var.domains_settings

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.key
  priority = 3
  type     = "MX"
  value    = "alt4.aspmx.l.google.com"
}

resource "cloudflare_record" "mailchimp_domainkey" {
  for_each = var.domains_settings

  domain = cloudflare_zone.main[each.key].zone
  name   = "k1._domainkey"
  type   = "CNAME"
  value  = "dkim.mcsv.net"
}

resource "cloudflare_record" "ses_domainkey_0" {
  for_each = var.ses_dkim_tokens

  domain = cloudflare_zone.main[each.key].zone
  name   = "${each.value[0]}._domainkey"
  type   = "CNAME"
  value  = "${each.value[0]}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_domainkey_1" {
  for_each = var.ses_dkim_tokens

  domain = cloudflare_zone.main[each.key].zone
  name   = "${each.value[1]}._domainkey"
  type   = "CNAME"
  value  = "${each.value[1]}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_domainkey_2" {
  for_each = var.ses_dkim_tokens

  domain = cloudflare_zone.main[each.key].zone
  name   = "${each.value[2]}._domainkey"
  type   = "CNAME"
  value  = "${each.value[2]}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_mx" {
  for_each = var.ses_mail_from_domains

  domain   = cloudflare_zone.main[each.key].zone
  name     = each.value
  priority = 10
  type     = "MX"
  value    = "feedback-smtp.${var.aws_region}.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_spf" {
  for_each = var.ses_mail_from_domains

  domain = cloudflare_zone.main[each.key].zone
  name   = each.value
  type   = "TXT"
  value  = "v=spf1 include:amazonses.com -all"
}

resource "cloudflare_record" "ses_verification_token" {
  for_each = var.ses_verification_tokens

  domain = cloudflare_zone.main[each.key].zone
  name   = "_amazonses"
  type   = "TXT"
  value  = each.value
}

resource "cloudflare_record" "site_root" {
  for_each = var.domains_settings

  domain  = cloudflare_zone.main[each.key].zone
  name    = each.key
  proxied = true
  type    = "CNAME"
  value   = var.heroku_domain
}

resource "cloudflare_record" "site_www" {
  for_each = var.domains_settings

  domain  = cloudflare_zone.main[each.key].zone
  name    = "www"
  proxied = true
  type    = "CNAME"
  value   = var.heroku_domain
}

resource "cloudflare_record" "spf" {
  for_each = var.domains_settings

  domain = cloudflare_zone.main[each.key].zone
  name   = each.key
  type   = "TXT"
  value  = "v=spf1 include:_spf.google.com include:servers.mcsv.net -all"
}

resource "cloudflare_zone" "main" {
  for_each = var.domains_settings

  zone = each.key
}

resource "cloudflare_zone_settings_override" "main" {
  for_each = var.domains_settings

  name = cloudflare_zone.main[each.key].zone

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
