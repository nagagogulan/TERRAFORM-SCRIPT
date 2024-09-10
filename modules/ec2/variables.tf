variable "env_name" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Jenkins server instance type"
  type        = string
}


variable "bastion_instance_type" {
  description = "Bastion server instance type"
  type        = string
}

variable "bastion_sgs" {
  description = "Bastion security group ids"
  type        = list(string)
}

variable "jekins_sgs" {
  description = "Jenkins security group ids"
  type        = list(string)
}

variable "bastion_subnet_id" {
  description = "VPC subnet ids for bastion"
  type        = string
}

variable "jenkins_subnet_id" {
  description = "VPC subnet ids for jenkins"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Tags"
  type        = map(string)
}

variable "jenkins_ecr_instance_profile_name" {
  description = "Iam role for ecr"
  type        = string
}