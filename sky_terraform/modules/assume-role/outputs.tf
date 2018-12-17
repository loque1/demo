output "iam_policy_arn" {
  value = "${aws_iam_policy.assume_role.arn}"
}
