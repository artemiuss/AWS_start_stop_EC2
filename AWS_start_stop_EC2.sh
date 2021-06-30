#!/bin/bash

# Usage: AWS_start_stop_EC2.sh {start|stop}

# Define EC2 tags if needed
#EC2_TAGS=

case "$1" in
   start)
     #Get stopped EC2 instances
     EC2_STOPPED_INSTANCES=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped" "${EC2_TAGS[@]}" --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ') 
     if [ -n "$EC2_STOPPED_INSTANCES" ]
       then 
         echo "Starting EC2 instances: ${EC2_STOPPED_INSTANCES}"
         AWS_OUTPUT=$(aws ec2 start-instances --instance-ids ${EC2_STOPPED_INSTANCES})
         echo "${AWS_OUTPUT}"
       else 
         echo "There are no stopped EC2 instances"
     fi
     ;;     
   stop)
     #Get running EC2 instances
     EC2_RUNNING_INSTANCES=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" "${EC2_TAGS[@]}" --query "Reservations[].Instances[].[InstanceId]" --output text | tr '\n' ' ') 
     if [ -n "$EC2_RUNNING_INSTANCES" ]
       then 
         echo "Stopping EC2 instances: ${EC2_RUNNING_INSTANCES}"
         AWS_OUTPUT=$(aws ec2 stop-instances --instance-ids ${EC2_RUNNING_INSTANCES})
         echo "${AWS_OUTPUT}"         
       else
         echo "There are no running EC2 instances"
     fi
     ;;
   *)	 
     echo "Usage: {start|stop}"
     exit 1
     ;;
esac












