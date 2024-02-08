# Variables for VPC: 
# VPC_NAME = "web_vpc"
# VPC_CIDR = "10.0.0.0/16"

# Variables for Public Subnet: 
# SUBNET_NAME = "web_public_subnet_01"
# SUBNET_CIDR_BLOCK = "10.0.1.0/24"
# availability_zone = "us-east-1a"  # Replace with your desired availability zone

# Variables for Internet Gateway: 
# IGW_NAME = "igw_01"

# Variables for Route Table:
# ROUTE_TABLE_NAME = "public_rt_01"

# Variables for Security Group: 
# SECURITY_GROUP_NAME = "web_sg_01"
# SG_ALLOW_PORTS = 22 80 443 6443
# SG_DESCRIPTION = "My Security Group Description"

# Variables for Key Pair: 
KEY_PAIR_NAME = "web_key"

# Variables for EC2 Instance:
# INSTANCE_NAMES = Master Worker-1 Worker-2 Nginx_LB
# EC2_INSTANCE_TYPE = "t3.small"
# AMI_ID = "ami-0c7217cdde317cfec"  # Replace with your desired AMI ID

# resource Tagging Syntax:
# aws ec2 create-tags --resources <ResourceID> --tags Key=<Key>, value=<Value>


# Create Key-pair:
create_key_pair:
	@echo "Creating key pair...:"
	@aws ec2 create-key-pair --key-name $(KEY_PAIR_NAME) --output json | jq -r '.KeyMaterial' > web_key.pem
	@echo "Created key pair: $(KEY_PAIR_NAME).pem"

delete_key_pair:
	@echo "Key pair deleted:" $(KEY_PAIR_NAME)
	@aws ec2 delete-key-pair --key-name $(KEY_PAIR_NAME)
	@aws ec2 describe-key-pairs


# Create vpc:
VPC_NAME = "web_vpc"
VPC_CIDR = "10.0.0.0/16"

create_vpc:
	@echo "Creating VPC..."
	@vpc_id=$$(aws ec2 create-vpc --cidr-block $(VPC_CIDR) --output json | jq -r '.Vpc.VpcId'); \
	aws ec2 create-tags --resources $$vpc_id --tags Key=Name,Value=$(VPC_NAME); \
	echo "The VPC: $(VPC_NAME) and ID: $$vpc_id"


# Delete VPC:
delete_vpc:
	@echo "VPC deleting..."
	@vpc_id=$$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$(VPC_NAME)" --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	aws ec2 delete-vpc --vpc-id $$vpc_id; \
	echo "VPC: $(VPC_NAME) ID: $$vpc_id is deleted"


# Create subnet (public_subnet):
SUBNET_NAME = "web_public_subnet_01"
SUBNET_CIDR_BLOCK = "10.0.1.0/24"
availability_zone = "us-east-1a"  # Replace with your desired availability zone

create_subnet:
	@echo "Creating Public Subnet..."
	@vpc_id=$$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$(VPC_NAME)" --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	subnet_id=$$(aws ec2 create-subnet --vpc-id $$vpc_id --cidr-block $(SUBNET_CIDR_BLOCK) --availability-zone $(availability_zone) --output json | jq -r '.Subnet.SubnetId'); \
	aws ec2 create-tags --resources $$subnet_id --tags Key=Name,Value=$(SUBNET_NAME); \
	echo "Subnet: $(SUBNET_NAME) and ID: $$subnet_id"


# Delete subnet (public_subnet):
delete_subnet:
	@echo "Deleting Public Subnet..."
	@subnet_id=$$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$(SUBNET_NAME)" --query 'Subnets[0].SubnetId' --output json | jq -r '.'); \
	aws ec2 delete-subnet --subnet-id $$subnet_id; \
	echo "Subnet: $(SUBNET_NAME) and ID: $$subnet_id is deleted"


# Create subnet (private_subnet):

# Delete subnet (private_subnet):



# Create security-group (sg):
SECURITY_GROUP_NAME = "web_sg_01"
SG_ALLOW_PORTS = 22 80 443 6443
SG_DESCRIPTION = "My Security Group Description"


create_sg:
	@echo "Creating SG and Allow ports..."
	@vpc_id=$$(aws ec2 describe-vpcs --filters Name=tag:Name,Values=${VPC_NAME} --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	sg_id=$$(aws ec2 create-security-group --group-name $(SECURITY_GROUP_NAME) --description $(SG_DESCRIPTION) --vpc-id $$vpc_id --output json | jq -r '.GroupId'); \
	for port in $(SG_ALLOW_PORTS); do \
		aws ec2 authorize-security-group-ingress --group-id $$sg_id --protocol tcp --port $$port --cidr 0.0.0.0/0; \
	done; \
	echo "Security Group: $(SECURITY_GROUP_NAME) and ID: $$sg_id and allowed ports: $(SG_ALLOW_PORTS)"


# Delete security-group:
delete_sg:
	@echo "Deleting SG..."
	@sleep 60
	@sg_id=$$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$(SECURITY_GROUP_NAME)" --query 'SecurityGroups[0].GroupId' --output json | jq -r '.'); \
	aws ec2 delete-security-group --group-id $$sg_id; \
	echo "Security Group: $$sg_id is deleted"


# Create internet gateway (igw):
IGW_NAME = "web_igw_01"

create_igw:
	@echo "Creating Internet Gateway (igw)..."
	@igw_id=$$(aws ec2 create-internet-gateway --output json | jq -r '.InternetGateway.InternetGatewayId'); \
	aws ec2 create-tags --resources $$igw_id --tags Key=Name,Value=$(IGW_NAME); \
	echo "IGW: $(IGW_NAME) and ID: $$igw_id"

# Attach the Internet Gateway with the VPC:
igw_attach:
	@echo "IGW attach to VPC..."
	@igw_id=$$(aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_NAME)" --query 'InternetGateways[0].InternetGatewayId' --output json | jq -r '.'); \
	vpc_id=$$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$(VPC_NAME)" --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	aws ec2 attach-internet-gateway --internet-gateway-id $$igw_id --vpc-id $$vpc_id; \
	echo "IGW: $$igw_id Attached to VPC"

# To detach an internet gateway from your VPC:
igw_detach:
	@echo "Detach IGW from VPC..."
	@igw_id=$$(aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_NAME)" --query 'InternetGateways[0].InternetGatewayId' --output json | jq -r '.'); \
	vpc_id=$$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$(VPC_NAME)" --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	aws ec2 detach-internet-gateway --internet-gateway-id $$igw_id --vpc-id $$vpc_id; \
	echo "IGW: $$igw_id Detached from VPC"


# Delete internet gateway (igw): (First IGW Detach from VPC then delete IGW)
delete_igw:
	@echo "Deleting Internet Gateway..."
	@igw_id=$$(aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_NAME)" --query 'InternetGateways[0].InternetGatewayId' --output json | jq -r '.'); \
	aws ec2 delete-internet-gateway --internet-gateway-id $$igw_id; \
	echo "IGW: $(IGW_NAME) and ID: $$igw_id is deleted"




# Create route table:
ROUTE_TABLE_NAME = "public_rt_01"

create_route_table:
	@echo "Creating Public Route Table..."
	@vpc_id=$$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$(VPC_NAME)" --query 'Vpcs[0].VpcId' --output json | jq -r '.'); \
	route_table_id=$$(aws ec2 create-route-table --vpc-id $$vpc_id --output json | jq -r '.RouteTable.RouteTableId'); \
	aws ec2 create-tags --resources $$route_table_id --tags Key=Name,Value=$(ROUTE_TABLE_NAME); \
	echo "Route Table: $(ROUTE_TABLE_NAME) and ID: $$route_table_id"

# Delete route table:
delete_route_table:
	@echo "Delete Public Route Table..."
	@route_table_id=$$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$(ROUTE_TABLE_NAME)" --query 'RouteTables[0].RouteTableId' --output json | jq -r '.'); \
	aws ec2 delete-route-table --route-table-id $$route_table_id; \
	echo "Route Table: $(ROUTE_TABLE_NAME) and ID: $$route_table_id is deleted"


# Associate route table to public subnet:
associate_route_table_public_subnet:
	@echo "Associating Route Table to public subnet..."
	@subnet_id=$$(aws ec2 describe-subnets --filter Name=tag:Name,Values=$(SUBNET_NAME) --query 'Subnets[0].SubnetId' --output json | jq -r '.'); \
	route_table_id=$$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$(ROUTE_TABLE_NAME)" --query 'RouteTables[0].RouteTableId' --output json | jq -r '.'); \
	associate_route_id=$$(aws ec2 associate-route-table --route-table-id $$route_table_id --subnet-id $$subnet_id --query 'AssociationId' --output json | jq -r '.'); \
	echo "Subnet: $(SUBNET_NAME) associated to Route Table: $(ROUTE_TABLE_NAME) with ID: $$route_table_id" and Associate ID: $$associate_route_id


# To disassociate a route table from public subnet:
deassociate_route_table_public_subnet:
	@echo "Deassociating Route Table from public subnet..."
	@route_table_id=$$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$(ROUTE_TABLE_NAME)" --query 'RouteTables[0].RouteTableId' --output json | jq -r '.'); \
	associate_route_id=$$(aws ec2 describe-route-tables --route-table-ids $$route_table_id --query 'RouteTables[0].Associations[0].RouteTableAssociationId' --output json | jq -r '.'); \
	aws ec2 disassociate-route-table --association-id $$associate_route_id; \
	echo "Subnet $(SUBNET_NAME) deassociated from Route Table: $(ROUTE_TABLE_NAME) with ID: $$route_table_id and disassociate ID: $$associate_route_id"


# Create a route to the Internet Gateway in the route table (for public subnet):
create_route_to_igw:
	@echo "Creating Route attach to Internet Gateway for public subnet..."
	@route_table_id=$$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$(ROUTE_TABLE_NAME)" --query 'RouteTables[0].RouteTableId' --output json | jq -r '.'); \
	igw_id=$$(aws ec2 describe-internet-gateways --filter "Name=tag:Name,Values=$(IGW_NAME)" --query 'InternetGateways[0].InternetGatewayId' --output json | jq -r '.'); \
	aws ec2 create-route --route-table-id $$route_table_id --destination-cidr-block 0.0.0.0/0 --gateway-id $$igw_id; \
	echo "Created Route attach to Internet Gateway: $$igw_id and Route Table: $(ROUTE_TABLE_NAME) with ID: $$route_table_id"

# Delete Route (for public subnet):
delete_route_to_igw:
	@echo "Deleting Route detach from Internet Gateway for public subnet..."
	@route_table_id=$$(aws ec2 describe-route-tables --filters "Name=tag:Name,Values=$(ROUTE_TABLE_NAME)" --query 'RouteTables[0].RouteTableId' --output json | jq -r '.'); \
	aws ec2 delete-route --route-table-id $$route_table_id --destination-cidr-block 0.0.0.0/0; \
	echo "Route detach from Internet Gateway and Route Table: $(ROUTE_TABLE_NAME) with ID: $$route_table_id is deleted"




# Run ec2 instance:
INSTANCE_NAMES = master worker1 worker2 nginx_lb
EC2_INSTANCE_TYPE = "t3.small"
AMI_ID = "ami-0c7217cdde317cfec" 

create_ec2_instances:
	@echo "Creating Multiple EC2 Instances..."
	@subnet_id=$$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$(SUBNET_NAME)" --query 'Subnets[0].SubnetId' --output json | jq -r '.'); \
	sg_id=$$(aws ec2 describe-security-groups --filters "Name=group-name,Values=$(SECURITY_GROUP_NAME)" --query 'SecurityGroups[0].GroupId' --output json | jq -r '.'); \
	key_pair_name=$$(aws ec2 describe-key-pairs --key-names $(KEY_PAIR_NAME) --query 'KeyPairs[0].KeyName' --output json | jq -r '.'); \
	for instance_name in $(INSTANCE_NAMES); \
	do \
		aws ec2 run-instances \
		--image-id $(AMI_ID) \
		--instance-type $(EC2_INSTANCE_TYPE) \
		--subnet-id $$subnet_id \
		--key-name $$key_pair_name \
		--security-group-ids $$sg_id \
		--associate-public-ip-address \
		--count 1 \
		--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='$$instance_name'}]'; \
	done;
	@echo "EC2 Instances created: $(INSTANCE_NAMES) and $(SUBNET_NAME)"
	@aws ec2 describe-instances | grep -i value


# Delete ec2 instances:
delete_ec2_instances:
	@echo "Deleting EC2 Instances..."
	@for instance_name in $(INSTANCE_NAMES); \
	do \
		instance_id=$$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$$instance_name" --query 'Reservations[*].Instances[?State.Name==`running`].InstanceId' --output json | jq -r '.[][]'); \
		if [ ! -z "$$instance_id" ]; then \
			aws ec2 terminate-instances --instance-ids $$instance_id; \
			echo "EC2 Instance $$instance_name is terminated"; \
		else \
			echo "EC2 Instance $$instance_name id not found"; \
		fi; \
	done;
	@echo "EC2 Instances: $(INSTANCE_NAMES) is Deleted"




# Create All Resources:
create_all_resources: create_key_pair create_vpc create_subnet create_sg create_igw igw_attach create_route_table associate_route_table_public_subnet create_route_to_igw 
	@echo "All resources created done..."


# Delete All Resources:
delete_all_resources: delete_key_pair delete_sg delete_route_to_igw deassociate_route_table_public_subnet delete_route_table igw_detach delete_igw delete_subnet delete_vpc
	@echo "All resources deleted done..."



