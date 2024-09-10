module "app_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                         = "${var.env_name}-vpc"
  cidr                         = var.vpc_cidr
  azs                          = var.availability_zones
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  enable_nat_gateway           = var.enable_nat_gateway
  enable_ipv6                  = true
  single_nat_gateway           = var.single_nat_gateway
  public_subnet_ipv6_prefixes  = var.public_subnet_ipv6_prefixes
  private_subnet_ipv6_prefixes = var.private_subnet_ipv6_prefixes
  one_nat_gateway_per_az       = var.one_nat_gateway_per_az

  tags = var.common_tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.app_vpc.vpc_id
  service_name = "com.amazonaws.${var.region_name}.s3"
  tags         = merge(var.common_tags, { Name = "${var.env_name}-s3-vpce" })
}


resource "aws_network_acl" "nacl" {
  vpc_id = module.app_vpc.vpc_id

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = 80
    to_port    = 80
  }

  tags = var.common_tags
}

