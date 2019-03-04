resource "aws_iam_user" "app" {
  name = "${var.app_name}"
}

resource "aws_iam_access_key" "app" {
  user = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_cognito" {
  statement {
    effect    = "Allow"
    resources = ["${var.aws_cognito_arn}"]

    actions = [
      "cognito-idp:ListUsersInGroup",
    ]
  }
}

resource "aws_iam_user_policy" "app_cognito" {
  name   = "cognito"
  policy = "${data.aws_iam_policy_document.app_cognito.json}"
  user   = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_s3" {
  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["${var.aws_s3_assets_bucket_arn}"]
  }

  statement {
    effect    = "Allow"
    resources = ["${var.aws_s3_assets_bucket_arn}/*"]

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
    ]
  }
}

resource "aws_iam_user_policy" "app_s3" {
  name   = "s3"
  policy = "${data.aws_iam_policy_document.app_s3.json}"
  user   = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_ses" {
  statement {
    actions   = ["ses:SendRawEmail"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "app_ses" {
  name   = "ses"
  policy = "${data.aws_iam_policy_document.app_ses.json}"
  user   = "${aws_iam_user.app.name}"
}
