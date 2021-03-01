#/bin/bash

# Issue temporary AWS credentials using STS assume role
echo "Assuming role to $1"
target_role=$(aws sts assume-role --role-arn $1 --role-session-name "terraform-search-infra-study-${hostname}")

# Export temporary AWS keys
export AWS_ACCESS_KEY_ID=$(echo $target_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $target_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $target_role | jq -r .Credentials.SessionToken)

echo "Succeed to assume role to $1"

# Setup new prompt for your terminal
export PS1="\e[1;33m\]AWS_DEV_ACCOUNT] \[\e[m\]\w]$"
bash
