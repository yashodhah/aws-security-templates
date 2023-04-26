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
  source      = "../../modules/core-service"

  name_pref = "sc2"
  tags = local.tags
  source_root = "scenario-2"
}