data "aws_caller_identity" "current" {}


resource "aws_iam_role" "mock_test" {
  name = "MockTest"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    Name = "MockTest"
  }
}



resource "aws_iam_role" "test_role" {
  name = "TestRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Effect" : "Allow"
      }
    ]
  })

  permissions_boundary = aws_iam_policy.permissions_boundary.arn

  tags = {
    Name = "TestRole"
  }
}


resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
          "iam:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_policy" "permissions_boundary" {
  name = "permission_boundary"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = ["iam:List*", "iam:Get*"],
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "iam:Put*",
          "iam:Create*",
          "iam:Delete*",
          "iam:Attach*"
        ]
        Effect   = "Allow"
        Resource = "*",
        "Condition" : {
          "StringEquals" : {
            "iam:PermissionsBoundary" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/permission_boundary"
          }
        }
      },
      {
        "Sid" : "NoBoundaryDelete",
        "Effect" : "Deny",
        "Action" : ["iam:DeleteUserPermissionsBoundary", "iam:DeleteRolePermissionsBoundary"],
        "Resource" : "*"
      },
      {
        "Sid" : "NoBoundaryPolicyEdit",
        "Effect" : "Deny",
        "Action" : [
          "iam:CreatePolicyVersion",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:SetDefaultPolicyVersion"
        ],
        "Resource" : [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/permission_boundary"
        ]
      },
    ]
  })
}
