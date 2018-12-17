variable "vpcName" {}
variable "vpcCidrBlock" {}
variable "igwName" {}
variable "dhcpOptionsId" {}
variable "dnsDomain" {}

variable "createInternalDns" {
  description = "if first vpc, create DNS. Else attach to existing DNS"
}

variable "addToInternalDns" {
  description = "if first vpc, create DNS. Else attach to existing DNS"
}

variable "igwCidrBlock" {}
variable "rtName" {}
variable "region" {}

variable "subnet_count" {}

variable "lambda_subnet_count" {
  default = 0
}

variable "dmz_subnet_count" {
  description = "if you want to create a routing table that has instance that you do don't want in you private routing table i.e. having access to the natgateway and internet access"
  default = 0
}
