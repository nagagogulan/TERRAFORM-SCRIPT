terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {                           
      source = "hashicorp/local"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region                  
}

# Add the Local provider
provider "local" {}                     
