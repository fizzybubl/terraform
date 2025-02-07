resource "aws_cognito_identity_pool" "cloudfront" {
  identity_pool_name = "google idp"

  supported_login_providers = {
    "accounts.google.com" = var.google_client_id
  }
}


resource "aws_cognito_identity_pool_roles_attachment" "federated_s3_access" {
  identity_pool_id = aws_cognito_identity_pool.cloudfront.id

  role_mapping {
    identity_provider         = "accounts.google.com"
    ambiguous_role_resolution = "AuthenticatedRole"
    type                      = "Rules"

    mapping_rule {
      claim = "email_verified"
      match_type = "Equals"
      value = "true"
      role_arn = aws_iam_role.federated_s3_access.arn
    }
  }

  roles = {
    "authenticated" = aws_iam_role.federated_s3_access.arn
  }
}