resource "aws_iam_role" "sqs_access_role" {
  name = "AWSGatewayRoleForSQS"

  assume_role_policy = <<EOT
  {
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : ["apigateway.amazonaws.com"]
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  }
  EOT
}

resource "aws_iam_role_policy" "sqs_access_policy" {
  name = "SQSAccessPolicy"
  role = aws_iam_role.sqs_access_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "sqs:*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
