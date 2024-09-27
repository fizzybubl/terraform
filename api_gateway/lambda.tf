data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


data "aws_iam_policy" "sqs_access_lambda" {
    name = "AWSLambdaSQSQueueExecutionRole"
}


resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "sqs_policy" {
    policy = data.aws_iam_policy.sqs_access_lambda.policy
    role = aws_iam_role.iam_for_lambda.id
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = join("/", [path.cwd, "files", "lambda.py"])
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "lambda_function_name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.test"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn  = aws_sqs_queue.terraform_queue.arn
  function_name     = aws_lambda_function.test_lambda.arn
  starting_position = "LATEST"
}