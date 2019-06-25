output "function_arn" {
  value = "${aws_lambda_function.lambda.arn}"
}

output "function_name" {
  value = "${aws_lambda_function.lambda.function_name}"
}

output "role_name" {
  value = "${aws_iam_role.lambda_basic_exec_role.name}"
}