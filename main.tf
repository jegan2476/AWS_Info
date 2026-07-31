resource "aws_api_gateway_rest_api" "customer_api" {

  name = "CustomerAPI"

  body = file("${path.module}/openapi.yaml")
}

resource "aws_api_gateway_deployment" "customer" {

  rest_api_id = aws_api_gateway_rest_api.customer_api.id

  triggers = {
    redeployment = sha1(file("${path.module}/openapi.yaml"))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.customer_api
  ]
}

resource "aws_api_gateway_stage" "dev" {

  deployment_id = aws_api_gateway_deployment.customer.id

  rest_api_id = aws_api_gateway_rest_api.customer_api.id

  stage_name = "dev"
}
