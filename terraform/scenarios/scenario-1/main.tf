#TODO : change this structure of locals
locals {
  name = "core-service"
  tags = {
    environment = "dev"
    terraform   = "true"
    scenario    = "1"
  }
}

module "core-service" {
  source = "../../modules/core-service"

  name_pref         = "sc1"
  tags              = local.tags
  source_root       = "scenario-1"
}

module "external-service" {
  source      = "../../modules/external-service"
}