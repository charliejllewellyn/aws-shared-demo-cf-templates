# Overview
This guide will walk you through creating a VPN between two sites to simulate creating a VPN between on-premise infrastructure and an AWS VPC.

<p align="center">
  <img width="300" src="https://github.com/charliejllewellyn/aws-service-demos/blob/master/vpn/images/vpn.png">
</p>

## Pre-reqs

### Required
You will need to have created a keypair prior to running the CloudFormation script. To setup a keypair follow the documentation [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html](here).

### Optional
A second AWS account allowing you to create two completly seperate environments.

# Deployment

## Fake on-premise environment
The first step will create a new VPC with two private subnets and two public subnets. The public subnets are attached to an Internet Gateway. It then deploys a Cisco CSR 1000v from the marketplace and attaches one interface to a public subnets and a second interface to a private subnet. The public interface is assigned an elastic IP address. A second instance is deployed for testing the VPN connection and is only attached to a private subnet.

### Deploy via the UI

EU (Ireland) | [![Launch AWS Security Workshop in eu-west-1](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/images/cloudformation-launch-stack-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=vpnOnPrem&templateURL=https://s3-eu-west-1.amazonaws.com/cjl-cloudformation-stack-templates/vpnDemo-onprem.yaml)

### Deploy via the CLI
```
aws cloudformation create-stack --stack-name vpnOnPrem --template-body file://vpn-demo.yaml --capabilities CAPABILITY_IAM
```

In order to complete the next part of the setup you will need the Elastic IP address assigned to the CSR.
```
aws cloudformation wait stack-create-complete --stack-name vpnOnPrem && aws cloudformation describe-stacks --stack-name vpnOnPrem --query Stacks[0].Outputs[0].OutputValue
```

Record the IP address as you will need it later.

## Create the AWS environment

*Note:* if you are using a second accound login into that account now

### Deploy via the UI

EU (Ireland) | [![Launch AWS Security Workshop in eu-west-1](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/images/cloudformation-launch-stack-button.png)](https://console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks/new?stackName=vpnAws&templateURL=https://s3-eu-west-1.amazonaws.com/cjl-cloudformation-stack-templates/vpnDemo-aws.yaml)

### Deploy via the CLI
```
aws cloudformation create-stack --stack-name vpnAws --template-body file://vpn-demo.yaml --capabilities CAPABILITY_IAM
```

In order to complete the next part of the setup you will need the Elastic IP address assigned to the CSR.
```
aws cloudformation wait stack-create-complete --stack-name vpnAws && aws cloudformation describe-stacks --stack-name vpnAws --query Stacks[0].Outputs[0].OutputValue
```

# Setup your AWS VPN

### Step 1 - Create a customer gateway

1. From within the AWS console open the VPC page.
1. Under *VPN connections* select *Customer Gateways* --> *Create Customer Gateway*
1. Enter the name "onprem" and the IP obtained above. Click *Create Customer Gateway*

### Step 2 - Create a virtual private gateway

1. Under *VPN connections* select *Virtual Private Gateways* --> *Create Virtual Private Gateway*
1. Enter the name "aws". Click *Create Virtual Private Gateway*
1. In the *Action* drop down select *Attach to VPC* and select the VPC *vpcDemo* and select *Yes, Attach*

### Step 3 - Create a VPN Connection

1. Click on *Create VPN Connection* and enter the following information:
  | Name | vpnDemo |
  | Virtual private gateway | The VPG created in the previous steps |
  | Customer Gateway ID | The VGW created in the previous steps |
  
  Leave all other values as default and click *Create VPN Connection*

### Step 4 - Download VPN Configuration

1. At the top of hte page click *Download VPN Configuration*
1. Select, Cisco, CSRv AMI, IOS 12.4+
1. Click *Download*
1. Open the downloaded file and replace "<interface_name/private_IP_on_outside_interface>" with "GigabitEthernet1"

# Setup the on-prem VPN

1. Login to the Cisco CSR 
1. Type *config term*
1. Paste the content of the updated router configuration from *Step 4*
1. Type *exit*
1. Type *write*
1. From your "AWS environment" select the *VPN Connection* and click *Tunnel Details*. Both tunnels should show as up.
