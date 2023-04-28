module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.5.0"

  name                 = "${local.name}-vpc"
  cidr                 = "192.168.0.0/16"
  azs                  = ["ap-south-1a", "ap-south-1b"]
  private_subnets      = ["192.168.1.0/24", "192.168.2.0/24"]
  public_subnets       = ["192.168.101.0/24", "192.168.102.0/24"]
  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}