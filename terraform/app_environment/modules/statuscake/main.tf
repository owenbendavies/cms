resource "statuscake_test" "main" {
  contact_id   = 146896
  count        = length(var.domains)
  test_type    = "HTTP"
  timeout      = 10
  trigger_rate = 0
  website_name = var.domains[count.index]
  website_url  = "https://${var.domains[count.index]}/home?monitoring=skip"
}
