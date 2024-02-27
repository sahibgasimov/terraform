########VARIABLES#####

variable "region" {
  type        = string
  description = "Region to deploy resources"
  default     = ""
}


variable "account_id" {
  type        = string
  description = "instance_id to deploy resources"
  default     = ""
}

variable "sns_topic_arn" {
  type        = string
  description = "instance_id to deploy resources"
  default     = ""
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {}
}

variable "cron_schedule" {
  description = "Cron schedule for the CloudWatch event rule"
  type        = string
}
variable "lambda_function_name" {
  description = "Lambda Function Name"
  type        = string
}
