resource "aws_iam_role" "lambda_exec_role" {
  name = "LmabdaExecRole"

  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Principal : {
        Service : ["lambda.amazonaws.com"]
      }
      Action : ["sts:AssumeRole"]
    }]
  })
}


resource "aws_iam_role_policy_attachment" "lambda_exec_role" {
  for_each   = toset(["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole", "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"])
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = each.value
}