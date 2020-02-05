resource "datadog_synthetics_test" "main" {
  for_each = toset(var.domains)
  message  = "Notify @all"
  name     = each.key
  status   = "live"
  tags     = ["cms", "terraform"]
  type     = "api"

  assertions = [
    {
      operator = "is"
      target   = "200"
      type     = "statusCode"
    },
    {
      operator = "is"
      property = "content-type"
      type     = "header"
      target   = "text/html; charset=utf-8"
    },
    {
      operator = "lessThan"
      type     = "responseTime"
      target   = 6000
    }
  ]

  options = {
    min_failure_duration = 180,
    min_location_failed  = 2,
    tick_every           = 60,
  }

  request = {
    method  = "GET"
    timeout = 30
    url     = "https://${each.key}/home?monitoring=skip"
  }

  locations = [
    "aws:ca-central-1",
    "aws:eu-central-1",
    "aws:eu-west-1",
    "aws:eu-west-2",
    "aws:us-east-2",
    "aws:us-west-1",
    "aws:us-west-2"
  ]
}
