resource "aws_apigatewayv2_api" "api_gw" {
  name          = "${local.name}=apigw"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "alb_integrations" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = "http://${module.alb.lb_dns_name}"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "gateway_service_a_route" {
  api_id    = aws_apigatewayv2_api.api_gw.id
  route_key = "POST /service-a"

  target = "integrations/${aws_apigatewayv2_integration.alb_integrations.id}"
}

#data "aws_vpc_endpoint_service" "apigateway" {
#  service_name = "com.amazonaws.us-east-1.execute-api"
#}
#
#resource "aws_vpc_endpoint" "apigateway" {
#  vpc_id             = module.vpc.vpc_id
#  service_name       = data.aws_vpc_endpoint_service.apigateway.service_name
#  security_group_ids = [module.vpc.default_security_group_id]
#  subnet_ids         = module.vpc.private_subnets
#}