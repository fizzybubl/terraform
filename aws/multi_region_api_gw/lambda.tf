resource "aws_iam_role" "lambda_exec" {
  name = "iam_for_lambda"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}



data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/files/lambda.py"
  output_path = "lambda_function_payload.zip"
}


resource "aws_lambda_function" "apigw_lambda" {
  filename      = "lambda_function_payload.zip"
  function_name = "apigw_lambda"
  handler       = "lambda.py"
  role          = aws_iam_role.lambda_exec.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


# resource "aws_cloudwatch_log_group" "apigw_lambda" {
#   name = "/aws/lambda/${aws_lambda_function.apigw_lambda.function_name}"
#   retention_in_days = 1
# }
