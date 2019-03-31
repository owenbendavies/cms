resource "google_monitoring_alert_policy" "main" {
  combiner              = "AND"
  count                 = "${length(var.domains)}"
  display_name          = "${var.domains[count.index]}"
  notification_channels = ["${google_monitoring_notification_channel.main.name}"]

  conditions {
    display_name = "${var.domains[count.index]}"
  }
}

resource "google_monitoring_notification_channel" "main" {
  display_name = "${var.notification_email}"
  type         = "email"

  labels = {
    email_address = "${var.notification_email}"
  }
}

resource "google_monitoring_uptime_check_config" "main" {
  count        = "${length(var.domains)}"
  display_name = "${var.domains[count.index]}"
  period       = "60s"
  timeout      = "10s"

  monitored_resource {
    type = "uptime_url"

    labels = {
      host = "${var.domains[count.index]}"
    }
  }

  http_check {
    path    = "/home"
    use_ssl = true
  }
}
