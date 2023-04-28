locals {
  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
  write_files = [
    {
      path        = "/etc/ast_unauth_req.py"
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${path.module}/scripts/unauth_req.py")
    },
    {
      path        = "/etc/ast_auth_req.py"
      permissions = "0644"
      owner       = "root:root"
      encoding    = "b64"
      content     = filebase64("${path.module}/scripts/auth_req.py")
    }
  ]
})}
  END
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "${local.name}-test-instance"

  ami                    = "ami-0c768662cc797cd75"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data              = local.cloud_config_config

  tags = local.tags
}

resource "aws_security_group" "bastion_sg" {
  name        = "${local.name}-bastion_sg"
  description = "Bastion SG"
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