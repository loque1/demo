variable "environment" {
}

variable "instance_type" {
}

variable "cluster_min_size" {
}

variable "cluster_max_size" {
}

variable "private_subnet_ids" {
  type = "list"
}

variable "lambda_subnet_ids" {
  type = "list"
}

variable "cluster_desired_capacity" {
}

variable "desired_task_count_webservice" {
}

variable "minimum_healthy_percent_webservice" {
}

variable "maximum_healthy_percent_webservice" {
}

variable "desired_task_count_iac" {
}

variable "minimum_healthy_percent_iac" {
}

variable "maximum_healthy_percent_iac" {
}

variable "desired_task_count_address" {
}

variable "minimum_healthy_percent_address" {
}

variable "maximum_healthy_percent_address" {
}

variable "desired_task_count_ear" {
}

variable "minimum_healthy_percent_ear" {
}

variable "maximum_healthy_percent_ear" {
}

variable "desired_task_count_lookup" {
}

variable "minimum_healthy_percent_lookup" {
}

variable "maximum_healthy_percent_lookup" {
}

variable "desired_task_count_request" {
}

variable "minimum_healthy_percent_request" {
}

variable "maximum_healthy_percent_request" {
}

variable "public_subnet_ids" {
  type = "list"
}

variable "vpc_id" {
}

variable "SkyDirectAccess" {
  type = "list"
}

variable "dynamo_db_read_capacity" {
}

variable "dynamo_db_write_capacity" {
}

variable "db_instance_class" {
}

variable "zone_id" {
}

variable "cluster_security_group_id" {
}

variable "external_domain" {
}

variable "replicas_per_node_group" {
}

variable "num_node_groups" {
}

variable "node_type" {
}

variable "dcoms_visibility_timeout_seconds" {
}

variable "dcoms_message_retention_seconds" {
}

variable "dcoms_sqs_batch_size" {

}

variable "dcoms_address_visibility_timeout_seconds" {
}

variable "dcoms_address_message_retention_seconds" {
}

variable "dcoms_address_sqs_batch_size" {

}

variable "iac_sqs_batch_size" {

}

variable "submission_visibility_timeout_seconds" {
}

variable "submission_message_retention_seconds" {
}

variable "iac_visibility_timeout_seconds" {
}

variable "iac_message_retention_seconds" {
}

variable "iacservice_name" {
  default = "iac"
}

variable "iacservice_port" {
  default = "8081"
}

variable "iac_update_enabled" {
}

variable "iac_update_rate" {
}

variable "status_patch_timeout" {
  default = 3
}

variable "allocation_patch_timeout" {
  default = 3
}

variable "nrsAccessCount" {

}

variable "nrsAccess" {
  type = "list"
}

variable "DB_NAME" {}

variable "DB_USER" {}

variable "DB_PWORD" {}

variable "ecs_role" {}

variable "iac_max_updates" {}

variable "dcoms_username" {}

variable "dcoms_password" {}

variable "delete_service_sqs_batch_size" {}

variable "delete_service_message_retention_seconds" {}

variable "delete_service_visibility_timeout_seconds" {}

variable "iac_update_timeout" {
  default = 3
}

variable "iac_update_db_timeout" {
  default = 3
}

variable "ear_update_timeout" {
  default = 3
}
