resource "aws_apigatewayv2_api" "api_gw" {
  name          = "${local.name}-apigw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "alb_integrations" {
  api_id           = aws_apigatewayv2_api.api_gw.id
  integration_type = "HTTP_PROXY"
  integration_uri  = aws_lb_listener.http_listener.arn

  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.vpc_link.id

  request_parameters = {
    "overwrite:path" = "$request.path"
  }
}

resource "aws_apigatewayv2_route" "gateway_service_a_route" {
  api_id               = aws_apigatewayv2_api.api_gw.id
  authorizer_id        = aws_apigatewayv2_authorizer.jwt_auth.id
  authorization_type   = "JWT"
  authorization_scopes = ["order-resource-server/order:read"]
  route_key            = "ANY /order-service"
  target               = "integrations/${aws_apigatewayv2_integration.alb_integrations.id}"
}

resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "${local.name}-gateway-vpc-link"
  security_group_ids = [aws_security_group.gateway_vpc_link_sg.id]
  subnet_ids         = data.terraform_remote_state.core.outputs.core_vpc_private_subnets
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
    audience = [data.terraform_remote_state.core.outputs.core_cognito_user_pool_client_id]
    issuer   = "https://cognito-idp.ap-south-1.amazonaws.com/${data.terraform_remote_state.core.outputs.core_cognito_user_pool_id}"
  }
}

resource "aws_security_group" "gateway_vpc_link_sg" {
  name        = "gateway_vpc_link_sg"
  description = "gateway_vpc_link_sg"
  vpc_id      = data.terraform_remote_state.core.outputs.core_vpc_id

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




