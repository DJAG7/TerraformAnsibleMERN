terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0"
}

# AWS Provider configuration
provider "aws" {
  region = "eu-west-2"  
}

# AWS VPC 
resource "aws_vpc" "danielterramern_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# AWS Subnets
resource "aws_subnet" "danielterramern_pub_subnet" {
  vpc_id                 = aws_vpc.danielterramern_vpc.id
  cidr_block             = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone      = "eu-west-2a"
}

resource "aws_subnet" "danielterramern_priv_subnet" {
  vpc_id                 = aws_vpc.danielterramern_vpc.id
  cidr_block             = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone      = "eu-west-2a"
}

# Internet Gateway
resource "aws_internet_gateway" "dmigw" {
  vpc_id = aws_vpc.danielterramern_vpc.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "dm_eip" {
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "dmnatgw" {
  allocation_id = aws_eip.dm_eip.id
  subnet_id     = aws_subnet.danielterramern_pub_subnet.id
}

# Route Tables
resource "aws_route_table" "dm_public_rt" {
  vpc_id = aws_vpc.danielterramern_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dmigw.id
  }
}

resource "aws_route_table" "dm_private_rt" {
  vpc_id = aws_vpc.danielterramern_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dmnatgw.id
  }
}

# Route Table Associations
resource "aws_route_table_association" "dm_public_rta" {
  subnet_id      = aws_subnet.danielterramern_pub_subnet.id
  route_table_id = aws_route_table.dm_public_rt.id
}

resource "aws_route_table_association" "dm_private_rta" {
  subnet_id      = aws_subnet.danielterramern_priv_subnet.id
  route_table_id = aws_route_table.dm_private_rt.id
}

# AWS EC2 Instances
resource "aws_instance" "web_server" {
  ami           = "ami-09627c82937ccdd6d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.danielterramern_pub_subnet.id
  key_name      = "your-key-pair-name"

  vpc_security_group_ids = [aws_security_group.dmweb_sg.id]
}

resource "aws_instance" "db_server" {
  ami           = "ami-09627c82937ccdd6d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.danielterramern_priv_subnet.id
  key_name      = "your-key-pair-name"

  vpc_security_group_ids = [aws_security_group.dmdb_sg.id]
}

# AWS Security Groups
resource "aws_security_group" "dmweb_sg" {
  vpc_id = aws_vpc.danielterramern_vpc.id

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dmdb_sg" {
  vpc_id = aws_vpc.danielterramern_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.dmweb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output
output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}
