#TODO : change this structure of locals
locals {
  name = "core-service"
  tags = {
    environment = "dev"
    terraform   = "true"
  }
}

module "core-service" {
  source = "../../core-service"
}