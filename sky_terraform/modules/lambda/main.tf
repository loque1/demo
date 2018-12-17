// identity
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "template_file" "lambda_policy" {
  template = "${file(var.iam_role_policy_location)}"

  vars {
    region   = "${data.aws_region.current.name}"
    account_id   = "${data.aws_caller_identity.current.account_id}"
    service = "${var.lambda_name}"
    bucket-name = "${var.s3_bucket_access}"
   }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "Lambda${var.lambda_name}Role"
  assume_role_policy = "${data.aws_iam_policy_document.assumeRole.json}"
}

data "aws_iam_policy_document" "assumeRole" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "lambda_role_policy" {
    name = "Lambda${var.lambda_name}RolePolicy"
    policy = "${data.template_file.lambda_policy.rendered}"
    role = "${aws_iam_role.iam_for_lambda.id}"
}

resource "aws_lambda_function" "main_vpc" {
  s3_bucket        = "${var.s3_lambda_bucket}"
  s3_key           = "${var.s3_key_name}"
  function_name    = "${var.lambda_name}"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.lambda_timeout}"
  vpc_config {
    subnet_ids = ["${var.subnet_ids}"]
    security_group_ids = ["${var.security_group_ids}"]
  }
  environment {
    variables = "${var.environment_variables}"
  }
}
