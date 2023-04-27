output "external_vpc_id" {
  value       = module.vpc.vpc_id
}

output "external_vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
}

output "external_vpc_public_route_table_ids" {
  value       = module.vpc.public_route_table_ids
}