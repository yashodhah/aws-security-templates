output "http_tcp_listener_arns" {
  value = module.alb.http_tcp_listener_arns
}

output "core_vpc_id" {
  value = module.vpc.vpc_id
}

output "core_vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "core_vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "core_internal_alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "core_internal_alb_arn" {
  value = module.alb.lb_arn
}

output "core_vpc_private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "core_cognito_domain_name" {
  value = aws_cognito_user_pool_domain.pool_domain.domain
}

output "core_cognito_user_pool" {
  value = aws_cognito_user_pool.pool
}

output "core_cognito_user_pool_client" {
  value = aws_cognito_user_pool_client.user_pool_client
}
