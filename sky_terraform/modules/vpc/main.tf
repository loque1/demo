## create the vpc
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpcCidrBlock}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.vpcName}"
  }
}

## create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.igwName}"
  }
}

## associate vpc with dhcp-options from /base
resource "aws_vpc_dhcp_options_association" "dnsResolver" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${var.dhcpOptionsId}"
}

## create vpc private-hosted-zone (internal DNS). Needs to be optional, along with adding a VPC to a private zone.
resource "aws_route53_zone" "dnsInternal" {
  count         = "${var.createInternalDns}"
  name          = "${var.dnsDomain}"
  force_destroy = "false"
  vpc_id        = "${aws_vpc.vpc.id}"
  vpc_region    = "${var.region}"
}

## data object to lookup route53 zone named by var.dnsDomain.
data "aws_route53_zone" "dnsToAddTo" {
  name         = "${var.dnsDomain}"
  private_zone = true
  depends_on   = ["aws_route53_zone.dnsInternal"]
  vpc_id       = "${aws_vpc.vpc.id}"
}

## adding vpc to private DNS
resource "aws_route53_zone_association" "vpcDnsAssociation" {
  count   = "${var.addToInternalDns}"
  zone_id = "${data.aws_route53_zone.dnsToAddTo.zone_id}"
  vpc_id  = "${aws_vpc.vpc.id}"
}

## create route table and grant the VPC internet access through its igw
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "public-${var.rtName}"
  }
}

resource "aws_main_route_table_association" "rt_public" {
  vpc_id         = "${aws_vpc.vpc.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route" "rInternetAccess" {
  route_table_id         = "${aws_route_table.rt_public.id}"
  destination_cidr_block = "${var.igwCidrBlock}"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

## create route tables for private access (for example for peering and NAT gateway)
resource "aws_route_table" "rt_private" {
  count  = "${var.subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "private-${var.rtName}"
  }
}

##create route table for lambda private access
resource "aws_route_table" "rt_lambda" {
  count  = "${var.lambda_subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "lambda-${var.rtName}"
  }
}

## create route table for private instance that need access to the internet vi Nat gateway  i.e proxy, email etc. 
resource "aws_route_table" "rt_dmz" {
  count  = "${var.dmz_subnet_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "dmz-${var.rtName}"
  }
}
