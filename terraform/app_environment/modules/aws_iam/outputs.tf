output "access_key_id" {
  sensitive = true
  value     = aws_iam_access_key.app.id
}

output "secret_access_key" {
  sensitive = true
  value     = aws_iam_access_key.app.secret
}
