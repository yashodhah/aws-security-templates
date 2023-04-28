output "order_service_invoke_url" {
  value = "http://${data.terraform_remote_state.core.outputs.core_internal_alb_dns_name}/order-service"
}