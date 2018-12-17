output "role_arn" {
  value = "${aws_iam_role.read_only_role.arn}"
}
