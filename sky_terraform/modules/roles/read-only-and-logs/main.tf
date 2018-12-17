resource "aws_iam_role" "read_and_logs" {
    name = "ReadOnlyAndLogs"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "Read only access to AWS resources and access to Cloudwatch logs"
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
    role = "${aws_iam_role.read_and_logs.id}"
    policy_arn = "${data.aws_iam_policy.read_only_access.arn}"
}

data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "developer_management_role_logs_policy" {
    name = "DeveloperLogsPolicy"
    policy = "${data.aws_iam_policy_document.developer_logs.json}"
    role = "${aws_iam_role.read_and_logs.id}"
}

data "aws_iam_policy_document" "developer_logs" {
  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",

    ]

    resources = [
        "arn:aws:logs:*:*:*"
    ]
  },
  statement {
    actions = [
        "ec2:DescribeTags",
        "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}
