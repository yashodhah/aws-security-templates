output "core_vpc_id" {
  value = module.core-service.core_vpc_id
}

output "core_vpc_cidr_block" {
  value = module.core-service.core_vpc_cidr
}

output "core_vpc_private_subnets" {
  value = module.core-service.core_vpc_private_subnets
}

output "core_vpc_private_rt_tbl_ids" {
  value = module.core-service.core_vpc_private_route_table_ids
}

output "ext_vpc_id" {
  value = module.external-service.external_vpc_id
}

output "ext_vpc_cidr_block" {
  value = module.external-service.external_vpc_cidr_block
}

output "ext_vpc_public_rt_tbl_ids" {
  value = module.external-service.external_vpc_public_route_table_ids
}

output "core_cognito_user_pool_client_id" {
  value = module.core-service.core_cognito_user_pool_client["id"]
}

#This is only to make things simple. It's not a wise idea to display sensitive information on the console
output "core_cognito_user_pool_client_secret" {
  value = nonsensitive(module.core-service.core_cognito_user_pool_client["client_secret"])
}

output "core_cognito_user_pool_id" {
  value = module.core-service.core_cognito_user_pool["id"]
}

#TODO generalize region
output "core_cognito_token_endpoint" {
  value = "https://${module.core-service.core_cognito_domain_name}.auth.ap-south-1.amazoncognito.com/oauth2/token"
}

output "core_internal_alb_dns_name" {
  value = module.core-service.core_internal_alb_dns_name
}

output "core_internal_alb_arn" {
  value = module.core-service.core_internal_alb_arn
}