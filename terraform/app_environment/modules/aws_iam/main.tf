resource "aws_iam_access_key" "app" {
  user = aws_iam_user.app.name
}

resource "aws_iam_user" "app" {
  name = var.app_name
  tags = var.tags
}

resource "aws_iam_user_policy" "app_cognito" {
  name   = "cognito"
  policy = data.aws_iam_policy_document.cognito.json
  user   = aws_iam_user.app.name
}

resource "aws_iam_user_policy" "app_s3" {
  name   = "s3"
  policy = data.aws_iam_policy_document.s3.json
  user   = aws_iam_user.app.name
}

resource "aws_iam_user_policy" "app_ses" {
  name   = "ses"
  policy = data.aws_iam_policy_document.ses.json
  user   = aws_iam_user.app.name
}
