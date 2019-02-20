resource "aws_iam_user" "app" {
  name = "${var.app_name}"
}

resource "aws_iam_access_key" "app" {
  user = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_cognito" {
  statement = {
    effect = "Allow"

    actions = [
      "cognito-idp:CreateGroup",
      "cognito-idp:DeleteGroup",
      "cognito-idp:ListGroups",
      "cognito-idp:ListUsersInGroup",
      "cognito-idp:UpdateUserPoolClient",
    ]

    resources = [
      "${var.aws_cognito_arn}",
    ]
  }
}

resource "aws_iam_user_policy" "app_cognito" {
  name   = "cognito"
  policy = "${data.aws_iam_policy_document.app_cognito.json}"
  user   = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_s3" {
  statement = {
    effect = "Allow"

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${var.aws_s3_assets_bucket_arn}",
    ]
  }

  statement = {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject",
    ]

    resources = [
      "${var.aws_s3_assets_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "app_s3" {
  name   = "s3"
  policy = "${data.aws_iam_policy_document.app_cognito.json}"
  user   = "${aws_iam_user.app.name}"
}

data "aws_iam_policy_document" "app_ses" {
  statement = {
    effect = "Allow"

    actions = [
      "ses:SendRawEmail",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user_policy" "app_ses" {
  name   = "ses"
  policy = "${data.aws_iam_policy_document.app_ses.json}"
  user   = "${aws_iam_user.app.name}"
}
