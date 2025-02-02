data "aws_caller_identity" "management" {
  provider = aws.management
}


data "aws_caller_identity" "dev" {}


data "aws_iam_role" "admin" {
  name = "OrganizationAccountAccessRole"
}


resource "aws_iam_role" "mock_user_role" {
  name = "S3RoleAccess"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.management.account_id}:root"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
} 


# resource "aws_iam_policy" "allow_s3_access" {
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:ListAllMyBuckets"
#         ],
#         "Resource" : "arn:aws:s3:::*"
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:ListBucket",
#           "s3:GetBucketLocation"
#         ],
#         "Resource" : "${module.multi_account_access["petpics3"].bucket.arn}"
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:PutObjectAcl",
#           "s3:ListBucket",
#           "s3:GetObjectTagging",
#           "s3:DeleteObject"
#         ],
#         "Resource" : "${module.multi_account_access["petpics3"].bucket.arn}/*"
#       }
#     ]
#   })

#   tags = {
#     "Name" : "Bucket Access"
#   }

# }

# resource "aws_iam_role_policy_attachment" "allow_s3_access" {
#   role       = aws_iam_role.mock_user_role.name
#   policy_arn = aws_iam_policy.allow_s3_access.arn

# }