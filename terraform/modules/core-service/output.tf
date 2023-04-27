output "http_tcp_listener_arns" {
  value       = module.alb.http_tcp_listener_arns
  description = "HTTP/TCP listener arns"
}

output "core_vpc_id" {
  value       = module.vpc.vpc_id
  description = "Core VPC ID"
}

output "core_vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "Core VPC CIDR"
}

output "core_vpc_private_subnets" {
  value       = module.vpc.private_subnets
  description = "Core VPC private subnets"
}

output "core_internal_alb_dns_name" {
  value       = module.alb.lb_dns_name
  description = "core_internal_alb_domain_name"
}

output "core_internal_alb_arn" {
  value       = module.alb.lb_arn
  description = "core_internal_alb_arn"
}

output "core_vpc_private_route_table_ids" {
  value       = module.vpc.private_route_table_ids
  description = "Core VPC private route table ids"
}

output "core_cognito_domain_name" {
  value       = aws_cognito_user_pool_domain.pool_domain.domain
  description = "core_cognito_domain_name"
}

output "core_cognito_user_pool" {
  value       = aws_cognito_user_pool.pool
  description = "Core VPC private subnets"
}

output "core_cognito_user_pool_client" {
  value       = aws_cognito_user_pool_client.user_pool_client
  description = "Core VPC private subnets"
}
