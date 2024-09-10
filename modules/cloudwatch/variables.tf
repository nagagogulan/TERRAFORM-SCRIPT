variable "rds_instance_id" {
  description = "RDS instance id"
  type        = string
}

variable "common_tags" {
  description = "Common tags"
  type        = map(string)
}
variable "env_name" {
  description = "Environment name"
  type        = string
}

variable "app_name" {
  description = "App name"
  type        = string
}

variable "email_alert_sns_topic_arn" {
  description = "SNS topic arn"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS id"
  type        = string
}