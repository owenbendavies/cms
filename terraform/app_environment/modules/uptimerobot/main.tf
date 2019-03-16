resource "uptimerobot_monitor" "app" {
  count         = "${length(var.domains)}"
  friendly_name = "${element(var.domains, count.index)}"
  type          = "http"
  url           = "${formatlist("https://%s", "${element(var.domains, count.index)}")}"
}
