import os
import boto3

def lambda_handler(event, context):
    # Initialize AWS clients
    ec2_client = boto3.client('ec2')
    sns_client = boto3.client('sns')

    # Retrieve all instances with the name "openvpn"
    response = ec2_client.describe_instances(Filters=[{'Name': 'tag:Name', 'Values': ['openvpn']}])
    instances = [i for r in response['Reservations'] for i in r['Instances']]
    
    # Check if there are more than one instance with the name "openvpn"
    if len(instances) > 1:
        # Define subject and message for SNS notification
        subject = "Multiple OpenVPN Instances Detected"
        message = "There are more than one instance with the name 'openvpn'."
        
        # Publish alert to SNS topic with specified subject
        sns_client.publish(TopicArn=os.environ['sns_topic_arn'], Message=message, Subject=subject)
