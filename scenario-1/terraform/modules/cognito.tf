# Configure User Pool
resource "aws_cognito_user_pool" "example" {
  name = "example-user-pool"

  # Define App Client
  app_client {
    name = "example-client"
    generate_secret = true
    allowed_oauth_flows = ["client_credentials"]
    allowed_oauth_scopes = ["example-scope"]
  }
}

# Define Resource Server
resource "aws_cognito_user_pool_resource_server" "example" {
  user_pool_id = aws_cognito_user_pool.example.id
  identifier = "example-resource-server"
  name = "Example Resource Server"
}

# Define Client Scope
resource "aws_cognito_user_pool_client_scope" "example" {
  name = "example-scope"
  user_pool_id = aws_cognito_user_pool.example.id
  scope_description = "Example Scope Description"
}

# Attach Client Scope to Resource Server
resource "aws_cognito_user_pool_resource_server_scope_attachment" "example" {
  resource_server_id = aws_cognito_user_pool_resource_server.example.id
  scope_name = aws_cognito_user_pool_client_scope.example.name
}
