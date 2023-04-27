output "external_vpc_id" {
  value       = module.vpc.vpc_id
  description = "External VPC ID"
}

output "external_vpc_cidr_block" {
  value       = module.vpc.vpc_cidr_block
  description = "External VPC CIDR block"
}

output "external_vpc_public_route_table_ids" {
  value       = module.vpc.public_route_table_ids
  description = "External VPC public route table Ids"
}