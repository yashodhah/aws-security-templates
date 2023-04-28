output "order_service_invoke_url" {
  value = "${aws_apigatewayv2_stage.apigw_stage.invoke_url}/order-service"
}