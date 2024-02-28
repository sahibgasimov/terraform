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

resource "aws_scheduler_schedule" "ec2-start-schedule" {
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
      "InstanceIds": [
        var.instance_id
      ]
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
        Resource = "arn:aws:ec2:${var.region}:${var.account_id}:instance/${var.instance_id}" # Replace with your EC2 instance ARN
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

resource "aws_cloudwatch_event_target" "ec2_sns_target" {
  rule      = aws_cloudwatch_event_rule.ec2_reboot_rule.name
  target_id = "SendSNS"
  arn       = var.sns_topic_arn
}

# Target for EC2 RebootInstances
resource "aws_cloudwatch_event_target" "ec2_reboot_target" {
  rule      = aws_cloudwatch_event_rule.ec2_reboot_rule.name
  target_id = "EC2-RebootInstances-APICall"
  arn       = "arn:aws:ec2:${var.region}:${var.account_id}:instance/${var.instance_id}"
  role_arn  = aws_iam_role.ec2_reboot_target_role.arn

  input = jsonencode({
    "InstanceIds": var.instance_id
  })
}

resource "aws_iam_role" "ec2_reboot_target_role" {
  name = "ec2_reboot_target_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy" "ec2_reboot_target_policy" {
  name = "ec2_reboot_target_policy"
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action   = ["ec2:RebootInstances"],
        Effect   = "Allow",
        Resource = "arn:aws:ec2:${var.region}:${var.account_id}:instance/${var.instance_id}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_reboot_target_policy_attachment" {
  policy_arn = aws_iam_policy.ec2_reboot_target_policy.arn
  role       = aws_iam_role.ec2_reboot_target_role.name
}
