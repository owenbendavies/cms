resource "datadog_synthetics_test" "main" {
  count   = "${length(var.domains)}"
  message = "Notify @all"
  name    = "${var.domains[count.index]}"
  status  = "live"
  tags    = []
  type    = "api"

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
      target   = 3000
    }
  ]

  options = {
    min_failure_duration = 0,
    min_location_failed  = 1,
    tick_every           = 60,
  }

  request = {
    method  = "GET"
    timeout = 10
    url     = "https://${var.domains[count.index]}/home?monitoring=skip"
  }

  locations = [
    "aws:ap-northeast-1",
    "aws:ap-southeast-2",
    "aws:ca-central-1",
    "aws:eu-central-1",
    "aws:eu-west-2",
    "aws:us-east-2",
    "aws:us-west-2"
  ]
}
