#!/bin/bash

accountList=$(aws organizations list-accounts --profile willb |  grep Id | awk '{print $2}' | sed 's/\"//g' | sed 's/\,//g')

count=0
accountDetails=()

for account in ${accountList[@]}; do
  if token=$(aws sts assume-role --role-arn arn:aws:iam::$account:role/OrganizationAccountAccessRole --role-session-name "RoleSession1" --profile willb &>/dev/null); then
    export AWS_ACCESS_KEY_ID=$(echo $token|jq ".Credentials.AccessKeyId" | sed 's/"//g')
    export AWS_SECRET_ACCESS_KEY=$(echo $token|jq ".Credentials.SecretAccessKey" | sed 's/"//g')
    export AWS_SESSION_TOKEN=$(echo $token|jq ".Credentials.SessionToken" | sed 's/"//g')
    user=user$count
    password=pa55w0rd$count
    aws iam create-user --user-name $user &>/dev/null
    aws iam create-login-profile --user-name user$count --password $password --no-password-reset-required &>/dev/null
    aws iam attach-user-policy --user-name $user --policy-arn arn:aws:iam::aws:policy/AdministratorAccess &>/dev/null
    accountDetails+=(https://$account.signin.aws.amazon.com/console $user $password)
    count=$(($count + 1))
  else
    echo "couldn't get a token for $account"
  fi
done

for account in ${accountDetails[@]}; do
  echo $account
done
