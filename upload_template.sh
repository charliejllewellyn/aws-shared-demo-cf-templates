#!/bin/bash

profile=$1
filename=$2
helptext="$0 <profile> <filename>\n\ne.g. $0 demoAccount vpc/vpc-1.yaml"

if [ -z $profile ]; then
    echo -e "\nPlease provide a profile name for the account.\n\n${helptext}\n"
    exit 1
elif [ -z $filename ]; then
    echo -e "\nPlease provide a profile name for the account.\n\n${helptext}\n"
    exit 1
elif [ $filename == "all" ]; then
    filelist=$(find . -type f -iname '*.yaml' | sed 's/^\.\///g')
    for file in ${filelist[@]}; do
        aws s3 cp $file s3://aws-shared-demo-cf-templates/$file --profile $profile --acl public-read
    done
else
    aws s3 cp $filename s3://aws-shared-demo-cf-templates/$filename --profile $profile --acl public-read
fi
