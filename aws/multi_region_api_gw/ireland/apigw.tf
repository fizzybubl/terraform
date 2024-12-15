resource "aws_api_gateway_rest_api" "apigateway" {
  name = "API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_rest_api.apigateway.id
  path_part   = "{foo}"
}


resource "aws_api_gateway_method" "http_method" {
  http_method   = "POST"
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.resource.id
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "name" {
  http_method = "POST"
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.resource.id
  status_code = "201"
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id

  triggers = {
    redeployment = sha1(jsonencode([

    ]))
  }
}


resource "aws_api_gateway_stage" "name" {
  stage_name    = "Name"
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}


resource "aws_api_gateway_integration" "name" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  http_method = aws_api_gateway_method.http_method.id
  resource_id = aws_api_gateway_resource.resource.id

  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.apigw_lambda.invoke_arn
}


resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.apigw_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/*/*"
}