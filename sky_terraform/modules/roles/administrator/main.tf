resource "aws_iam_role" "admin_role" {
    name = "Administrator"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "Full admin access to AWS resources"
}

data "aws_iam_policy_document" "assumeRole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::377811734564:root"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "admin_role_policy" {
    role = "${aws_iam_role.admin_role.id}"
    policy_arn = "${data.aws_iam_policy.admin_access.arn}"
}

data "aws_iam_policy" "admin_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
