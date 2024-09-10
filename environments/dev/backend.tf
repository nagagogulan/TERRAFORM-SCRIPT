terraform {
  backend "s3" {
    bucket  = "appxpay-tfstate-cidc"
    profile = "default"
    region  = "ap-south-1"
    key     = "dev"
  }
}