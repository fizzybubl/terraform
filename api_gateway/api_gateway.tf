resource "aws_api_gateway_rest_api" "example" {
 name = "SQS API GW"
 description = "Gateway fronting an SQS queue for secure internet exposure"
}


resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "example"
}


resource "aws_api_gateway_integration" "sqs_integration" {
    type = "AWS"
    resource_id = aws_api_gateway_rest_api.example.id
    http_method = "POST"
    rest_api_id = aws_api_gateway_rest_api.example.id
}