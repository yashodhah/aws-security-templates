module "apigw" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "1.8.0"

  name             = "example-apigw"
  api_key_required = true
  api_key_name     = "example-api-key"
  api_key_value    = "my-api-key-value"
  protocol_type    = "HTTP"
  target           = "http://${module.alb.lb_dns_name}"
  tags             = {
    Environment = "dev"
    Terraform   = "true"
  }
}

data "aws_vpc_endpoint_service" "apigateway" {
  service_name = "com.amazonaws.us-east-1.execute-api"
}

resource "aws_vpc_endpoint" "apigateway" {
  vpc_id             = module.vpc.vpc_id
  service_name       = data.aws_vpc_endpoint_service.apigateway.service_name
  security_group_ids = [module.vpc.default_security_group_id]
  subnet_ids         = module.vpc.private_subnets
}