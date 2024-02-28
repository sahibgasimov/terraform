/* module "lambda_ec2_reboot" {
  source       = "./lambda_ec2_reboot" # adjust the path to where you've stored the module
  region       = "us-east-2"
  account_id   = ""
  instance_id  = ""
  sns_topic_arn = ""
} */

# You can then access the outputs like this:
/* output "created_lambda_role_arn" {
  value = module.lambda_ec2_reboot.lambda_role_arn
} */
