locals {
  name = "core-service"
  tags = {
    environment = "dev"
    terraform   = "true"
  }
}

module "order_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "4.13.0"

  function_name = "order-service-lambda"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  description   = "AWS Lambda function for order service"

  source_path = "${path.module}/../../../${var.source_root}/order-service"

  environment_variables = {
    ENVIRONMENT = "dev"
    USER_POOL_ID= aws_cognito_user_pool.pool.id
    CLIENT_ID = aws_cognito_user_pool_client.user_pool_client.id
  }

  tags = local.tags
}

module "order_service_lambda_alias" {
  source        = "terraform-aws-modules/lambda/aws//modules/alias"
  refresh_alias = false

  name = "order-Service_lambda_alias"

  function_name    = module.order_service_lambda.lambda_function_name
  function_version = module.order_service_lambda.lambda_function_version

  allowed_triggers = {
    AllowExecutionFromELB = {
      service    = "elasticloadbalancing"
      source_arn = module.alb.target_group_arns[0]
    }
  }
}