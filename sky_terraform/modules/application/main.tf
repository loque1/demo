data "aws_acm_certificate" "sky" {
  domain   = "*.${var.external_domain}"
}

// ------------------- DYNAMO DB

variable "dynamodb_name" {
  default = "dates"
}

resource "aws_dynamodb_table" "Questionnaire" {
  name              = "${var.dynamodb_name}"
  read_capacity     = "${var.dynamo_db_read_capacity}"
  write_capacity    = "${var.dynamo_db_write_capacity}"
  hash_key          = "date"
  range_key         = "date"
  stream_enabled    = false

  attribute {
    name = "date"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  tags {
    Name        = "${var.dynamodb_name}"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }
}



data "aws_iam_policy" "sqs_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dcoms_lambda_basic" {
    role       = "${module.dcoms_lambda.role_name}"
    policy_arn = "${data.aws_iam_policy.basic_execution.arn}"
}

data "aws_iam_policy" "basic_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "vpc_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


// ---------------------- S3 LAMBDA BUCKET

resource "aws_s3_bucket"  "lambda" {
  bucket = "${lower("scsky-lambda-${var.environment}")}"
  acl    = "private"
  versioning {
    enabled = "True"
  }

  tags {
    Name        = "sky-lambda-${var.environment}"
    Environment = "${var.environment}"
  }
}


variable "dynamoupdate" {
  default = "dynamoupdate.zip"
}

// dummy lambda code for notify lambda to prevent terraform error
resource "aws_s3_bucket_object" "dynamoupdate" {
  bucket     = "${lower("updateDB-${var.environment}")}"
  key        = "${var.dynamoupdate}"
  source     = "zips/${var.dynamoupdate}"
  depends_on = ["aws_s3_bucket.lambda"]
}


module "updateDynamoDB" {
  source = "../lambda"

  lambda_name               = "UpdateDynamoDB"
  iam_role_policy_location  = "../../modules/application/policies/lambda-queue.json"
  s3_lambda_bucket          = "${lower("scsky-lambda-${var.environment}")}"
  s3_key_name               = "${var.dynamoupdate}"
  handler                   = "app.handler"
  runtime                   = "python3.7"
  environment_variables     = "${map("DCOMS_ENDPOINT", "${var.dcoms_endpoint}", "DCOMS_USERNAME", "${var.dcoms_username}", "DCOMS_PASSWORD", "${var.dcoms_password}")}"
  subnet_ids                = "${var.lambda_subnet_ids}"
  security_group_ids        = "${var.cluster_security_group_id}"
}

resource "aws_iam_role_policy_attachment" "dynamoupdate_lambda_vpc" {
    role       = "${module.updateDynamoDB.role_name}"
    policy_arn = "${data.aws_iam_policy.vpc_access.arn}"
}


resource "aws_iam_role_policy_attachment" "dcoms_address_lambda_basic" {
    role       = "${module.dcoms_address_lambda.role_name}"
    policy_arn = "${data.aws_iam_policy.basic_execution.arn}"
}

