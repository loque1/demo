resource "aws_iam_role" "read_only_role" {
    name = "ReadOnly"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "Read only access to AWS resources"
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

resource "aws_iam_role_policy_attachment" "read_only_role_policy" {
    role = "${aws_iam_role.read_only_role.id}"
    policy_arn = "${data.aws_iam_policy.read_only_access.arn}"
}

data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
