resource "aws_api_gateway_rest_api" "sqs_access" {
  name        = "SQS API GW"
  description = "Gateway fronting an SQS queue for secure internet exposure"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_resource" "sqs_resource" {
  rest_api_id = aws_api_gateway_rest_api.sqs_access.id
  parent_id   = aws_api_gateway_rest_api.sqs_access.root_resource_id
  path_part   = "{foo}"
}


resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.sqs_access.id
  resource_id   = aws_api_gateway_resource.sqs_resource.id
  http_method   = "POST"
  authorization = "NONE"
}



resource "aws_api_gateway_integration" "sqs_integration" {
  type                    = "AWS"
  resource_id             = aws_api_gateway_resource.sqs_resource.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  rest_api_id             = aws_api_gateway_rest_api.sqs_access.id
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
  uri                     = "arn:aws:apigateway:${var.region}:sqs:path/${aws_sqs_queue.terraform_queue.name}"
  credentials             = aws_iam_role.sqs_access_role.arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$input.body"
  }
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.sqs_access.id
  resource_id = aws_api_gateway_resource.sqs_resource.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
}


resource "aws_api_gateway_integration_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.sqs_access.id
  resource_id = aws_api_gateway_resource.sqs_resource.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [aws_api_gateway_integration.sqs_integration]
}


resource "aws_api_gateway_stage" "v1" {
  deployment_id = aws_api_gateway_deployment.sqs_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sqs_access.id
  stage_name    = var.stage
}


resource "aws_api_gateway_deployment" "sqs_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sqs_access.id

  triggers = {
    redeployment = sha1(jsonencode(var.stage))
  }

  lifecycle {
    create_before_destroy = true
  }
}