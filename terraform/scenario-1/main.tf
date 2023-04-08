module "order_service_lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "3.3.0"

  function_name = "order-service-lambda"
  runtime       = "java11"
  handler       = "io.quarkus.amazon.lambda.runtime.QuarkusStreamHandler::handleRequest"
  description   = "AWS Lambda function for order service"
  memory_size   = 256
  timeout       = 30

  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  source_path = "${path.module}/../../order-service/target/function.zip"

  environment_variables = {
    ENVIRONMENT = "dev"
  }

  tags = {
    Environment = "dev"
  }

  filename = "order-service-lambda.zip"
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

  source_path = "${path.module}/../../config-service/target/function.zip"

  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]

  environment_variables = {
    ENVIRONMENT = "dev"
  }

  tags = {
    Environment = "dev"
  }

  filename = "config-service-lambda.zip"
}