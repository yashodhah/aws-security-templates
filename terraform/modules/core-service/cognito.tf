resource "aws_cognito_user_pool" "pool" {
  name = "${local.name}-user-pool"
}

resource "aws_cognito_user_pool_domain" "pool_domain" {
  domain       = "${local.name}-sso"
  user_pool_id = aws_cognito_user_pool.pool.id
}

#TODO
resource "aws_cognito_resource_server" "resource" {
  identifier = "${local.name}-resource-serer"
  name       = "${local.name}-resource-server"

  scope {
    scope_name        = "order:read"
    scope_description = "Read access for order service"
  }

  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                                 = "${local.name}-user-pool-client"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  allowed_oauth_flows_user_pool_client = true
  generate_secret                      = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = aws_cognito_resource_server.resource.scope_identifiers
}

