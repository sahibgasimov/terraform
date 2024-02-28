# #!/bin/bash
# # sudo apt-get install awscli
# INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# MAXWAIT=3
# ALLOC_ID=eipalloc-01146cbda91a9a197
# AWS_DEFAULT_REGION=us-east-1

# # Make sure the EIP is free
# echo "Checking if EIP with ALLOC_ID[$ALLOC_ID] is free...."
# ISFREE=$(aws ec2 describe-addresses --allocation-ids $ALLOC_ID --query Addresses[].InstanceId --output text)
# STARTWAIT=$(date +%s)
# while [ ! -z "$ISFREE" ]; do
#     if [ "$(($(date +%s) - $STARTWAIT))" -gt $MAXWAIT ]; then
#         echo "WARNING: We waited 30 seconds, we're forcing it now."
#         ISFREE=""
#     else
#         echo "Waiting for EIP with ALLOC_ID[$ALLOC_ID] to become free...."
#         sleep 3
#         ISFREE=$(aws ec2 describe-addresses --allocation-ids $ALLOC_ID --query Addresses[].InstanceId --output text)
#     fi
# done

# # Now we can associate the address
# echo Running: aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $ALLOC_ID --allow-reassociation}
# aws ec2 associate-address --instance-id $INSTANCE_ID --allocation-id $ALLOC_ID --allow-reassociation}