Lambda Function for Managing EC2 Instances
This repository contains code for a Lambda function written in Python that manages EC2 instances and triggers actions based on certain conditions. It includes Terraform configuration files to deploy and manage the infrastructure required for the Lambda function.

Lambda Function (handler.py)
The handler.py file contains the Python code for the Lambda function. The function performs the following tasks:

Retrieves EC2 instances with the name "openvpn."
Checks if there are multiple instances with the name "openvpn."
Sends an SNS notification if multiple instances are detected.
Lambda Function Configuration
Runtime: Python 3.8
Timeout: 60 seconds
Environment Variables:
sns_topic_arn: ARN of the SNS topic for notifications.
Terraform Configuration
The Terraform configuration files (backend.tf, maint.tf, outputs.tf, variables.tf, terraform.tfvars) are used to deploy and manage the infrastructure required for the Lambda function.

Terraform Files
backend.tf: Configuration for Terraform backend to store state files.
maint.tf: Main Terraform configuration including IAM roles, policies, SNS topic, Lambda function, CloudWatch event rule, and permissions.
outputs.tf: Defines output values for the deployed resources.
variables.tf: Defines input variables used in the Terraform configuration.
terraform.tfvars: Provides values for the input variables.
Input Variables
region: AWS region to deploy resources.
account_id: AWS account ID.
sns_topic_arn: ARN of the SNS topic for notifications.
default_tags: Default tags for all resources.
cron_schedule: Cron schedule for the CloudWatch event rule.
lambda_function_name: Name of the Lambda function.
Deployment
To deploy the Lambda function and associated resources:

Ensure you have AWS credentials configured with appropriate permissions.
Modify the terraform.tfvars file with your desired values.
Run terraform init, terraform plan, and terraform apply commands to initialize, plan, and apply the Terraform configuration, respectively.