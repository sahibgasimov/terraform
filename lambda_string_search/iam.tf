########################### IAM ROLES AND POLICIES ########################

# Create IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SNS policy to Lambda role
resource "aws_iam_role_policy_attachment" "sns_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}



# Attach AWSLambdaBasicExecutionRole policy to Lambda role
resource "aws_iam_policy_attachment" "lambda_basic_execution_attachment" {
  name       = "AWSLambdaBasicExecutionRoleAttachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



# Create IAM policy for SNS access
resource "aws_iam_policy" "sns_policy" {
  name        = "${var.lambda_function_name}-policy"
  description = "Allows publishing to SNS topics"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "ec2:DescribeInstances",
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Action   = "sns:Publish",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

# Attach AmazonSNSFullAccess policy to Lambda role
resource "aws_iam_policy_attachment" "sns_full_access_attachment" {
  name       = "AmazonSNSFullAccessAttachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}