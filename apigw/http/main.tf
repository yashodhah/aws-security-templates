provider "aws" {
  region = local.region
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "ap-southeast-1"

  tags = {
    Example    = local.name
  }
}


module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "dev-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  # Disable creation of the domain name and API mapping
  create_domain_name = false

  # Disable creation of Route53 alias record(s) for the custom domain
  create_domain_records = false

  # Disable creation of the ACM certificate for the custom domain
  create_certificate = false

  # API
  body = templatefile("api.yaml", {
    example_function_arn = module.order_service_lambda_function.lambda_function_arn
  })

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  domain_name = var.domain_name

  # Access logs
  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
        integrationErrorMessage = "$context.integrationErrorMessage"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        stage                   = "$context.stage"
        status                  = "$context.status"
        error = {
          message      = "$context.error.message"
          responseType = "$context.error.responseType"
        }
        identity = {
          sourceIP = "$context.identity.sourceIp"
        }
        integration = {
          error             = "$context.integration.error"
          integrationStatus = "$context.integration.integrationStatus"
        }
      }
    })
  }

  authorizers = {
    cognito = {
      authorizer_type  = "JWT"
      identity_sources = ["$request.header.Authorization"]
      name             = "cognito"
      jwt_configuration = {
        audience = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
        issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
      }
    }
  }

  # Routes & Integration(s)
  routes = {
    "ANY /" = {
      detailed_metrics_enabled = false

      integration = {
        uri                    = module.order_service_lambda_function.lambda_function_arn
        payload_format_version = "2.0"
        timeout_milliseconds   = 12000
      }
    }

#     "GET /some-route-with-authorizer" = {
#       authorization_type = "JWT"
#       authorizer_key     = "cognito"
#
#       integration = {
#         uri                    = module.lambda_function.lambda_function_arn
#         payload_format_version = "2.0"
#       }
#     }

#     "GET /some-route-with-authorizer-and-scope" = {
#       authorization_type   = "JWT"
#       authorizer_key       = "cognito"
#       authorization_scopes = ["user.id", "user.email"]
#
#       integration = {
#         uri                    = module.lambda_function.lambda_function_arn
#         payload_format_version = "2.0"
#       }
#     }

    "$default" = {
      integration = {
        uri = module.order_service_lambda_function.lambda_function_arn
        tls_config = {
          server_name_to_verify = var.domain_name
        }

        response_parameters = [
          {
            status_code = 500
            mappings = {
              "append:header.header1" = "$context.requestId"
              "overwrite:statuscode"  = "403"
            }
          },
          {
            status_code = 404
            mappings = {
              "append:header.error" = "$stageVariables.environmentId"
            }
          }
        ]
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


################################################################################
# Supporting Resources
################################################################################

module "order_service_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = "order-function"
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  description   = "AWS Lambda function for order service"
  publish       = true

  source_path = "${path.module}/../src/order-service"

  environment_variables = {
    ENVIRONMENT = "dev"
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  tags = local.tags
}

resource "aws_cognito_user_pool" "this" {
  name = local.name
  tags = local.tags
}

