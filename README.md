# Overview
This repo contains a set of base scripts and demo solutions that build on these base scripts.

# Using the Cloudformation templates
The CloudFormation scripts are uploaded to the S3 bucket, s3://aws-shared-demo-cf-templates and can be accessed using the UrL:

```
https://s3-eu-west-1.amazonaws.com/aws-shared-demo-cf-templates/<folder>/<filename>
```
e.g.
```
https://s3-eu-west-1.amazonaws.com/aws-shared-demo-cf-templates/vpc/vpc-1.yaml
```

# Uploading new templates

*To upload a single template*
```
./upload_template.sh <profile> <filename>
```

e.g. 
```
./upload_template.sh demoAccount vpc/vpc-1.yaml
```

*To upload all yaml files*
```
./upload_template.sh policedemo all
```
