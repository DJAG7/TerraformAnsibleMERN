# TerraformAnsibleMERN
Deployment of MERN on AWS with Terraform and Ansible


## Terraform Deployment of the Infrastructure

### Configure AWS CLI
  Enter the region, username and password
    ![image](https://github.com/DJAG7/TerraformAnsibleMERN/assets/146625559/9616bbd6-7b75-445a-ad23-4c6b71446ca0)

### Terraform Initialization
  - Download and run the executable in a directory.
  - Create main.tf file
  - Initially, only provide the main source code to download the AWS plugin
  #
    terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    }

    required_version = ">= 1.0"
    }

    provider "aws" {
      region = "eu-west-2"  
    }
   
  - download the aws provider plugin
 ![image](https://github.com/DJAG7/TerraformAnsibleMERN/assets/146625559/2fcff566-7aec-4535-9afc-72ecec187135)

### Terraform TF Configuration
  - Make the full configuration for the AWS configuration as seen in the main.tf file
  - Save and run terraform plan [TF Plan](https://github.com/DJAG7/TerraformAnsibleMERN/blob/main/terraform%20plan%20log.txt)
  - Run terraform apply, and enter yes
  - Wait for the configuration to run
    
   
  [ ![main.tf](main.tf)](https://github.com/DJAG7/TerraformAnsibleMERN/blob/main/main.tf)

![image](https://github.com/DJAG7/TerraformAnsibleMERN/assets/146625559/4949b575-f3ea-4956-9fe7-b7c5a8e87ad5)

Terraform is complete
