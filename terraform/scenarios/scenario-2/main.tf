#TODO : change this structure of locals
locals {
  name = "core-service"
  tags = {
    environment = "dev"
    scenario    = "2"
    terraform   = "true"
  }
}

module "core-service" {
  source = "../../modules/core-service"

  name_pref   = "sc2"
  tags        = local.tags
  source_root = "scenario-2"
}

module "external-service" {
  source = "../../modules/external-service"
}

resource "aws_vpc_peering_connection" "peering_connection" {
  peer_vpc_id = module.core-service.core_vpc_id
  vpc_id      = module.external-service.external_vpc_id
  auto_accept = true
  tags        = local.tags
}