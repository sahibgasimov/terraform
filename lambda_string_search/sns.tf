########################### SNS Topic ###########################
# Create SNS topic
resource "aws_sns_topic" "sns_topic" {
  name = "${var.lambda_function_name}-sns-topic"
}
