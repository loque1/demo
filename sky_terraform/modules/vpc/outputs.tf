output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "zone_id" {
  value = "${data.aws_route53_zone.dnsToAddTo.zone_id}"
}

output "route_table_public_id" {
  value = "${aws_route_table.rt_public.id}"
}

output "route_table_private_id" {
  value = "${aws_route_table.rt_private.*.id}"
}

output "route_table_lambda_id" {
  value = "${aws_route_table.rt_lambda.*.id}"
}

output "route_table_dmz_id" {
  value = "${aws_route_table.rt_dmz.*.id}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
