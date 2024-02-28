module "ec2_reboot_schedule" {
  source       = "./module/module"
  region       = "us-east-2"
  instance_ids = ["i-0b72b483a01fe21d4", "i-0b72b483a01fe21d4"]
  account_id   = "014113799398"
  sns_topic_arn = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
}
variable "region" {
  type        = string
  description = "Region to deploy resources"
}

variable "instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to target"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID for ARN constructions"
}

variable "sns_topic_arn" {
  type        = string
  description = "SNS Topic ARN to notify on RebootInstances"
}




###########intance for module#########

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 0.15"
    }
  }
}

provider "aws" {
  region = var.region
}


# This section creates cron schedules using Amazon EventBridge Scheduler, as well as the required IAM roles to interact with EC2

resource "aws_scheduler_schedule" "ec2-reboot-schedule" {
  name = "ec2-reboot-schedule"
  
  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(0 8 ? * MON-FRI *)" # Scheduled startInstances at 8am EST Mon-Fri
  schedule_expression_timezone = "US/Eastern" # Default is UTC
  description = "Start instances event"

  target {
    arn = "arn:aws:scheduler:::aws-sdk:ec2:rebootInstances"
    role_arn = aws_iam_role.scheduler-ec2-role.arn
  
    input = jsonencode({
      "InstanceIds": var.instance_ids
    })
  }
}


resource "aws_iam_policy" "scheduler_ec2_policy" {
  name = "scheduler_ec2_policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:RebootInstances"],
        Effect   = "Allow",
        Resource = [for instance in var.instance_ids : "arn:aws:ec2:${var.region}:${var.account_id}:instance/${instance}"]
      },
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = var.sns_topic_arn
      }
    ]
  })
}

resource "aws_iam_role" "scheduler-ec2-role" {
  name = "scheduler-ec2-role"
  managed_policy_arns = [aws_iam_policy.scheduler_ec2_policy.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "scheduler.amazonaws.com"
        }
      },
    ]
  })
}


########VARIABLES#####

variable "region" {
  type        = string
  description = "Region to deploy resources"
  default = "us-east-2"
}

variable "instance_id" {
  type        = string
  description = "instance_id to deploy resources"
  default = "i-0b72b483a01fe21d4"
}

variable "account_id" {
  type        = string
  description = "instance_id to deploy resources"
  default = "014113799398"
}

variable "sns_topic_arn" {
  type        = string
  description = "instance_id to deploy resources"
  default = "arn:aws:sns:us-east-2:014113799398:system-health-check-failed-alert"
}


#######CloudWatch Event Rule ###########

# Create a CloudWatch Events Rule for EC2 reboot

resource "aws_cloudwatch_event_rule" "ec2_reboot_rule" {
  name        = "ec2-reboot-rule"
  description = "Capture every RebootInstances from EC2"

  event_pattern = jsonencode({
    "source" : ["aws.ec2"],
    "detail-type" : ["AWS API Call via CloudTrail"],
    "detail" : {
      "eventSource" : ["ec2.amazonaws.com"],
      "eventName" : ["RebootInstances"]
    }
  })
}

resource "aws_cloudwatch_event_target" "ec2_reboot_target" {
  rule      = aws_cloudwatch_event_rule.ec2_reboot_rule.name
  target_id = "SendSNS"
  arn       = var.sns_topic_arn
}


