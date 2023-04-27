data "terraform_remote_state" "core" {
  backend = "local"

  config = {
    path = "../base-model/terraform.tfstate"
  }
}
