variable "environment" {}

variable "request_vpc_id" {}

variable "peer_vpc_id" {}

variable "cluster_id" {}

variable "bastion-management_id" {}

variable "repo-management_id" {}

variable "proxy-access_id" {}

variable "mailhog-access_id" {}

variable "logstash_id" {}

variable "leapwork-agent_id" {}

variable "management_route_table_public_id" {}

variable "question_engine_vpc_cidr_block" {}

variable "management_vpc_cidr_block" {}

variable "question_engine_vpc_route_table_private_id" {
  type = "list"
}

variable "management_vpc_route_table_private_id" {
  type = "list"
}

variable "public_cidr" {
  type = "list"
}

variable "management_public_cidr" {
  type = "list"
}
