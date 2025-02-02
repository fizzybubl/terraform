resource "aws_organizations_policy" "allow_all" {
  name = "FullAWSAccess"
  content = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_organizations_policy" "deny_s3" {
  name = "DenyS3Access"
  content = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Deny",
        "Action" : "s3:*",
        "Resource" : "arn:aws:s3:::*"
      }
    ]
  })
}


# resource "aws_organizations_policy_attachment" "deny_s3" {
#   policy_id = aws_organizations_policy.deny_s3.id
#   target_id = aws_organizations_organizational_unit.dev.id
# }