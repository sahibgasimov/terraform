######################## LAMBDA ######################################

# Lambda function to reboot EC2 and send SNS
resource "aws_lambda_function" "reboot_lambda" {
  filename      = "./handler.py.zip" # You have to package your lambda code into a ZIP file
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.lambda_handler" # This points to the Python function
  runtime       = "python3.8"              # Set to Python 3.8

  timeout = 60 # sets the timeout to 15 seconds

  environment {
    variables = {
      sns_topic_arn = aws_sns_topic.sns_topic.arn
    }
  }
}
