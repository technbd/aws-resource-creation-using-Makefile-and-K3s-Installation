
## INSTRUCTIONS: AWS-resource-creation-using-Makefile-and-K3s-Installation:


### Installing AWS and Terraform CLI:
To install AWS CLI and Terraform CLI on your system, run: 

```
bash aws-tf-cli-install.sh
```


### Provide AWS credentials:
Your credentials will look like this:

- Access key ID: AKIAIOSFODNN7EXXXX
- Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEcxxx

```
aws configure 

AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]:
```


## Create AWS Resources using Makefile:
To create AWS resources using a Makefile, you can define targets in the Makefile, each corresponding to a specific AWS resource creation command. Enter the "makefile" directory and follow the README file. 

```
cd makefile
```


### Login EC2 Instance:

```
chmod 400 "web_key.pem"
```


```
ssh -i "web_key.pem" user_name@<ec2_public_ip>
ssh -i "web_key.pem" ubuntu@<ec2_public_ip>
```


## Install K3s:
To install K3s, you can use the installation script provided by Rancher Labs. Enter the "k3s-install" directory and follow the README file. 

```
cd k3s-install
```




## Webapps:
Enter the "webapps" directory and follow the README file.

```
cd webapps
```


## Install Nginx LB:
 Configuring an Nginx Layer-7 load balancer to manage two services like api.example.com and blog.example.com involves several steps. Enter the "nginx-lb" directory and follow the README file.

 ```
 cd nginx-lb
 ```


