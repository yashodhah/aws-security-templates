module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.2.0"

  name            = "${local.name}-LB"
  vpc_id          = module.vpc.vpc_id
#  internal        = true
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb_sg.id]

  #  access_logs = {
  #    bucket = aws_s3_bucket.log_bucket.id
  #  }

  target_groups = [
    {
      target_type = "lambda"
      targets     = {
        lambda_with_allowed_triggers = {
          target_id = module.order_service_lambda_alias.lambda_alias_arn
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      #      path               = "api/service-b/order-service"
      target_group_index = 0
    }
  ]

  tags = local.tags
}

resource "aws_security_group" "alb_sg" {
  name        = "${local.name}-alb_sg"
  description = "ALB SG"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all to VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
