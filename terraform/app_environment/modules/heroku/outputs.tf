output "domain" {
  sensitive = true
  value     = heroku_app.app.heroku_hostname
}
