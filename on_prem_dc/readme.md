# On Premise Data Centre Template.

## Overview
This cloudformation stack uses nested templates to deploy a cloud enviroment that can be used to mimic a customers on prem enviroment.  
This can then be used to demonstrate how AWS services can integrate with on premise enviroments such as creating an VPN to connect the two or extending an existing Active Directory into AWS.  
In the interest of frugality, simplicty and creation time the template doesnt build for a HA enviroment.  Resources are built in a single AZ and are not duplicated. This is delibrate as the purpose of the stack is to quickly create an "On Prem" enviroment to demonstrate our features.  It is not intended to demonstrate how to deploy a highly availble infrastructure on AWS.  
The features included are listed in the features section below feel free to add to these or reach out if you can think of something you would like to be included.

--- 
## On Prem Features

* Microsoft Active Directory Domain 
* Microsoft DNS server 
* Cisco ASA to terminate VPNs
* 1 Public Subnet with a NAT Gateway
* 1 Private Subnet
* A Single Microsoft Server 2016 EC2 Instance in the  private subnet
--- 
## Pre-Requisites

In order to use this template you must have:

* An AWS Account
* An IAM key pair that can be used to connect to the Windows Server
* An S3 Bucket to store the Template Files in.  This bucket must be readable by the person deploying the template.

---
## Instructions

1. Create an S3 Bucket for the template files.  Once the bucket is created upload all of the template files to it.
2. Within the cloudformation console click create stack and complete the required parameters
---