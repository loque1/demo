resource "aws_sqs_queue" "main" {
  name = "${var.environment}-${var.service}"
  visibility_timeout_seconds = "${var.visibility_timeout_seconds}"
  message_retention_seconds  = "${var.message_retention_seconds}"
  tags {
    Name = "${var.environment}-${var.service}"
  }
}

resource "aws_sqs_queue_policy" "main" {
  queue_url = "${aws_sqs_queue.main.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "SqsDefaultPolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "SQS:ReceiveMessage",
        "SQS:DeleteMessage"
      ],
      "Resource": "${aws_sqs_queue.main.arn}"
    }
  ]
}
POLICY
}
