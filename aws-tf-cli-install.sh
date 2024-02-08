#!/bin/bash
# run: bash aws-tf-cli-install.sh

echo "aws cli..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip
sudo ./aws/install

aws --version

echo "done..."


echo "terraform cli..."
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip

sudo mv terraform /usr/local/bin

terraform -version

echo "done..."
