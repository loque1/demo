resource "aws_iam_role" "ci_role" {
    name = "Ci"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "ci access to AWS resources"
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

resource "aws_iam_role_policy_attachment" "ci_policy" {
    role = "${aws_iam_role.ci_role.id}"
    policy_arn = "${aws_iam_policy.ci_access.arn}"
}

resource "aws_iam_policy" "ci_access" {
  name = "Ci"
  policy = "${data.aws_iam_policy_document.ci_access.json}"
}

data "aws_iam_policy_document" "ci_access" {
  statement {
    actions = ["ecs:*"]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
      "ec2:DeleteVolume"
    ]
    resources = ["*"]
  }

  statement {
    actions = ["lambda:UpdateFunctionCode",
                "lambda:Get*",
                "lambda:List*"]
    resources = ["*"]
  }
}
