###################### CLOUDWATCH EVENT RULE ##########################


# CloudWatch event rule to trigger lambda based on cronjob 
resource "aws_cloudwatch_event_rule" "every_friday" {
  name                = "${aws_lambda_function.reboot_lambda.function_name}-lambda-trigger"
  schedule_expression = var.cron_schedule
}

# CloudWatch event target
resource "aws_cloudwatch_event_target" "reboot_ec2_target" {
  rule      = aws_cloudwatch_event_rule.every_friday.name
  target_id = "${aws_lambda_function.reboot_lambda.function_name}-lambda-trigger"
  arn       = aws_lambda_function.reboot_lambda.arn
}

# Allow CloudWatch to trigger Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.reboot_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_friday.arn
}
