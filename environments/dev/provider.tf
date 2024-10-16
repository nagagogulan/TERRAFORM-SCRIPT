terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {                           # Add the local provider
      source = "hashicorp/local"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region                   # Ensure this is set to the correct region for your S3 bucket
}

# Add the Local provider
provider "local" {}                     # Declare the local provider
