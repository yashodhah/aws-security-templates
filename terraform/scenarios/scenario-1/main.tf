##TODO : change this structure of locals
locals {
  name = "core-service"
  tags = {
    environment = "dev"
    terraform   = "true"
    scenario    = "1"
  }
}

module "order_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.13.0"

  function_name = "order-service-lambda"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  description   = "AWS Lambda function for order service"

  source_path = "../../../scenario-1/order-service"

  environment_variables = {
    ENVIRONMENT = "dev"
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
