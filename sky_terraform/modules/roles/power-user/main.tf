resource "aws_iam_role" "admin_role" {
    name = "PowerUser"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "Power user access to AWS resources"
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

resource "aws_iam_role_policy_attachment" "admin_role_policy_read" {
    role = "${aws_iam_role.admin_role.id}"
    policy_arn = "${data.aws_iam_policy.read_access.arn}"
}


data "aws_iam_policy" "admin_access" {
  arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy" "read_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "developer_dev_role_iam_roles_policy" {
    name = "DeveloperRolesPolicy"
    policy = "${data.aws_iam_policy_document.developer_iam_roles.json}"
    role = "${aws_iam_role.admin_role.id}"
}

data "aws_iam_policy_document" "developer_iam_roles" {
  statement {
    actions = [
        "iam:CreateRole",
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRole",
        "iam:DeleteRolePolicy",
        "iam:DetachRolePolicy",
        "iam:GetRole",
        "iam:PassRole"
    ]

    resources = ["*"]
  },
  statement {
    actions = [
        "ec2:DescribeTags",
        "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}
