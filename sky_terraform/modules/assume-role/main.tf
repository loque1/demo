data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${var.role_arn}"]
  }
}

resource "aws_iam_policy" "assume_role" {
  name        = "${var.name}"
  description =  "${var.description}"
  policy = "${data.aws_iam_policy_document.assume_role.json}"
}
