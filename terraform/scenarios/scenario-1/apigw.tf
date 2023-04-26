resource "aws_apigatewayv2_api" "api_gw" {
  name          = "${local.name}-apigw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "alb_integrations" {
  api_id           = aws_apigatewayv2_api.api_gw.id
  integration_type = "HTTP_PROXY"
  integration_uri  = module.core-service.http_tcp_listener_arns[0]

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id
}

resource "aws_apigatewayv2_route" "gateway_service_a_route" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  authorizer_id      = aws_apigatewayv2_authorizer.jwt_auth.id
  authorization_type = "JWT"
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.alb_integrations.id}"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${local.name}-gateway-vpc-link"
  security_group_ids = [aws_security_group.gateway_vpc_link_sg.id]
  subnet_ids         = module.core-service.core_vpc_private_subnets
  tags               = local.tags
}

resource "aws_apigatewayv2_stage" "apigw_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = "api"
  auto_deploy = true

  #  access_log_settings {
  #    destination_arn = aws_cloudwatch_log_group.this.arn
  #    format          = "JSON"
  #  }
}

resource "aws_apigatewayv2_authorizer" "jwt_auth" {
  api_id           = aws_apigatewayv2_api.api_gw.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "jwt-authorizer"
  jwt_configuration {
    audience = [module.core-service.core_cognito_user_pool_client["id"]]
    issuer   = "https://cognito-idp.ap-south-1.amazonaws.com/${module.core-service.core_cognito_user_pool["id"]}"
  }
}

resource "aws_security_group" "gateway_vpc_link_sg" {
  name        = "gateway_vpc_link_sg"
  description = "gateway_vpc_link_sg"
  vpc_id      = module.core-service.core_vpc_id

  ingress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}




