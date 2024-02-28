import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    sns = boto3.client('sns')
    
    # Retrieve the EC2 instance ID and SNS Topic ARN from environment variables
    instance_id = os.environ['instance_id']
    sns_topic_arn = os.environ['sns_topic_arn']
    
    try:
        # Reboot the EC2 instance directly
        ec2.reboot_instances(InstanceIds=[instance_id])
        
        # Send an SNS notification
        sns.publish(
            TopicArn=sns_topic_arn,
            Message=f'EC2 instance {instance_id} has been rebooted.',
            Subject='EC2 Reboot Notification'
        )
        return {
            'statusCode': 200,
            'body': f'EC2 instance {instance_id} has been rebooted and SNS notification sent.'
        }
        
    except Exception as e:
        print(f"Error: {e}")
        raise e  # Raising the exception will ensure that it gets logged in CloudWatch
