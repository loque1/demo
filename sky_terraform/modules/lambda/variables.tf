variable "lambda_name" {

}

variable "iam_role_policy_location" {

}

variable "s3_lambda_bucket" {

}

variable "s3_bucket_access" {
  default = ""
}

variable "s3_key_name" {

}

variable "handler" {

}

variable "runtime" {

}

variable "environment_variables" {
  type = "map"
}

variable "subnet_ids" {
  default = [""]
}

variable "security_group_ids" {
  default = ""
}

variable "lambda_timeout" {
  default = "3"
}
