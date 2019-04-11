resource "statuscake_test" "main" {
  contact_id   = 146896
  count        = "${length(var.domains)}"
  test_type    = "HTTP"
  website_name = "${var.domains[count.index]}"
  website_url  = "https://${var.domains[count.index]}/home?monitoring=skip"
}
