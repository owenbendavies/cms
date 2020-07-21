resource "aws_sqs_queue" "main" {
  name = var.name
  tags = var.tags
}
