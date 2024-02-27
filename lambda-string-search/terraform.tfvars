region               = "us-east-1"
lambda_function_name = "obalara"
account_id           = "315404971412" # Add your account number
#sns_topic_arn        = "arn:aws:sns:usreast-1:315404971412:sadko"
cron_schedule        = "cron(21 3 * * ? *)"

default_tags = {
  Terraform   = "true"
  Environment = "prod"
  Owner       = "your_name"
  # Add more tags as necessary
}


