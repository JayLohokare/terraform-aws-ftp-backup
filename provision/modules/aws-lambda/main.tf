data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "lambda" {

  function_name = "${var.function_name}"
  description = "${var.description}"

  handler = "${var.handler}"
  runtime = "${var.runtime}"
  memory_size = "${var.memory_size}"
  timeout = "${var.timeout}"

  s3_bucket = "${var.code_bucket}"
  s3_key    = "${aws_s3_bucket_object.lambda_bucket_object.id}"

  role = "${aws_iam_role.lambda_basic_exec_role.arn}"

  publish = true

  environment {
    variables = "${var.environment_variables}"
  }
}

resource "aws_s3_bucket_object" "lambda_bucket_object" {
  bucket = "${var.code_bucket}"
  key    = "${var.package_name}"
  source = "../${var.function_name}/dist/${var.package_name}"
}

resource "aws_iam_role" "lambda_basic_exec_role" {
  name = "${var.function_name}_role"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy_attachment" "logs_policy_attachment" {
  name       = "${var.function_name}-logs"
  roles      = ["${aws_iam_role.lambda_basic_exec_role.name}"]
  policy_arn = "${aws_iam_policy.logs_policy.arn}"
}

resource "aws_iam_policy" "logs_policy" {
  name   = "${var.function_name}-logs"
  policy = "${data.aws_iam_policy_document.logs_policy_document.json}"
}

data "aws_iam_policy_document" "logs_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*",
    ]
  }
}