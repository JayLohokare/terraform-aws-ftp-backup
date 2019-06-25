module "move_ftp_files_to_s3_lambda" {
  source = "./modules/aws-lambda"

  function_name = "move-ftp-files-to-s3"
  description   = "Move files from configured AHMS FTP server and folder into configured S3 Bucket/path"
  handler       = "entrypoint.handler"
  runtime       = "nodejs8.10"
  code_version  = "v1.0.0"
  code_bucket   = "${aws_s3_bucket.lambda_code_bucket.bucket}"

  environment_variables = {
    "FTP_CONFIG_PARAMETER" = "${aws_ssm_parameter.ftp_config.name}",
  }

}

# Allow Lambda to write to any bucket within this AWS Account

resource "aws_iam_policy_attachment" "lambda_iam_policy_attachment" {
  name       = "${module.move_ftp_files_to_s3_lambda.function_name}-policy"
  roles      = ["${module.move_ftp_files_to_s3_lambda.role_name}"]
  policy_arn = "${aws_iam_policy.lambda_iam_policy.arn}"
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name   = "${module.move_ftp_files_to_s3_lambda.function_name}-policy"
  policy = "${data.aws_iam_policy_document.lambda_iam_policy_document.json}"
}

data "aws_iam_policy_document" "lambda_iam_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.destination_one_bucket.bucket}/*"
      # "arn:aws:s3:::${aws_s3_bucket.destination_two_bucket.bucket}/*"
    ]
  }
  
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/*"
    ]
  }
}