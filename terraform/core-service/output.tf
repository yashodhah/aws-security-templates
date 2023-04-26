output "http_tcp_listener_arns" {
  value       = module.alb.http_tcp_listener_arns
  description = "HTTP/TCP listener arns"
}

output "core_vpc_id" {
  value       = module.vpc.id
  description = "Core VPC ID"
}

output "core_vpc_private_subnets" {
  value       = module.vpc.private_subnets
  description = "Core VPC private subnets"
}

output "core_cognito_user_pool" {
  value       = aws_cognito_user_pool.pool
  description = "Core VPC private subnets"
}

output "core_cognito_user_pool_client" {
  value       = aws_cognito_user_pool_client.user_pool_client
  description = "Core VPC private subnets"
}
