resource "aws_iam_role" "sqs_access_role" {
  name = "AWSGatewayRoleForSQS"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
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

  tags = {
    tag-key = "tag-value"
  }
}
