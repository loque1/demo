resource "aws_api_gateway_vpc_link" "dynamodb_update" {
  name        = "update"
  description = "updates dynamodb"
  target_arns = ["${var.lb_arn}"]
}
