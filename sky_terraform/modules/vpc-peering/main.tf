provider "aws" {
  alias = "src"
}

provider "aws" {
  alias = "dst"
}

resource "aws_vpc_peering_connection" "management_to_dev" {
  provider      = "aws.src"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${data.aws_caller_identity.peer.account_id}"
  vpc_id        = "${var.request_vpc_id}"
  auto_accept   = false

  tags {
    Name = "VPC Peering between Management and ${var.environment}"
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "management_to_dev" {
  provider                  = "aws.dst"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_dev.id}"
  auto_accept               = true

  tags {
    Name = "VPC Peering between Management and ${var.environment}"
    Side = "Accepter"
  }
}

variable "region" {
  default = "eu-west-2"
}

data "aws_caller_identity" "peer" {
  provider = "aws.dst"
}

data "aws_caller_identity" "requester" {
  provider = "aws.src"
}

resource "aws_security_group_rule" "bastion_to_instance-development" {
  provider                 = "aws.src"
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.bastion-management_id}"
}

resource "aws_security_group_rule" "instance-development_from_bastion" {
  provider                 = "aws.dst"
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "TCP"
  security_group_id        = "${var.cluster_id}"
  source_security_group_id = "${data.aws_caller_identity.requester.account_id}/${var.bastion-management_id}"
}

resource "aws_security_group_rule" "mailhog_access_to_instance-development" {
  provider                 = "aws.dst"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 1025
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.requester.account_id}/${var.mailhog-access_id}"
  security_group_id        = "${var.cluster_id}"
}

resource "aws_security_group_rule" "mailhog_access_from_instance-development" {
  provider                 = "aws.src"
  type                     = "egress"
  from_port                = 1025
  to_port                  = 1025
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.requester.account_id}/${var.cluster_id}"
  security_group_id        = "${var.mailhog-access_id}"
}

resource "aws_security_group_rule" "instance-development_access_from_mailhog_access" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 1025
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.mailhog-access_id}"
}

resource "aws_security_group_rule" "proxy_access_to_instance-development" {
  provider                 = "aws.dst"
  type                     = "ingress"
  from_port                = 3128
  to_port                  = 3128
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.requester.account_id}/${var.proxy-access_id}"
  security_group_id        = "${var.cluster_id}"
}

resource "aws_security_group_rule" "proxy_access_from_instance-development" {
  provider                 = "aws.src"
  type                     = "egress"
  from_port                = 3128
  to_port                  = 3128
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.requester.account_id}/${var.cluster_id}"
  security_group_id        = "${var.proxy-access_id}"
}

resource "aws_security_group_rule" "instance-development_access_from_proxy_acess" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 3128
  to_port                  = 3128
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.proxy-access_id}"
}

resource "aws_security_group_rule" "leapwork_access_http_from_env" {
  provider          = "aws.src"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.public_cidr}"]
  security_group_id = "${var.leapwork-agent_id}"
}

#resource "aws_security_group_rule" "leapwork_access_http_to_env" {
#  provider          = "aws.src"
#  type              = "egress"
#  from_port         = 80
#  to_port           = 80
#  protocol          = "TCP"
#  cidr_blocks       = ["${var.public_cidr}"]
#  security_group_id = "${var.leapwork-agent_id}"
#}

resource "aws_security_group_rule" "leapwork_access_https_from_env" {
  provider          = "aws.src"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["${var.public_cidr}"]
  security_group_id = "${var.leapwork-agent_id}"
}

#resource "aws_security_group_rule" "leapwork_access_https_to_env" {
#  provider          = "aws.src"
#  type              = "egress"
#  from_port         = 443
#  to_port           = 443
#  protocol          = "TCP"
#  cidr_blocks       = ["${var.public_cidr}"]
#  security_group_id = "${var.leapwork-agent_id}"
#}

#Commented out the below as we don't neeD the cluster_id security group but rather the loadbalancer
#resource "aws_security_group_rule" "leapwork_access_http_to_env" {
#  provider          = "aws.dst"
#  type              = "ingress"
#  from_port         = 80
#  to_port           = 80
#  protocol          = "TCP"
#  cidr_blocks       = ["${var.management_public_cidr}"]
#  security_group_id = "${var.cluster_id}"
#}

#resource "aws_security_group_rule" "leapwork_access_https_to_env" {
#  provider          = "aws.dst"
#  type              = "ingress"
#  from_port         = 443
#  to_port           = 443
#  protocol          = "TCP"
#  cidr_blocks       = ["${var.management_public_cidr}"]
#  security_group_id = "${var.cluster_id}"
#}

resource "aws_security_group_rule" "repo_docker_from_instance-development" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5003
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.repo-management_id}"
}

resource "aws_security_group_rule" "repo_http_from_instance-development" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.repo-management_id}"
}

resource "aws_security_group_rule" "logstash_tcp_from_instance-development" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 5044
  to_port                  = 5044
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.logstash_id}"
}

resource "aws_security_group_rule" "repo_https_from_instance-development" {
  provider                 = "aws.src"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = "${data.aws_caller_identity.peer.account_id}/${var.cluster_id}"
  security_group_id        = "${var.repo-management_id}"
}

resource "aws_route" "management_to_dev" {
  provider                  = "aws.src"
  route_table_id            = "${var.management_route_table_public_id}"
  destination_cidr_block    = "${var.question_engine_vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_dev.id}"
}

resource "aws_route" "private-management_to_dev" {
  provider                  = "aws.src"
  count                     = "${length(var.management_vpc_route_table_private_id)}"
  route_table_id            = "${element(var.management_vpc_route_table_private_id, count.index)}"
  destination_cidr_block    = "${var.question_engine_vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_dev.id}"
}

resource "aws_route" "dev_from_management" {
  provider                  = "aws.dst"
  count                     = "${length(var.question_engine_vpc_route_table_private_id)}"
  route_table_id            = "${element(var.question_engine_vpc_route_table_private_id, count.index)}"
  destination_cidr_block    = "${var.management_vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_dev.id}"
}
