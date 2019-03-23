resource "cloudflare_page_rule" "root_redirect" {
  count  = "${length(var.root_domains)}"
  target = "${element(var.root_domains, count.index)}/*"
  zone   = "${element(var.root_domains, count.index)}"

  actions = {
    forwarding_url = {
      status_code = "301"
      url         = "https://www.${element(var.root_domains, count.index)}/$1"
    }
  }
}

resource "cloudflare_record" "dmarc" {
  count  = "${length(var.root_domains)}"
  domain = "${element(var.root_domains, count.index)}"
  name   = "_dmarc"
  type   = "TXT"
  value  = "${var.dmarc_record}"
}

resource "cloudflare_record" "gsuite_domainkey" {
  count  = "${length(var.gsuite_domains)}"
  domain = "${var.gsuite_domains[count.index]}"
  name   = "google._domainkey"
  type   = "TXT"
  value  = "${var.gsuite_domainkeys[count.index]}"
}

resource "cloudflare_record" "gsuite_mx" {
  count    = "${length(var.gsuite_domains) * length(local.gsuite_mx_values)}"
  domain   = "${var.gsuite_domains[count.index / length(local.gsuite_mx_values)]}"
  name     = "${var.gsuite_domains[count.index / length(local.gsuite_mx_values)]}"
  priority = "${element(local.gsuite_mx_priorities, count.index)}"
  type     = "MX"
  value    = "${element(local.gsuite_mx_values, count.index)}"
}

resource "cloudflare_record" "mailchimp_domainkey" {
  count  = "${length(var.mailchip_domains)}"
  domain = "${var.mailchip_domains[count.index]}"
  name   = "k1._domainkey"
  type   = "CNAME"
  value  = "dkim.mcsv.net"
}

resource "cloudflare_record" "ses_domainkey" {
  count  = "${length(var.root_domains) * 3}"
  domain = "${var.root_domains[count.index / 3]}"
  name   = "${element(var.ses_dkim_tokens[count.index / 3], count.index)}._domainkey"
  type   = "CNAME"
  value  = "${element(var.ses_dkim_tokens[count.index / 3], count.index)}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_mx" {
  count    = "${length(var.root_domains)}"
  domain   = "${element(var.root_domains, count.index)}"
  name     = "${element(var.ses_mail_from_domains, count.index)}"
  priority = 10
  type     = "MX"
  value    = "feedback-smtp.${var.aws_region}.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_spf" {
  count  = "${length(var.root_domains)}"
  domain = "${element(var.root_domains, count.index)}"
  name   = "${element(var.ses_mail_from_domains, count.index)}"
  type   = "TXT"
  value  = "v=spf1 include:amazonses.com ~all"
}

resource "cloudflare_record" "ses_verification_token" {
  count  = "${length(var.root_domains)}"
  domain = "${element(var.root_domains, count.index)}"
  name   = "_amazonses"
  type   = "TXT"
  value  = "${element(var.ses_verification_tokens, count.index)}"
}

resource "cloudflare_record" "site_root" {
  count   = "${length(var.root_domains)}"
  domain  = "${element(var.root_domains, count.index)}"
  name    = "${element(var.root_domains, count.index)}"
  proxied = true
  type    = "CNAME"
  value   = "${var.heroku_domain}"
}

resource "cloudflare_record" "site_www" {
  count   = "${length(var.root_domains)}"
  domain  = "${element(var.root_domains, count.index)}"
  name    = "www"
  proxied = true
  type    = "CNAME"
  value   = "${var.heroku_domain}"
}

resource "cloudflare_record" "spf" {
  count  = "${length(var.root_domains)}"
  domain = "${element(var.root_domains, count.index)}"
  name   = "${element(var.root_domains, count.index)}"
  type   = "TXT"
  value  = "v=spf1 ${contains(var.gsuite_domains, element(var.root_domains, count.index)) ? "include:_spf.google.com ": ""}${contains(var.mailchip_domains, element(var.root_domains, count.index)) ? "include:servers.mcsv.net ": ""}~all"
}

resource "cloudflare_zone_settings_override" "main" {
  count = "${length(var.root_domains)}"
  name  = "${element(var.root_domains, count.index)}"

  settings = {
    always_use_https = true
    ssl              = "full"
  }
}
