locals {
  name = "service-b"
  tags = {
    environment = "dev"
    terraform   = "true"
  }
}

module "order_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.0"

  function_name = "order-service-lambda"
  runtime       = "java11"
  handler       = "io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest"
  description   = "AWS Lambda function for order service"
  memory_size   = 256
  timeout       = 30

  source_path = "${path.module}/../../../../order-service/target/function.zip"

  environment_variables = {
    ENVIRONMENT = "dev"
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

module "config_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.0"

  function_name = "config-service-lambda"
  runtime       = "java11"
  handler       = "io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest"
  description   = "AWS Lambda function for configuration service"
  memory_size   = 256
  timeout       = 30

  source_path = "${path.module}/../../../../config-service/target/function.zip"


  environment_variables = {
    ENVIRONMENT = "dev"
  }

  tags = local.tags
}

#module "config_service_lambda_alias" {
#  source        = "terraform-aws-modules/lambda/aws//modules/alias"
#  refresh_alias = false
#
#  name = "config_service_lambda_alias"
#
#  function_name    = module.config_service_lambda.lambda_function_name
#  function_version = module.config_service_lambda.lambda_function_version
#
#  allowed_triggers = {
#    AllowExecutionFromELB = {
#      service    = "elasticloadbalancing"
#      source_arn = module.alb.target_group_arns[0] # index should match the correct target_group
#    }
#  }
#}