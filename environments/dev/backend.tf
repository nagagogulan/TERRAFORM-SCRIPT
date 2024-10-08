terraform {
  backend "s3" {
    bucket  = "appxpaydev"
    profile = "default"
    region  = "ap-south-1"
    key     = "dev"
  }
}