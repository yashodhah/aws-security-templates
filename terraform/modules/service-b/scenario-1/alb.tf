module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.2.0"

  name                  = "service-b-alb"
  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.public_subnets
  security_groups       = [module.vpc.default_security_group_id]
  enable_http2          = true
  access_logs_enabled   = false
  tags = {
    Environment = "dev"
  }
}