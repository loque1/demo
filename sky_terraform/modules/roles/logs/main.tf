resource "aws_iam_role" "logs" {
    name = "Logs"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "AWS resources to Cloudwatch logs"
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

resource "aws_iam_role_policy_attachment" "logs_policy" {
    role = "${aws_iam_role.logs.id}"
    policy_arn = "${data.aws_iam_policy.logs_access.arn}"
}

data "aws_iam_policy" "logs_access" {
  arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy" {
    role = "${aws_iam_role.logs.id}"
    policy_arn = "${data.aws_iam_policy.dynamodb_access.arn}"
}

data "aws_iam_policy" "dynamodb_access" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
}

resource "aws_iam_role_policy" "management_role_monitoringAccess_policy" {
    name = "MonitoringAccessPolicy"
    policy = "${data.aws_iam_policy_document.monitoringAccess.json}"
    role = "${aws_iam_role.logs.id}"
}

data "aws_iam_policy_document" "monitoringAccess" {
  statement {
    actions = [
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "logs:Get*",
        "logs:Describe*",
        "sns:Get*",
        "sns:List*"
    ]
    resources = [
        "arn:aws:logs:*:*:*"
    ]
  },
  statement {
    actions = [
        "ec2:DescribeTags",
    ]
    resources = ["*"]
  },
  statement {
    actions = [
        "dynamodb:GetItem",
        "dynamodb:BatchGetItem",
        "dynamodb:Query",
        "dynamodb:ListTables",
        "dynamodb:DescribeTable",
        "autoscaling:Describe*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "cloudwatch:*",
        "sns:Get*",
        "sns:List*"
    ]
    resources = [
        "arn:aws:dynamodb:*:*:*"
    ]
  }
}
