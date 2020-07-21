output "arn" {
  sensitive = true
  value     = aws_sqs_queue.main.arn
}
