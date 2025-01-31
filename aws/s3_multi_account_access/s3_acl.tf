# resource "aws_s3_bucket_ownership_controls" "acl" {
#   bucket = module.multi_account_access["petpics1"].bucket.id
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }


# resource "aws_s3_bucket_acl" "example" {
#   depends_on = [aws_s3_bucket_ownership_controls.acl]

#   bucket = module.multi_account_access["petpics1"].bucket.id
#   access_control_policy {
#     grant {
#       grantee {
#         id   = data.aws_canonical_user_id.dev.id
#         type = "CanonicalUser"
#       }  

#       permission = "FULL_CONTROL"
#     }

#     grant {
#       grantee {
#         id   = data.aws_canonical_user_id.management.id
#         type = "CanonicalUser"
#       }  

#       permission = "FULL_CONTROL"
#     }


#     owner {
#       id = data.aws_canonical_user_id.dev.id
#     }
#   }
# }


data "aws_canonical_user_id" "dev" {}

data "aws_canonical_user_id" "management" {
  provider = aws.management
}