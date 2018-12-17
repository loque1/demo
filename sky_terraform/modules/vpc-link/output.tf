output "vpc_link_id" {
  value = "${aws_api_gateway_vpc_link.dynamodb_update.id}"
}
