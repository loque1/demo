resource "aws_iam_role" "tester_role" {
    name = "Tester"
    assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
    description = "Read only access to AWS resources and DynamoDb permissions"
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

resource "aws_iam_role_policy_attachment" "tester_role_policy" {
    role = "${aws_iam_role.tester_role.id}"
    policy_arn = "${data.aws_iam_policy.read_only_access.arn}"
}

data "aws_iam_policy" "read_only_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_role_policy" "tester_sqs_add_policy" {
  name = "TesterSQSRolePolicy"
  role = "${aws_iam_role.tester_role.id}"
  policy = "${data.aws_iam_policy_document.sqs_add_access.json}"
}

data "aws_iam_policy_document" "sqs_add_access" {
  statement {
    actions = [
      "sqs:SendMessage"
    ]
    resources = [
      "arn:aws:sqs:eu-west-2:605041546022:SysTest-*"
    ]
  }
}

resource "aws_iam_role_policy" "tester_dynamo_db_role_policy" {
    name = "TesterDynamoDbRolePolicy"
    policy = "${data.aws_iam_policy_document.tester_dynamo_db.json}"
    role = "${aws_iam_role.tester_role.id}"
}

data "aws_iam_policy_document" "tester_dynamo_db" {
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:PutItem"
    ]

    resources = [
      "arn:aws:dynamodb:eu-west-2:605041546022:table/QuestionnaireAnswers"
    ]
  }
}

resource "aws_iam_role_policy" "tester_force_lambda_role_policy" {
    name = "TesterForceLambdaRolePolicy"
    policy = "${data.aws_iam_policy_document.tester_force_lambda.json}"
    role = "${aws_iam_role.tester_role.id}"
}

data "aws_iam_policy_document" "tester_force_lambda" {
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "arn:aws:lambda:eu-west-2:605041546022:function:ForceSubmissionService"
    ]
  }
}
