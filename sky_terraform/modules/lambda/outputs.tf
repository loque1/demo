output "role_name" {
  value = "${aws_iam_role.iam_for_lambda.name}"
}

output "lambda_arn" {
  value = "${aws_lambda_function.main_vpc.arn}"
}
