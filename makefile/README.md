
## Makefile:
To create an AWS VPC, subnet, internet gateway, route table, key pair, and security group using a Makefile, you can utilize the AWS CLI commands within the Makefile. Below is an example Makefile that demonstrates how you can achieve this:


### Install JQ:
JQ is a lightweight and powerful command-line tool designed specifically for working with JSON data in Linux environments. The jq is a command line based JSON processor that allows to transform, filter, slice, map, or perform other operations on JSON data.

```
apt install jq
```


### Create All Resources:
```
make create_all_resources
```


### Create ec2 instance:
```
make create_ec2_instances
```


### Delete ec2 instance:
```
make delete_ec2_instances
```


### Delete All Resources:
```
make delete_all_resources
```



Make sure you have the AWS CLI installed and configured with the necessary credentials and permissions to create these resources. Also, provide the appropriate trust policy document for the IAM role creation.


