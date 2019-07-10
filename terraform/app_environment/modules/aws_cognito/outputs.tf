output "arn" {
  sensitive = true
  value     = aws_cognito_user_pool.app.arn
}

output "client_id" {
  sensitive = true
  value     = aws_cognito_user_pool_client.app.id
}

output "client_secret" {
  sensitive = true
  value     = aws_cognito_user_pool_client.app.client_secret
}

output "domain" {
  sensitive = true
  value     = aws_cognito_user_pool_domain.app.domain
}

output "id" {
  sensitive = true
  value     = aws_cognito_user_pool.app.id
}
