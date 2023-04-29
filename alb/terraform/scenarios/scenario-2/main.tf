locals {
  name = "scn-2"
  tags = {
    environment = "dev"
    scenario    = "2"
    terraform   = "true"
  }
}

# establishing peering between VPC
resource "aws_vpc_peering_connection" "peering_connection" {
  peer_vpc_id = data.terraform_remote_state.core.outputs.core_vpc_id
  vpc_id      = data.terraform_remote_state.core.outputs.ext_vpc_id
  auto_accept = true
  tags        = local.tags
}

resource "aws_route" "core_service_route" {
  for_each = toset(data.terraform_remote_state.core.outputs.core_vpc_private_rt_tbl_ids)

  route_table_id            = each.key
  destination_cidr_block    = data.terraform_remote_state.core.outputs.ext_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

resource "aws_route" "ext_service_route" {
  for_each = toset(data.terraform_remote_state.core.outputs.ext_vpc_public_rt_tbl_ids)

  route_table_id            = each.key
  destination_cidr_block    = data.terraform_remote_state.core.outputs.core_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering_connection.id
}

# registering order service as a target
#TODO may be can remove duplication while maintain the clarity
module "order_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.13.0"

  function_name = "order-service-lambda"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  description   = "AWS Lambda function for order service"

  source_path = "../../../scenario-2/order-service"

  environment_variables = {
    ENVIRONMENT  = "dev"
    USER_POOL_ID = data.terraform_remote_state.core.outputs.core_cognito_user_pool_id
    CLIENT_ID    = data.terraform_remote_state.core.outputs.core_cognito_user_pool_client_id
    SCOPE        = "order-resource-server/order:read"
  }

  tags = local.tags
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = module.order_service_lambda.lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.lambda_tg.arn
}

resource "aws_lb_target_group" "lambda_tg" {
  name        = "order-service-lambda-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.lambda_tg.arn
  target_id        = module.order_service_lambda.lambda_function_arn
  depends_on       = [aws_lambda_permission.with_lb]
}

resource "aws_lb_listener" "http_listner" {
  load_balancer_arn = data.terraform_remote_state.core.outputs.core_internal_alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lambda_tg.arn
    type             = "forward"
  }
}